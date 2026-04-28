import 'package:flutter/material.dart';

class EventModel {
  final String id;
  final String title;
  final String date;
  final String time;
  final String location;
  final String address;
  final String imageUrl;
  final String tag;
  final Color tagColor;
  final bool isBookmarked;
  final IconData locationIcon;
  final String description;
  final List<String> benefits;
  final String speakerName;
  final String speakerRole;
  final String speakerImage;
  final String price;

  EventModel({
    required this.id,
    required this.title,
    required this.date,
    required this.time,
    required this.location,
    required this.address,
    required this.imageUrl,
    required this.tag,
    required this.tagColor,
    this.isBookmarked = false,
    this.locationIcon = Icons.location_on_outlined,
    required this.description,
    required this.benefits,
    required this.speakerName,
    required this.speakerRole,
    required this.speakerImage,
    required this.price,
  });

  EventModel copyWith({
    bool? isBookmarked,
  }) {
    return EventModel(
      id: id,
      title: title,
      date: date,
      time: time,
      location: location,
      address: address,
      imageUrl: imageUrl,
      tag: tag,
      tagColor: tagColor,
      isBookmarked: isBookmarked ?? this.isBookmarked,
      locationIcon: locationIcon,
      description: description,
      benefits: benefits,
      speakerName: speakerName,
      speakerRole: speakerRole,
      speakerImage: speakerImage,
      price: price,
    );
  }
}
