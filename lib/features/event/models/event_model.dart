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
      id: json['speaker_id'],
      eventId: json['event_id'],
      name: json['nama'],
      title: json['jabatan'],
      image: json['foto'],
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
      id: json['id'],
      title: json['title'],
      slug: json['slug'],
      description: json['description'],
      imageUrl: json['image_url'],
      eventDate: DateTime.parse(json['event_date']),
      startTime: json['start_time'],
      endTime: json['end_time'],
      locationName: json['location_name'],
      address: json['address'],
      benefits: json['benefits'],
      category: json['category'],
      organizer: json['organizer'],
      maxParticipants: json['max_participants'],
      registrationLink: json['registration_link'],
      status: json['status'],
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
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

  EventModel copyWith() {
    return EventModel(
      id: id,
      title: title,
      slug: slug,
      description: description,
      imageUrl: imageUrl,
      eventDate: eventDate,
      startTime: startTime,
      endTime: endTime,
      locationName: locationName,
      address: address,
      benefits: benefits,
      category: category,
      organizer: organizer,
      maxParticipants: maxParticipants,
      registrationLink: registrationLink,
      status: status,
      createdAt: createdAt,
      updatedAt: updatedAt,
      speakers: speakers,
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
