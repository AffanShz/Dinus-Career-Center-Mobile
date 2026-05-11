import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/job_model.dart';

class JobService {
  final _supabase = Supabase.instance.client;

  /// Fetch jobs with full relational join:
  /// lowongan → perusahaan, jabatan, jurusan, tipe_pekerjaan, sektor
  Future<List<JobModel>> fetchJobs({
    String category = 'Semua',
    String query = '',
  }) async {
    try {
      // Join semua tabel relasi sesuai schema
      var request = _supabase.from('lowongan').select('''
        *,
        perusahaan ( nama_perusahaan, kota, alamat_perusahaan ),
        jabatan ( nama ),
        jurusan ( nama ),
        tipe_pekerjaan ( nama ),
        sektor ( nama )
      ''');

      // Filter pencarian berdasarkan judul lowongan atau nama perusahaan
      if (query.isNotEmpty) {
        request = request.ilike('judul', '%$query%');
      }

      // Filter kategori berdasarkan tipe_pekerjaan.nama
      // Catatan: filter nested relation tidak bisa langsung di Supabase PostgREST,
      // jadi kita filter di sisi client setelah fetch
      final response = await request.eq('status_loker', 'aktif');

      final List<JobModel> jobs = (response as List)
          .map((data) => JobModel.fromMap(data))
          .toList();

      // Client-side filter category
      if (category != 'Semua') {
        return jobs.where((job) {
          final tipe = job.tipePekerjaan?.toLowerCase() ?? '';
          return tipe.contains(category.toLowerCase());
        }).toList();
      }

      return jobs;
    } catch (e) {
      print('Error fetching jobs from Supabase: $e');
      return [];
    }
  }

  /// Fetch single job detail by ID
  Future<JobModel?> fetchJobById(String lowonganId) async {
    try {
      final response = await _supabase
          .from('lowongan')
          .select('''
            *,
            perusahaan ( nama_perusahaan, kota, alamat_perusahaan, deskripsi_perusahaan, website_perusahaan ),
            jabatan ( nama ),
            jurusan ( nama ),
            tipe_pekerjaan ( nama ),
            sektor ( nama )
          ''')
          .eq('lowongan_id', lowonganId)
          .maybeSingle();

      if (response == null) return null;
      return JobModel.fromMap(response);
    } catch (e) {
      print('Error fetching job detail: $e');
      return null;
    }
  }
}
