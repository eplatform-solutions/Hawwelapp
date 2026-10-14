import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hawwel/featue/profail/data/cubit/cubit_stat.dart';
import 'package:hawwel/featue/profail/data/repo/repo.dart';

class Userinfogcubit extends Cubit<UserinfoState> {
  Userinfogcubit(this.repo) : super(UserinfoInitialState());

  final Repouserinfo repo;
  bool _isFetching = false;

  Future<void> fetchUserInfo() async {
    if (_isFetching) return;
    _isFetching = true;
    emit(UserinfoLoadingState());

    var result = await repo.get_user_info();

    result.fold(
      (fail) => emit(
        UserinfoFailureState(
          error: fail.errMassage,
          statusCode: fail.statusCode,
        ),
      ),
      (user) => emit(UserinfoSuccessState(user: user)),
    );
    _isFetching = false;
  }
}
