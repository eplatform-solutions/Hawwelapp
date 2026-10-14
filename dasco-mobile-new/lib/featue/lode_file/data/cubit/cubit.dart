import 'package:bloc/bloc.dart';
import 'package:hawwel/featue/lode_file/data/cubit/cubit_state.dart';
import 'package:hawwel/featue/lode_file/data/repo/repo.dart';
 
class UploadKycCubit extends Cubit<UploadKycState> {
  final KycRepo repo;

  UploadKycCubit(this.repo) : super(UploadKycInitial());

  void reset() {
    if (state is! UploadKycInitial) emit(UploadKycInitial());
  }

  Future<void> uploadKyc(String firstFilePath, String secondFilePath) async {
    emit(UploadKycLoading());

    final result = await repo.uploadKyc(firstFilePath, secondFilePath);

    result.fold(
      (fail) => emit(UploadKycFailure(fail.errMassage)),
      (msg) => emit(UploadKycSuccess(msg)),
    );
  }
}
