// mark_all_read_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:usdt/featue/notifation/data/cubit/cubit_marke_stat.dart';
import 'package:usdt/featue/notifation/data/repo/repo.dart';
 
class MarkAllReadCubit extends Cubit<MarkAllReadState> {
  final NotificationsRepo repo;

  MarkAllReadCubit(this.repo) : super(MarkAllReadInitial());

  Future<void> markAllRead() async {
    emit(MarkAllReadLoading());

    final result = await repo.markAllAsRead();

    result.fold(
      (failure) => emit(MarkAllReadFailure(failure.errMassage)),
      (_) => emit(MarkAllReadSuccess()),
    );
  }
}
