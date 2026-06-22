import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class JobTag {
  final String label;
  final Color bg;
  final Color text;

  JobTag({
    required this.label,
    required this.bg,
    required this.text,
  });
}

class JobModel {
  final String id;              // lowongan_id (UUID)
  final String judul;           // judul (text, required)
  final String detailLowongan;  // detail_lowongan (text, nullable)
  final String requirements;    // requirements (text, nullable)
  final int? jumlahPerson;      // jumlah_person (integer, nullable)
  final String? rangeGaji;      // range_gaji (text, nullable)
  final DateTime? batasAkhir;   // batas_akhir (date, nullable)
  final String statusLoker;     // status_loker (enum: 'aktif' | lainnya)
  final DateTime? createdAt;    // created_at
  final DateTime? updatedAt;    // updated_at

  // From perusahaan relation
  final String perusahaan;      // perusahaan.nama_perusahaan
  final String lokasi;          // perusahaan.kota
  final String? alamatPerusahaan; // perusahaan.alamat_perusahaan
  final String? deskripsiPerusahaan; // perusahaan.deskripsi_perusahaan
  final String? websitePerusahaan; // perusahaan.website_perusahaan
  final String? logoPerusahaan; // perusahaan.logo

  // From relational FK tables
  final String? jabatan;        // jabatan.nama
  final String? jurusan;        // jurusan.nama
  final String? tipePekerjaan;  // tipe_pekerjaan.nama
  final String? sektor;         // sektor.nama

  final bool isApplied;
  final String? statusLamaran;
  final List<JobTag> tags;

  JobModel({
    required this.id,
    required this.judul,
    required this.detailLowongan,
    required this.requirements,
    this.jumlahPerson,
    this.rangeGaji,
    this.batasAkhir,
    required this.statusLoker,
    this.createdAt,
    this.updatedAt,
    required this.perusahaan,
    required this.lokasi,
    this.alamatPerusahaan,
    this.deskripsiPerusahaan,
    this.websitePerusahaan,
    this.logoPerusahaan,
    this.jabatan,
    this.jurusan,
    this.tipePekerjaan,
    this.sektor,
    this.isApplied = false,
    this.statusLamaran,
    this.tags = const [],
  });

  /// Tanggal batas_akhir diformat menjadi "dd MMM yyyy" (contoh: "31 Des 2025")
  String get formattedBatasAkhir {
    if (batasAkhir == null) return 'Tidak ditentukan';
    return DateFormat('dd MMM yyyy', 'id_ID').format(batasAkhir!);
  }

  /// Tampilkan jumlah_person dengan fallback '-'
  String get jumlahPersonText {
    if (jumlahPerson == null) return '-';
    return jumlahPerson.toString();
  }

  /// Tampilkan range_gaji dengan fallback 'Tidak disebutkan'
  String get rangeGajiText {
    if (rangeGaji == null || rangeGaji!.isEmpty) return 'Tidak disebutkan';
    return rangeGaji!;
  }

  /// Apakah lowongan ini masih aktif/terbuka
  bool get isAktif => statusLoker.toLowerCase() == 'aktif';

