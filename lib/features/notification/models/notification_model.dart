import 'package:equatable/equatable.dart';

class NotificationModel extends Equatable {
  final String id;
  final String judul;
  final String pesan;
  final String tipe;
  final String? lamaranId;
  final String? linkZoom;
  final bool isRead;
  final DateTime createdAt;

  const NotificationModel({
    required this.id,
    required this.judul,
    required this.pesan,
    required this.tipe,
    this.lamaranId,
    this.linkZoom,
    this.isRead = false,
    required this.createdAt,
  });

  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
      id: map['notifikasi_id']?.toString() ?? '',
      judul: map['judul']?.toString() ?? '',
      pesan: map['pesan']?.toString() ?? '',
      tipe: map['tipe']?.toString() ?? 'umum',
      lamaranId: map['lamaran_id']?.toString(),
      linkZoom: map['link_zoom']?.toString(),
      isRead: map['is_read'] ?? false,
      createdAt: DateTime.parse(map['created_at'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'notifikasi_id': id,
      'judul': judul,
      'pesan': pesan,
      'tipe': tipe,
      'lamaran_id': lamaranId,
      'link_zoom': linkZoom,
      'is_read': isRead,
      'created_at': createdAt.toIso8601String(),
    };
  }

  NotificationModel copyWith({
    String? id,
    String? judul,
    String? pesan,
    String? tipe,
    String? lamaranId,
    String? linkZoom,
    bool? isRead,
    DateTime? createdAt,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      judul: judul ?? this.judul,
      pesan: pesan ?? this.pesan,
      tipe: tipe ?? this.tipe,
      lamaranId: lamaranId ?? this.lamaranId,
      linkZoom: linkZoom ?? this.linkZoom,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [id, judul, pesan, tipe, lamaranId, linkZoom, isRead, createdAt];
}
