import 'package:equatable/equatable.dart';

class EventSpeaker extends Equatable {
  final int id;
  final int eventId;
  final String name;
  final String? title;
  final String? image;
  final int urutan;

  const EventSpeaker({
    required this.id,
    required this.eventId,
    required this.name,
    this.title,
    this.image,
    this.urutan = 1,
  });

  factory EventSpeaker.fromJson(Map<String, dynamic> json) {
    return EventSpeaker(
      id: json['speaker_id'] ?? 0,
      eventId: json['event_id'] ?? 0,
      name: json['nama']?.toString() ?? 'Speaker',
      title: json['jabatan']?.toString(),
      image: json['foto']?.toString(),
      urutan: json['urutan'] ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'speaker_id': id,
      'event_id': eventId,
      'nama': name,
      'jabatan': title,
      'foto': image,
      'urutan': urutan,
    };
  }

  @override
  List<Object?> get props => [id, eventId, name, title, image, urutan];
}

class EventModel extends Equatable {
  final int id;
  final String title;
  final String? slug;
  final String? description;
  final String? imageUrl;
  final DateTime eventDate;
  final String startTime;
  final String? endTime;
  final String? locationName;
  final String? address;
  final String? benefits;
  final String? category;
  final String? organizer;
  final int? maxParticipants;
  final String? registrationLink;
  final String? status;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<EventSpeaker> speakers;

  const EventModel({
    required this.id,
    required this.title,
    this.slug,
    this.description,
    this.imageUrl,
    required this.eventDate,
    required this.startTime,
    this.endTime,
    this.locationName,
    this.address,
    this.benefits,
    this.category,
    this.organizer,
    this.maxParticipants,
    this.registrationLink,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.speakers = const [],
  });

  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      id: json['id'] ?? 0,
      title: json['title']?.toString() ?? 'Unknown Event',
      slug: json['slug']?.toString(),
      description: json['description']?.toString(),
      imageUrl: json['image_url']?.toString(),
      eventDate: DateTime.tryParse(json['event_date']?.toString() ?? '') ?? DateTime.now(),
      startTime: json['start_time']?.toString() ?? '00:00',
      endTime: json['end_time']?.toString(),
      locationName: json['location_name']?.toString(),
      address: json['address']?.toString(),
      benefits: json['benefits']?.toString(),
      category: json['category']?.toString(),
      organizer: json['organizer']?.toString(),
      maxParticipants: json['max_participants'] is int 
          ? json['max_participants'] 
          : int.tryParse(json['max_participants']?.toString() ?? ''),
      registrationLink: json['registration_link']?.toString(),
      status: json['status']?.toString(),
      createdAt: json['created_at'] != null ? DateTime.tryParse(json['created_at'].toString()) : null,
      updatedAt: json['updated_at'] != null ? DateTime.tryParse(json['updated_at'].toString()) : null,
      speakers: (json['event_speakers'] as List<dynamic>?)
              ?.map((s) => EventSpeaker.fromJson(s as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'slug': slug,
      'description': description,
      'image_url': imageUrl,
      'event_date': eventDate.toIso8601String(),
      'start_time': startTime,
      'end_time': endTime,
      'location_name': locationName,
      'address': address,
      'benefits': benefits,
      'category': category,
      'organizer': organizer,
      'max_participants': maxParticipants,
      'registration_link': registrationLink,
      'status': status,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'event_speakers': speakers.map((s) => s.toJson()).toList(),
    };
  }

  EventModel copyWith({
    int? id,
    String? title,
    String? slug,
    String? description,
    String? imageUrl,
    DateTime? eventDate,
    String? startTime,
    String? endTime,
    String? locationName,
    String? address,
    String? benefits,
    String? category,
    String? organizer,
    int? maxParticipants,
    String? registrationLink,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<EventSpeaker>? speakers,
  }) {
    return EventModel(
      id: id ?? this.id,
      title: title ?? this.title,
      slug: slug ?? this.slug,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      eventDate: eventDate ?? this.eventDate,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      locationName: locationName ?? this.locationName,
      address: address ?? this.address,
      benefits: benefits ?? this.benefits,
      category: category ?? this.category,
      organizer: organizer ?? this.organizer,
      maxParticipants: maxParticipants ?? this.maxParticipants,
      registrationLink: registrationLink ?? this.registrationLink,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      speakers: speakers ?? this.speakers,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        slug,
        description,
        imageUrl,
        eventDate,
        startTime,
        endTime,
        locationName,
        address,
        benefits,
        category,
        organizer,
        maxParticipants,
        registrationLink,
        status,
        createdAt,
        updatedAt,
        speakers,
      ];
}
