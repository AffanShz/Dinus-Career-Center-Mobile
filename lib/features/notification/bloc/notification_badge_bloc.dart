import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../repositories/notification_repository.dart';
import '../services/realtime_notification_service.dart';

abstract class NotificationBadgeEvent {}
class LoadUnreadCount extends NotificationBadgeEvent {}

class NotificationBadgeState {
  final int count;
  NotificationBadgeState(this.count);
}

class NotificationBadgeBloc extends Bloc<NotificationBadgeEvent, NotificationBadgeState> {
  final NotificationRepository _repository;
  final RealtimeNotificationService _realtimeService;
  StreamSubscription? _subscription;

  NotificationBadgeBloc({
    NotificationRepository? repository,
    RealtimeNotificationService? realtimeService,
  }) : _repository = repository ?? NotificationRepository(),
       _realtimeService = realtimeService ?? RealtimeNotificationService(),
       super(NotificationBadgeState(0)) {
    
    on<LoadUnreadCount>((event, emit) async {
      final count = await _repository.getUnreadCount();
      emit(NotificationBadgeState(count));
    });

    _subscription = _realtimeService.notificationStream.listen((_) {
      add(LoadUnreadCount());
    });
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
