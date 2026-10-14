import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:usdt/featue/lode_file/data/cubit/cubit_state.dart';
import 'package:usdt/featue/lode_file/data/repo/repo.dart';
 
class UploadKycCubit extends Cubit<UploadKycState> {
  final KycRepo repo;

  UploadKycCubit(this.repo) : super(UploadKycInitial());

  Future<void> uploadKyc(String filePath) async {
    emit(UploadKycLoading());

    final result = await repo.uploadKyc(filePath);

    result.fold(
      (fail) => emit(UploadKycFailure(fail.errMassage)),
      (msg) => emit(UploadKycSuccess(msg)),
    );
  }
}