  factory JobModel.fromMap(Map<String, dynamic> map) {
    // Nested relation data
    final perusahaanData = map['perusahaan'] as Map<String, dynamic>?;
    final jabatanData    = map['jabatan']       as Map<String, dynamic>?;
    final jurusanData    = map['jurusan']       as Map<String, dynamic>?;
    final tipePekerjaanData = map['tipe_pekerjaan'] as Map<String, dynamic>?;
    final sektorData     = map['sektor']        as Map<String, dynamic>?;

    final String namaPerusahaan =
        perusahaanData?['nama_perusahaan']?.toString() ?? 'DCC Perusahaan';
    final String lokasiPerusahaan =
        perusahaanData?['kota']?.toString() ?? 'Semarang';
    final String? alamatPerusahaan = perusahaanData?['alamat_perusahaan']?.toString();
    final String? deskripsiPerusahaan = perusahaanData?['deskripsi_perusahaan']?.toString();
    final String? websitePerusahaan = perusahaanData?['website_perusahaan']?.toString();
    final String? logoUrl = perusahaanData?['logo']?.toString();

    final String? namaJabatan        = jabatanData?['nama']?.toString();
    final String? namaJurusan        = jurusanData?['nama']?.toString();
    final String? namaTipePekerjaan  = tipePekerjaanData?['nama']?.toString();
    final String? namaSektor         = sektorData?['nama']?.toString();

    // Parse batas_akhir (date) → DateTime
    DateTime? batasAkhirParsed;
    final rawBatasAkhir = map['batas_akhir'];
    if (rawBatasAkhir != null) {
      try {
        batasAkhirParsed = DateTime.parse(rawBatasAkhir.toString());
      } catch (_) {
        batasAkhirParsed = null;
      }
    }

    // Parse created_at / updated_at (timestamptz)
    DateTime? createdAtParsed;
    final rawCreatedAt = map['created_at'];
    if (rawCreatedAt != null) {
      try {
        createdAtParsed = DateTime.parse(rawCreatedAt.toString()).toLocal();
      } catch (_) {}
    }

    DateTime? updatedAtParsed;
    final rawUpdatedAt = map['updated_at'];
    if (rawUpdatedAt != null) {
      try {
        updatedAtParsed = DateTime.parse(rawUpdatedAt.toString()).toLocal();
      } catch (_) {}
    }

    int? parsedJumlahPerson;
    if (map['jumlah_person'] != null) {
      parsedJumlahPerson = int.tryParse(map['jumlah_person'].toString());
    }

    // Auto-generate tags dari data relasional
    final List<JobTag> generatedTags = _buildTags(
      tipePekerjaan: namaTipePekerjaan,
      jurusan: namaJurusan,
      sektor: namaSektor,
    );

    return JobModel(
      id: map['lowongan_id']?.toString() ?? '',
      judul: map['judul']?.toString() ?? '',
      detailLowongan: map['detail_lowongan']?.toString() ?? '',
      requirements: map['requirements']?.toString() ?? '',
      jumlahPerson: parsedJumlahPerson,
      rangeGaji: map['range_gaji']?.toString(),
      batasAkhir: batasAkhirParsed,
      statusLoker: map['status_loker']?.toString() ?? 'aktif',
      createdAt: createdAtParsed,
      updatedAt: updatedAtParsed,
      perusahaan: namaPerusahaan,
      lokasi: lokasiPerusahaan,
      alamatPerusahaan: alamatPerusahaan,
      deskripsiPerusahaan: deskripsiPerusahaan,
      websitePerusahaan: websitePerusahaan,
      logoPerusahaan: logoUrl,
      jabatan: namaJabatan,
      jurusan: namaJurusan,
      tipePekerjaan: namaTipePekerjaan,
      sektor: namaSektor,
      isApplied: map['is_applied'] == true,
      statusLamaran: map['status_lamaran']?.toString(),
      tags: generatedTags,
    );
  }

  /// Build tag chips dari data relasional
  static List<JobTag> _buildTags({
    String? tipePekerjaan,
    String? jurusan,
    String? sektor,
  }) {
    final tags = <JobTag>[];

    if (tipePekerjaan != null && tipePekerjaan.isNotEmpty) {
      tags.add(JobTag(
        label: tipePekerjaan,
        bg: const Color(0xFFD6E4FF),
        text: const Color(0xFF2D5BE3),
      ));
    }

    if (jurusan != null && jurusan.isNotEmpty) {
      tags.add(JobTag(
        label: jurusan,
        bg: const Color(0xFFE8F5E9),
        text: const Color(0xFF2E7D32),
      ));
    }

    if (sektor != null && sektor.isNotEmpty) {
      tags.add(JobTag(
        label: sektor,
        bg: const Color(0xFFFFF3E0),
        text: const Color(0xFFE65100),
      ));
    }

    return tags;
  }

  JobModel copyWith({
    String? id,
    String? judul,
    String? detailLowongan,
    String? requirements,
    int? jumlahPerson,
    String? rangeGaji,
    DateTime? batasAkhir,
    String? statusLoker,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? perusahaan,
    String? lokasi,
    String? alamatPerusahaan,
    String? deskripsiPerusahaan,
    String? websitePerusahaan,
    String? logoPerusahaan,
    String? jabatan,
    String? jurusan,
    String? tipePekerjaan,
    String? sektor,
    bool? isApplied,
    List<JobTag>? tags,
  }) {
    return JobModel(
      id: id ?? this.id,
      judul: judul ?? this.judul,
      detailLowongan: detailLowongan ?? this.detailLowongan,
      requirements: requirements ?? this.requirements,
      jumlahPerson: jumlahPerson ?? this.jumlahPerson,
      rangeGaji: rangeGaji ?? this.rangeGaji,
      batasAkhir: batasAkhir ?? this.batasAkhir,
      statusLoker: statusLoker ?? this.statusLoker,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      perusahaan: perusahaan ?? this.perusahaan,
      lokasi: lokasi ?? this.lokasi,
      alamatPerusahaan: alamatPerusahaan ?? this.alamatPerusahaan,
      deskripsiPerusahaan: deskripsiPerusahaan ?? this.deskripsiPerusahaan,
      websitePerusahaan: websitePerusahaan ?? this.websitePerusahaan,
      logoPerusahaan: logoPerusahaan ?? this.logoPerusahaan,
      jabatan: jabatan ?? this.jabatan,
      jurusan: jurusan ?? this.jurusan,
      tipePekerjaan: tipePekerjaan ?? this.tipePekerjaan,
      sektor: sektor ?? this.sektor,
      isApplied: isApplied ?? this.isApplied,
      tags: tags ?? this.tags,
    );
  }
}
