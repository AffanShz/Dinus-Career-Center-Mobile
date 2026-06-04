class Experience {
  final String date;
  final String title;
  final String company;
  final String description;
  final bool isActive;

  Experience({
    required this.date,
    required this.title,
    required this.company,
    required this.description,
    required this.isActive,
  });

  Map<String, dynamic> toMap() {
    return {
      'date': date,
      'title': title,
      'company': company,
      'description': description,
      'isActive': isActive,
    };
  }

  factory Experience.fromMap(Map<String, dynamic> map) {
    return Experience(
      date: map['date'] ?? '',
      title: map['title'] ?? '',
      company: map['company'] ?? '',
      description: map['description'] ?? '',
      isActive: map['isActive'] ?? false,
    );
  }
}

class Education {
  final String institution;
  final String degree;
  final String period;
  final String location;

  Education({
    required this.institution,
    required this.degree,
    required this.period,
    required this.location,
  });

  Map<String, dynamic> toMap() {
    return {
      'institution': institution,
      'degree': degree,
      'period': period,
      'location': location,
    };
  }

  factory Education.fromMap(Map<String, dynamic> map) {
    return Education(
      institution: map['institution'] ?? '',
      degree: map['degree'] ?? '',
      period: map['period'] ?? '',
      location: map['location'] ?? '',
    );
  }
}

class UserProfile {
  final String id;
  final String email;
  final String name;
  final String? photoUrl;
  final String? tempatLahir;
  final String? tanggalLahir;
  final String? noKtp;
  final String? jenisKelamin;
  final String? alamat;
  final String? kota;
  final String? kodePos;
  final String? noTelepon;
  final String? noHandphone;
  final String? kewarganegaraan;
  final String? statusPerkawinan;
  final String? agama;
  final String? pendidikanTertinggi;
  final String? nim;
  final String? ipk;
  final String? bidang;
  final String? disabilitas;

  final List<String> skills;
  final List<Experience> experiences;
  final List<Education> education;

  UserProfile({
    required this.id,
    required this.email,
    required this.name,
    this.photoUrl,
    this.tempatLahir,
    this.tanggalLahir,
    this.noKtp,
    this.jenisKelamin,
    this.alamat,
    this.kota,
    this.kodePos,
    this.noTelepon,
    this.noHandphone,
    this.kewarganegaraan,
    this.statusPerkawinan,
    this.agama,
    this.pendidikanTertinggi,
    this.nim,
    this.ipk,
    this.bidang,
    this.disabilitas,
    this.skills = const [],
    this.experiences = const [],
    this.education = const [],
  });

  /// Creates a copy with some fields overridden — used for merging DB data with parsed email data
  UserProfile copyWith({
    String? id,
    String? email,
    String? name,
    String? photoUrl,
    String? tempatLahir,
    String? tanggalLahir,
    String? noKtp,
    String? jenisKelamin,
    String? alamat,
    String? kota,
    String? kodePos,
    String? noTelepon,
    String? noHandphone,
    String? kewarganegaraan,
    String? statusPerkawinan,
    String? agama,
    String? pendidikanTertinggi,
    String? nim,
    String? ipk,
    String? bidang,
    String? disabilitas,
    List<String>? skills,
    List<Experience>? experiences,
    List<Education>? education,
  }) {
    return UserProfile(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      photoUrl: photoUrl ?? this.photoUrl,
      tempatLahir: tempatLahir ?? this.tempatLahir,
      tanggalLahir: tanggalLahir ?? this.tanggalLahir,
      noKtp: noKtp ?? this.noKtp,
      jenisKelamin: jenisKelamin ?? this.jenisKelamin,
      alamat: alamat ?? this.alamat,
      kota: kota ?? this.kota,
      kodePos: kodePos ?? this.kodePos,
      noTelepon: noTelepon ?? this.noTelepon,
      noHandphone: noHandphone ?? this.noHandphone,
      kewarganegaraan: kewarganegaraan ?? this.kewarganegaraan,
      statusPerkawinan: statusPerkawinan ?? this.statusPerkawinan,
      agama: agama ?? this.agama,
      pendidikanTertinggi: pendidikanTertinggi ?? this.pendidikanTertinggi,
      nim: nim ?? this.nim,
      ipk: ipk ?? this.ipk,
      bidang: bidang ?? this.bidang,
      disabilitas: disabilitas ?? this.disabilitas,
      skills: skills ?? this.skills,
      experiences: experiences ?? this.experiences,
      education: education ?? this.education,
    );
  }

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    // Helper to normalize data from DB (lowercase) to UI format
    String? normalizeForUI(String? s) {
      if (s == null || s.isEmpty) return s;
      final lower = s.toLowerCase();
      // Handle special cases
      if (lower == 'laki-laki') return 'Laki-laki';
      // status_perkawinan: map DB enum values → UI labels
      if (lower == 'belum menikah') return 'Belum Menikah';
      if (lower == 'menikah') return 'Menikah';
      if (lower == 'cerai') return 'Cerai';
      if (lower == 'islam') return 'Islam';
      if (lower == 'kristen') return 'Kristen';
      if (lower == 'katolik') return 'Katolik';
      if (lower == 'hindu') return 'Hindu';
      if (lower == 'buddha' || lower == 'budha') return 'Buddha';
      if (lower == 'konghucu') return 'Konghucu';

      // Handle education acronyms — DB enum is UPPERCASE, keep as-is
      if ([
        'sma/smk',
        'd1',
        'd2',
        'd3',
        'd4',
        's1',
        's2',
        's3',
      ].contains(lower)) {
        return lower.toUpperCase();
      }

      // Default: Capitalize first letter
      return lower[0].toUpperCase() + lower.substring(1);
    }

