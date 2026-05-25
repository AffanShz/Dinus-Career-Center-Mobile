import 'package:equatable/equatable.dart';

abstract class NotificationEvent extends Equatable {
  const NotificationEvent();

  @override
  List<Object?> get props => [];
}

class LoadNotifications extends NotificationEvent {}

class NewNotificationReceived extends NotificationEvent {
  final Map<String, dynamic> data;
  const NewNotificationReceived(this.data);

  @override
  List<Object?> get props => [data];
}

class MarkAsRead extends NotificationEvent {
  final String id;
  const MarkAsRead(this.id);

  @override
  List<Object?> get props => [id];
}

class MarkAllAsReadEvent extends NotificationEvent {}

class DeleteNotification extends NotificationEvent {
  final String id;
  const DeleteNotification(this.id);

  @override
  List<Object?> get props => [id];
}

class ClearAllNotifications extends NotificationEvent {}
