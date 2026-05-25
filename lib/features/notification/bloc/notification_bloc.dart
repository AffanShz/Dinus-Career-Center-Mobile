import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'notification_event.dart';
import 'notification_state.dart';
import '../repositories/notification_repository.dart';
import '../services/realtime_notification_service.dart';
import '../models/notification_model.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final NotificationRepository _repository;
  final RealtimeNotificationService _realtimeService;
  StreamSubscription? _realtimeSubscription;

  NotificationBloc({
    required NotificationRepository repository,
    required RealtimeNotificationService realtimeService,
  })  : _repository = repository,
        _realtimeService = realtimeService,
        super(const NotificationState()) {
    on<LoadNotifications>(_onLoadNotifications);
    on<NewNotificationReceived>(_onNewNotificationReceived);
    on<MarkAsRead>(_onMarkAsRead);
    on<MarkAllAsReadEvent>(_onMarkAllAsRead);
    on<DeleteNotification>(_onDeleteNotification);
    on<ClearAllNotifications>(_onClearAllNotifications);

    _realtimeSubscription = _realtimeService.notificationStream.listen((data) {
      add(NewNotificationReceived(data));
    });
  }

  Future<void> _onLoadNotifications(
    LoadNotifications event,
    Emitter<NotificationState> emit,
  ) async {
    emit(state.copyWith(status: NotificationStatus.loading));
    try {
      final notifications = await _repository.getNotifications();
      emit(state.copyWith(
        status: NotificationStatus.success,
        notifications: notifications,
      ));
    } catch (e) {
      emit(state.copyWith(status: NotificationStatus.failure, errorMessage: e.toString()));
    }
  }

  void _onNewNotificationReceived(
    NewNotificationReceived event,
    Emitter<NotificationState> emit,
  ) {
    final newNotification = NotificationModel.fromMap(event.data);
    
    // Check if notification already exists in the list
    final bool exists = state.notifications.any((n) => n.id == newNotification.id);
    
    if (exists) {
      // If it exists, update the existing notification (e.g., if is_read changed)
      final updatedList = state.notifications.map((n) {
        return n.id == newNotification.id ? newNotification : n;
      }).toList();
      emit(state.copyWith(notifications: updatedList));
    } else {
      // If it doesn't exist, add it to the top
      final updatedList = [newNotification, ...state.notifications];
      emit(state.copyWith(notifications: updatedList));
    }
  }

  Future<void> _onMarkAsRead(
    MarkAsRead event,
    Emitter<NotificationState> emit,
  ) async {
    await _repository.markAsRead(event.id);
    final updatedList = state.notifications.map((n) {
      if (n.id == event.id) {
        return n.copyWith(isRead: true);
      }
      return n;
    }).toList();
    emit(state.copyWith(notifications: updatedList));
  }

  Future<void> _onMarkAllAsRead(
    MarkAllAsReadEvent event,
    Emitter<NotificationState> emit,
  ) async {
    await _repository.markAllAsRead();
    final updatedList = state.notifications.map((n) => n.copyWith(isRead: true)).toList();
    emit(state.copyWith(notifications: updatedList));
  }

  Future<void> _onDeleteNotification(
    DeleteNotification event,
    Emitter<NotificationState> emit,
  ) async {
    await _repository.deleteNotification(event.id);
    final updatedList = state.notifications.where((n) => n.id != event.id).toList();
    emit(state.copyWith(notifications: updatedList));
  }

  Future<void> _onClearAllNotifications(
    ClearAllNotifications event,
    Emitter<NotificationState> emit,
  ) async {
    await _repository.deleteAllNotifications();
    emit(state.copyWith(notifications: []));
  }

  @override
  Future<void> close() {
    _realtimeSubscription?.cancel();
    return super.close();
  }
}
