// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:hawwel/featue/transaction_historu/data/cubit/cubit_state.dart';
// import 'package:hawwel/featue/transaction_historu/data/model.dart';
// import 'package:hawwel/featue/transaction_historu/data/repo/repo.dart';

// class TransfersCubit extends Cubit<TransfersState> {
//   final TransfersRepo repo;

//   int page = 1;
//   final int pageSize = 2;
//   bool hasMore = true;

//   List<TransfersByDateModel> allData = [];

//   TransfersCubit(this.repo) : super(TransfersInitial());

//   Future<void> fetchTransfers({bool loadMore = false}) async {
//     if (!hasMore && loadMore) return;

//     emit(TransfersLoading());

//     final result = await repo.getTransfers(pageNumber: page, pageSize: pageSize);

//     result.fold((fail) => emit(TransfersFailure(fail.errMassage)), (data) {
//       if (data.length < pageSize) hasMore = false;

//       if (loadMore) {
//         allData.addAll(data);
//       } else {
//         allData = data;
//       }
//       page++;
//       emit(TransfersSuccess(data: allData, hasMore: hasMore));
//     });
//   }
// }
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hawwel/featue/transaction_historu/data/cubit/cubit_state.dart';
import 'package:hawwel/featue/transaction_historu/data/model.dart';
import 'package:hawwel/featue/transaction_historu/data/repo/repo.dart';

class TransfersCubit extends Cubit<TransfersState> {
  final TransfersRepo repo;

  TransfersCubit(this.repo) : super(TransfersInitial());

  int _page = 1;
  final int _pageSize = 10;
  bool _hasMore = true;
  bool _isLoading = false;

  List<TransfersByDateModel> allData = [];

  // 🔹 جلب البيانات
  Future<void> fetchTransfers({bool loadMore = false}) async {
    if (_isLoading) return;
    if (loadMore && !_hasMore) return;

    _isLoading = true;

    // 🔹 أول مرة فقط
    if (!loadMore) {
      _page = 1;
      _hasMore = true;
      allData.clear();
      emit(TransfersLoading());
    }

    final result = await repo.getTransfers(
      pageNumber: _page,
      pageSize: _pageSize,
    );

    result.fold(
      (failure) {
        _isLoading = false;
        emit(
          TransfersFailure(
            failure.errMassage,
            statusCode: failure.statusCode,
          ),
        );
      },
      (data) {
        if (data.length < _pageSize) {
          _hasMore = false;
        }

        _page++; // 🔥 زيد الصفحة بعد النجاح
        allData.addAll(data);

        _isLoading = false;

        emit(TransfersSuccess(data: List.from(allData), hasMore: _hasMore));
      },
    );
  }
}
