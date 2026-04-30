import 'package:flutter/material.dart';

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
  final String id;
  final String judul;
  final String detailLowongan;
  final String requirements;
  final String jumlahPerson;
  final String rangeGaji;
  final String batasAkhir;
  final String statusLoker;
  final String perusahaan;
  final String lokasi;

  // From relational tables
  final String? jabatan;       // jabatan.nama
  final String? jurusan;       // jurusan.nama
  final String? tipePekerjaan; // tipe_pekerjaan.nama
  final String? sektor;        // sektor.nama

  final bool isBookmarked;
  final List<JobTag> tags;

  JobModel({
    required this.id,
    required this.judul,
    required this.detailLowongan,
    required this.requirements,
    required this.jumlahPerson,
    required this.rangeGaji,
    required this.batasAkhir,
    required this.statusLoker,
    required this.perusahaan,
    required this.lokasi,
    this.jabatan,
    this.jurusan,
    this.tipePekerjaan,
    this.sektor,
    this.isBookmarked = false,
    this.tags = const [],
  });

  factory JobModel.fromMap(Map<String, dynamic> map) {
    // Nested relation data
    final perusahaanData = map['perusahaan'] as Map<String, dynamic>?;
    final jabatanData = map['jabatan'] as Map<String, dynamic>?;
    final jurusanData = map['jurusan'] as Map<String, dynamic>?;
    final tipePekerjaanData = map['tipe_pekerjaan'] as Map<String, dynamic>?;
    final sektorData = map['sektor'] as Map<String, dynamic>?;

    final String namaPerusahaan =
        perusahaanData?['nama_perusahaan'] ?? 'DCC Perusahaan';
    final String lokasiPerusahaan = perusahaanData?['kota'] ?? 'Semarang';

    final String? namaJabatan = jabatanData?['nama'];
    final String? namaJurusan = jurusanData?['nama'];
    final String? namaTipePekerjaan = tipePekerjaanData?['nama'];
    final String? namaSektor = sektorData?['nama'];

    // Auto-generate tags from relational data
    final List<JobTag> generatedTags = _buildTags(
      tipePekerjaan: namaTipePekerjaan,
      jurusan: namaJurusan,
      sektor: namaSektor,
    );

    return JobModel(
      id: map['lowongan_id']?.toString() ?? '',
      judul: map['judul'] ?? '',
      detailLowongan: map['detail_lowongan'] ?? '',
      requirements: map['requirements'] ?? '',
      jumlahPerson: map['jumlah_person']?.toString() ?? '0',
      rangeGaji: map['range_gaji'] ?? '',
      batasAkhir: map['batas_akhir'] ?? '',
      statusLoker: map['status_loker'] ?? 'aktif',
      perusahaan: namaPerusahaan,
      lokasi: lokasiPerusahaan,
      jabatan: namaJabatan,
      jurusan: namaJurusan,
      tipePekerjaan: namaTipePekerjaan,
      sektor: namaSektor,
      isBookmarked: false,
      tags: generatedTags,
    );
  }

  /// Build tag chips from relational data
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
    String? jumlahPerson,
    String? rangeGaji,
    String? batasAkhir,
    String? statusLoker,
    String? perusahaan,
    String? lokasi,
    String? jabatan,
    String? jurusan,
    String? tipePekerjaan,
    String? sektor,
    bool? isBookmarked,
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
      perusahaan: perusahaan ?? this.perusahaan,
      lokasi: lokasi ?? this.lokasi,
      jabatan: jabatan ?? this.jabatan,
      jurusan: jurusan ?? this.jurusan,
      tipePekerjaan: tipePekerjaan ?? this.tipePekerjaan,
      sektor: sektor ?? this.sektor,
      isBookmarked: isBookmarked ?? this.isBookmarked,
      tags: tags ?? this.tags,
    );
  }
}
