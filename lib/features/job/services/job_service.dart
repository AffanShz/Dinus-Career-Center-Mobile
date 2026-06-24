import 'package:dcc_mobile/core/utils/app_logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/job_model.dart';
import '../../auth/services/auth_service.dart';

class JobService {
  final _supabase = Supabase.instance.client;

  /// Fetch jobs dengan full relational join:
  /// lowongan → perusahaan, jabatan, jurusan, tipe_pekerjaan, sektor
  Future<List<JobModel>> fetchJobs({
    String category = 'Semua',
    String query = '',
    String? sektor,
    String? jurusan,
    String? lokasi,
    String? namaPerusahaan,
  }) async {
    try {
      final user = AuthService.currentUser;

      final tipePekerjaanJoin = category != 'Semua' ? 'tipe_pekerjaan!inner ( nama )' : 'tipe_pekerjaan ( nama )';
      final sektorJoin = sektor != null && sektor.isNotEmpty ? 'sektor!inner ( nama )' : 'sektor ( nama )';
      final jurusanJoin = jurusan != null && jurusan.isNotEmpty ? 'jurusan!inner ( nama )' : 'jurusan ( nama )';
      final bool needsPerusahaanInner = (lokasi != null && lokasi.isNotEmpty) || (namaPerusahaan != null && namaPerusahaan.isNotEmpty);
      final perusahaanJoin = needsPerusahaanInner 
          ? 'perusahaan!inner ( nama_perusahaan, kota, alamat_perusahaan, deskripsi_perusahaan, website_perusahaan, logo )' 
          : 'perusahaan ( nama_perusahaan, kota, alamat_perusahaan, deskripsi_perusahaan, website_perusahaan, logo )';

      // Join semua tabel relasi sesuai schema lowongan
      var request = _supabase.from('lowongan').select('''
        *,
        $perusahaanJoin,
        jabatan ( nama ),
        $jurusanJoin,
        $tipePekerjaanJoin,
        $sektorJoin
      ''');

      // Filter hanya lowongan yang aktif (berdasarkan enum status_loker)
      request = request.eq('status_loker', 'aktif');

      // Ambil tanggal hari ini (Y-m-d format for Supabase comparison)
      final String today = DateTime.now().toIso8601String().split('T').first;
      
      // PostgREST doesn't support complex OR conditions (batas_akhir is null OR batas_akhir >= today) 
      // directly in a simple select easily without gte filter. 
      // We'll apply the gte filter and handle nulls or perform client-side final check if needed.
      request = request.or('batas_akhir.is.null,batas_akhir.gte.$today');

      // Filter pencarian berdasarkan kategori (tipe pekerjaan) di sisi DB
      if (category != 'Semua') {
        request = request.ilike('tipe_pekerjaan.nama', category);
      }

      // Advanced filters
      if (sektor != null && sektor.isNotEmpty) {
        request = request.ilike('sektor.nama', sektor);
      }
      if (jurusan != null && jurusan.isNotEmpty) {
        request = request.ilike('jurusan.nama', jurusan);
      }
      if (namaPerusahaan != null && namaPerusahaan.isNotEmpty) {
        request = request.eq('perusahaan.nama_perusahaan', namaPerusahaan);
      }
      if (lokasi != null && lokasi.isNotEmpty) {
        request = request.ilike('perusahaan.kota', lokasi);
      }

      // Filter pencarian berdasarkan judul lowongan
      if (query.isNotEmpty) {
        request = request.ilike('judul', '%$query%');
      }

      // Limit jumlah data untuk performa
      final response = await request.limit(20);

      // Ambil daftar lowongan_id yang sudah dilamar oleh user jika login
      Map<String, String> appliedJobMap = {};
      if (user != null) {
        final applications = await _supabase
            .from('lamaran')
            .select('lowongan_id, status_terakhir')
            .eq('pelamar_id', user.id);
        
        for (var a in (applications as List)) {
          appliedJobMap[a['lowongan_id'].toString()] = a['status_terakhir']?.toString() ?? 'applied';
        }
      }

      final List<JobModel> jobs = (response as List).map((data) {
        final String lowonganId = data['lowongan_id'].toString();
        final Map<String, dynamic> mutableData = Map<String, dynamic>.from(data);
        final status = appliedJobMap[lowonganId];
        mutableData['status_lamaran'] = status;
        mutableData['is_applied'] = status != null && status != 'cancelled';
        return JobModel.fromMap(mutableData);
      }).toList();

      return jobs;
    } catch (e) {
      // ignore: avoid_print
      appLog('Error fetching jobs from Supabase: $e');
      rethrow;
    }
  }

  /// Fetch single job detail by lowongan_id (UUID)
  Future<JobModel?> fetchJobById(String lowonganId) async {
    try {
      final user = AuthService.currentUser;
      final response = await _supabase
          .from('lowongan')
          .select('''
            *,
            perusahaan (
              nama_perusahaan,
              kota,
              alamat_perusahaan,
              deskripsi_perusahaan,
              website_perusahaan,
              logo
            ),
            jabatan ( nama ),
            jurusan ( nama ),
            tipe_pekerjaan ( nama ),
            sektor ( nama )
          ''')
          .eq('lowongan_id', lowonganId)
          .maybeSingle();

      if (response == null) return null;

      final Map<String, dynamic> mutableResponse = Map<String, dynamic>.from(response as Map);
      
      if (user != null) {
        final existingApplication = await _supabase
            .from('lamaran')
            .select('status_terakhir')
            .eq('lowongan_id', lowonganId)
            .eq('pelamar_id', user.id)
            .maybeSingle();
        
        if (existingApplication != null) {
          final status = existingApplication['status_terakhir']?.toString() ?? 'applied';
          mutableResponse['status_lamaran'] = status;
          mutableResponse['is_applied'] = status != 'cancelled';
        } else {
          mutableResponse['is_applied'] = false;
        }
      }

      return JobModel.fromMap(mutableResponse);
    } catch (e) {
      // ignore: avoid_print
      appLog('Error fetching job detail: $e');
      return null;
    }
  }

  /// Fetch filter options for bottom sheet
  Future<Map<String, List<String>>> fetchFilterOptions() async {
    try {
      final sektorRes = await _supabase.from('sektor').select('nama');
      final jurusanRes = await _supabase.from('jurusan').select('nama');
      final kotaRes = await _supabase.from('perusahaan').select('kota');

      final List<String> sektorList = (sektorRes as List)
          .map((e) => e['nama'].toString())
          .toSet()
          .toList();
      sektorList.sort();

      final List<String> jurusanList = (jurusanRes as List)
          .map((e) => e['nama'].toString())
          .toSet()
          .toList();
      jurusanList.sort();

      final List<String> kotaList = (kotaRes as List)
          .map((e) => e['kota']?.toString() ?? '')
          .where((k) => k.isNotEmpty)
          .toSet()
          .toList();
      kotaList.sort();

      return {
        'sektor': sektorList,
        'jurusan': jurusanList,
        'lokasi': kotaList,
      };
    } catch (e) {
      appLog('Error fetching filter options: $e');
      return {
        'sektor': [],
        'jurusan': [],
        'lokasi': [],
      };
    }
  }
}
