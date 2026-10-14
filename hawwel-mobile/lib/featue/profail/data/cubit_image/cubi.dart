import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hawwel/featue/profail/data/cubit_image/cubit_stat.dart';
import 'package:hawwel/featue/profail/data/repo_image/repo.dart';
 
 
class ChangeImageCubit extends Cubit<ChangeImageState> {
  final RepoChangeImage repo;

  ChangeImageCubit(this.repo) : super(ChangeImageInitial());

  Future<void> updateImage(String filePath) async {
    emit(ChangeImageLoading());

    final result = await repo.changeProfileImage(filePath);

    result.fold(
      (fail) => emit(ChangeImageFailure(fail.errMassage)),
      (success) => emit(ChangeImageSuccess(filePath)),
    );
  }
}
