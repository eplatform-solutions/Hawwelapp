abstract class UploadKycState {}

class UploadKycInitial extends UploadKycState {}

class UploadKycLoading extends UploadKycState {}

class UploadKycSuccess extends UploadKycState {
  final String msg;
  UploadKycSuccess(this.msg);
}

class UploadKycFailure extends UploadKycState {
  final String error;
  UploadKycFailure(this.error);
}