    return UserProfile(
      id: map['pelamar_id'] ?? '',
      email: map['email'] ?? '',
      name: map['nama_lengkap'] ?? '',
      photoUrl: map['foto_profil'],
      tempatLahir: map['tempat_lahir'],
      tanggalLahir: map['tanggal_lahir'],
      noKtp: map['no_ktp'],
      jenisKelamin: normalizeForUI(map['jenis_kelamin']),
      alamat: map['alamat'],
      kota: map['kota'],
      kodePos: map['kode_pos']?.toString(), // Ensure it's a string
      noTelepon: map['no_telepon'],
      noHandphone: map['no_handphone'],
      kewarganegaraan: map['kewarganegaraan'],
      statusPerkawinan: normalizeForUI(map['status_perkawinan']),
      agama: normalizeForUI(map['agama']),
      pendidikanTertinggi: normalizeForUI(map['pendidikan_tertinggi']),
      nim: map['nim'],
      ipk: map['ipk']?.toString(),
      bidang: map['bidang'],
      disabilitas: map['disabilitas'],
      skills:
          (map['skills'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      experiences:
          (map['experiences'] as List<dynamic>?)
              ?.map((e) => Experience.fromMap(e as Map<String, dynamic>))
              .toList() ??
          [],
      education:
          (map['education'] as List<dynamic>?)
              ?.map((e) => Education.fromMap(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  /// Helper to convert empty string to null (Supabase enum columns reject empty strings)
  static String? _nullIfEmpty(String? s) =>
      (s == null || s.trim().isEmpty) ? null : s.trim();

  Map<String, dynamic> toMap() {
    // Convert status_perkawinan UI label → DB enum value
    String? statusPerkawinanDb;
    if (statusPerkawinan == 'Belum Menikah') {
      statusPerkawinanDb = 'belum menikah';
    } else if (statusPerkawinan == 'Menikah') {
      statusPerkawinanDb = 'menikah';
    } else if (statusPerkawinan == 'Cerai') {
      statusPerkawinanDb = 'cerai';
    }

    return {
      'pelamar_id': id,
      'email': _nullIfEmpty(email),
      'nama_lengkap': _nullIfEmpty(name),
      'foto_profil': _nullIfEmpty(photoUrl),
      'tempat_lahir': _nullIfEmpty(tempatLahir),
      'tanggal_lahir': _nullIfEmpty(tanggalLahir),
      'no_ktp': _nullIfEmpty(noKtp),
      'jenis_kelamin': _nullIfEmpty(jenisKelamin?.toLowerCase()),
      'alamat': _nullIfEmpty(alamat),
      'kota': _nullIfEmpty(kota),
      'kode_pos': _nullIfEmpty(kodePos),
      'no_telepon': _nullIfEmpty(noTelepon),
      'no_handphone': _nullIfEmpty(noHandphone),
      'kewarganegaraan': _nullIfEmpty(kewarganegaraan),
      // DB enum values: 'belum menikah' | 'menikah' | 'cerai'
      'status_perkawinan': statusPerkawinanDb,
      'agama': _nullIfEmpty(agama?.toLowerCase()),
      // DB enum values: 'SMA/SMK' | 'D1' | 'D2' | 'D3' | 'D4' | 'S1' | 'S2' | 'S3'
      'pendidikan_tertinggi': _nullIfEmpty(pendidikanTertinggi),
      'nim': _nullIfEmpty(nim),
      'ipk': (ipk != null && ipk!.isNotEmpty) ? double.tryParse(ipk!) : null,
      'bidang': _nullIfEmpty(bidang),
      'disabilitas': disabilitas,
      'skills': skills,
      'experiences': experiences.map((e) => e.toMap()).toList(),
      'education': education.map((e) => e.toMap()).toList(),
    };
  }

  double get completionPercentage {
    final fields = [
      name,
      photoUrl,
      tempatLahir,
      tanggalLahir,
      noKtp,
      jenisKelamin,
      alamat,
      kota,
      noHandphone,
      nim,
      ipk,
      bidang,
    ];

    int filledCount = fields
        .where((f) => f != null && f.toString().isNotEmpty)
        .length;

    // Add logic for lists
    if (skills.isNotEmpty) filledCount++;
    if (experiences.isNotEmpty) filledCount++;
    if (education.isNotEmpty) filledCount++;

    const totalFields = 15; // 12 basic fields + 3 lists
    return (filledCount / totalFields).clamp(0.0, 1.0);
  }
}
