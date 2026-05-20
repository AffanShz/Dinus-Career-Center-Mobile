class BerkasLamaranModel {
  final String id;
  final String pelamarId;
  final String? pasFoto;
  final String? cv;
  final String? portofolio;
  final String? transkipNilai;
  final String? suratLamaran;

  BerkasLamaranModel({
    required this.id,
    required this.pelamarId,
    this.pasFoto,
    this.cv,
    this.portofolio,
    this.transkipNilai,
    this.suratLamaran,
  });

  factory BerkasLamaranModel.fromMap(Map<String, dynamic> map) {
    return BerkasLamaranModel(
      id: map['berkas_lamaran_id'],
      pelamarId: map['pelamar_id'],
      pasFoto: map['pas_foto'],
      cv: map['cv'],
      portofolio: map['portofolio'],
      transkipNilai: map['transkip_nilai'],
      suratLamaran: map['surat_lamaran'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'pelamar_id': pelamarId,
      if (pasFoto != null) 'pas_foto': pasFoto,
      if (cv != null) 'cv': cv,
      if (portofolio != null) 'portofolio': portofolio,
      if (transkipNilai != null) 'transkip_nilai': transkipNilai,
      if (suratLamaran != null) 'surat_lamaran': suratLamaran,
    };
  }
}

class LamaranModel {
  final String id;
  final String lowonganId;
  final String pelamarId;
  final String? berkasLamaranId;
  final String statusTerakhir;

  LamaranModel({
    required this.id,
    required this.lowonganId,
    required this.pelamarId,
    this.berkasLamaranId,
    this.statusTerakhir = 'applied',
  });

  factory LamaranModel.fromMap(Map<String, dynamic> map) {
    return LamaranModel(
      id: map['lamaran_id'],
      lowonganId: map['lowongan_id'],
      pelamarId: map['pelamar_id'],
      berkasLamaranId: map['berkas_lamaran_id'],
      statusTerakhir: map['status_terakhir'] ?? 'applied',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'lowongan_id': lowonganId,
      'pelamar_id': pelamarId,
      if (berkasLamaranId != null) 'berkas_lamaran_id': berkasLamaranId,
      'status_terakhir': statusTerakhir,
    };
  }
}
