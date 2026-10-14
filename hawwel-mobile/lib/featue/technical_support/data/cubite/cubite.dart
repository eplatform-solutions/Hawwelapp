import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hawwel/featue/technical_support/data/cubite/cubite_state.dart';
import 'package:hawwel/featue/technical_support/data/repo/repo.dart';
 
class SupportCubit extends Cubit<SupportState> {
  final SupportRepo repo;

  SupportCubit(this.repo) : super(SupportInitial());

  Future<void> fetchSupportContent() async {
    emit(SupportLoading());

    final result = await repo.getTechnicalSupport();

    result.fold(
      (failure) => emit(SupportFailure(failure.errMassage)),
      (data) => emit(SupportSuccess(data)),
    );
  }
}