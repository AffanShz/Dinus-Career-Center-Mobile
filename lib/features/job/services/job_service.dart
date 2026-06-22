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
  }) async {
    try {
      final user = AuthService.currentUser;

      // Join semua tabel relasi sesuai schema lowongan
      var request = _supabase.from('lowongan').select('''
        *,
        perusahaan ( nama_perusahaan, kota, alamat_perusahaan, logo ),
        jabatan ( nama ),
        jurusan ( nama ),
        tipe_pekerjaan ( nama ),
        sektor ( nama )
      ''');

      // Filter hanya lowongan yang aktif (berdasarkan enum status_loker)
      request = request.eq('status_loker', 'aktif');

      // Ambil tanggal hari ini (Y-m-d format for Supabase comparison)
      final String today = DateTime.now().toIso8601String().split('T')[0];
      
      // PostgREST doesn't support complex OR conditions (batas_akhir is null OR batas_akhir >= today) 
      // directly in a simple select easily without gte filter. 
      // We'll apply the gte filter and handle nulls or perform client-side final check if needed.
      request = request.or('batas_akhir.is.null,batas_akhir.gte.$today');

      // Filter pencarian berdasarkan judul lowongan
      if (query.isNotEmpty) {
        request = request.ilike('judul', '%$query%');
      }

      // Limit jumlah data untuk performa
      final response = await request.limit(20);

      // Ambil daftar lowongan_id yang sudah dilamar oleh user jika login
      Set<String> appliedJobIds = {};
      if (user != null) {
        final applications = await _supabase
            .from('lamaran')
            .select('lowongan_id')
            .eq('pelamar_id', user.id);
        
        appliedJobIds = (applications as List)
            .map((a) => a['lowongan_id'].toString())
            .toSet();
      }

      final List<JobModel> jobs = (response as List).map((data) {
        final String lowonganId = data['lowongan_id'].toString();
        final Map<String, dynamic> mutableData = Map<String, dynamic>.from(data);
        mutableData['is_applied'] = appliedJobIds.contains(lowonganId);
        return JobModel.fromMap(mutableData);
      }).toList();

      // Client-side filter berdasarkan tipe_pekerjaan.nama
      // (filter nested relation tidak didukung langsung oleh PostgREST)
      // Exact match filter — prevents 'Part-time' matching 'Full-time'
      if (category != 'Semua') {
        return jobs.where((job) {
          final tipe = job.tipePekerjaan?.toLowerCase() ?? '';
          return tipe == category.toLowerCase();
        }).toList();
      }

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
            .select()
            .eq('lowongan_id', lowonganId)
            .eq('pelamar_id', user.id)
            .maybeSingle();
        
        mutableResponse['is_applied'] = existingApplication != null;
      }

      return JobModel.fromMap(mutableResponse);
    } catch (e) {
      // ignore: avoid_print
      appLog('Error fetching job detail: $e');
      return null;
    }
  }
}
