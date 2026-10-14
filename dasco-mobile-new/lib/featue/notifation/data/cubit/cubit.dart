import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hawwel/featue/notifation/data/cubit/cubit_stat.dart';
import 'package:hawwel/featue/notifation/data/model.dart';
import 'package:hawwel/featue/notifation/data/repo/repo.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  NotificationsCubit(this.repo) : super(NotificationsInitial());

  final NotificationsRepo repo;

  int pageNumber = 1;
  final int pageSize = 10;
  bool isFetching = false;
  bool hasMore = true;

  Future<void> fetchNotifications({bool loadMore = false}) async {
    if (isFetching) return;
    if (loadMore && !hasMore) return;

    isFetching = true;

    if (!loadMore) {
      pageNumber = 1;
      hasMore = true;
      emit(NotificationsLoading());
    }

    log('📄 Fetch page: $pageNumber');

    final result = await repo.getNotifications(
      pageNumber: pageNumber,
      pageSize: pageSize,
    );

    result.fold(
      (failure) {
        isFetching = false;
        emit(NotificationsFailure(failure.errMassage));
      },
      (response) {
        final currentList =
            state is NotificationsSuccess && loadMore
                ? (state as NotificationsSuccess).notifications
                : <NotificationModel>[];

        final newList = [...currentList, ...response.notifications];

        hasMore = response.notifications.length == pageSize;
        pageNumber++;

        isFetching = false;

        emit(
          NotificationsSuccess(
            notifications: newList,
            totalCount: response.totalCount,
            unreadCount: response.unreadCount,
            hasMore: hasMore,
          ),
        );

        log('📦 Total Loaded: ${newList.length}');
        log('📦 Has More: $hasMore');
      },
    );
  }
  
}
