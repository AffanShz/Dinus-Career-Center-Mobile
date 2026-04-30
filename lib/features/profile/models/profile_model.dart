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
    return UserProfile(
      id: map['pelamar_id'] ?? '',
      email: map['email'] ?? '',
      name: map['nama_lengkap'] ?? '',
      photoUrl: map['foto_profil'],
      tempatLahir: map['tempat_lahir'],
      tanggalLahir: map['tanggal_lahir'],
      noKtp: map['no_ktp'],
      jenisKelamin: map['jenis_kelamin'],
      alamat: map['alamat'],
      kota: map['kota'],
      kodePos: map['kode_pos'],
      noTelepon: map['no_telepon'],
      noHandphone: map['no_handphone'],
      kewarganegaraan: map['kewarganegaraan'],
      statusPerkawinan: map['status_perkawinan'],
      agama: map['agama'],
      pendidikanTertinggi: map['pendidikan_tertinggi'],
      nim: map['nim'],
      ipk: map['ipk']?.toString(),
      bidang: map['bidang'],
      disabilitas: map['disabilitas'],
      // Skills, Experiences, Education usually come from separate tables or JSON columns
      // For now, keeping them empty or as placeholders
      skills: [], 
      experiences: [],
      education: [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nama_lengkap': name,
      'foto_profil': photoUrl,
      'tempat_lahir': tempatLahir,
      'tanggal_lahir': tanggalLahir,
      'no_ktp': noKtp,
      'jenis_kelamin': jenisKelamin,
      'alamat': alamat,
      'kota': kota,
      'kode_pos': kodePos,
      'no_telepon': noTelepon,
      'no_handphone': noHandphone,
      'kewarganegaraan': kewarganegaraan,
      'status_perkawinan': statusPerkawinan,
      'agama': agama,
      'pendidikan_tertinggi': pendidikanTertinggi,
      'nim': nim,
      'ipk': ipk != null ? double.tryParse(ipk!) : null,
      'bidang': bidang,
      'disabilitas': disabilitas,
    };
  }
}

