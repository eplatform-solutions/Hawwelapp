// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:hawwel/featue/sender_information/data/repo/cubit/cubit_state.dart';
// import 'package:hawwel/featue/sender_information/data/repo/repo.dart';

// class ReceiversDisplayCubit extends Cubit<ReceiversDisplayState> {

//   ReceiversDisplayCubit(this.repo) : super(ReceiversDisplayInitial());
//  final ReceiversDisplayRepo repo;
//   Future<void> getAllReceiversDisplay() async {
//     emit(ReceiversDisplayLoading());

//     final result = await repo.getAllReceiversDisplay();

//     result.fold(
//       (failure) =>
//           emit(ReceiversDisplayFailure(failure.errMassage)),
//       (receivers) =>
//           emit(
//             ReceiversDisplaySuccess(
//               receivers: receivers,
//               message: "تم جلب المستلمين بنجاح",
//             ),
//           ),
//     );
//   }
// }
// lib/featue/sender_information/data/repo/cubit/receivers_display_cubit.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hawwel/featue/sender_information/data/model.dart';
import 'package:hawwel/featue/sender_information/data/repo/cubit/cubit_state.dart';
import 'package:hawwel/featue/sender_information/data/repo/repo.dart';

// class ReceiversDisplayCubit extends Cubit<ReceiversDisplayState> {
//   final ReceiversDisplayRepo repo;

//   ReceiversDisplayCubit(this.repo) : super(ReceiversDisplayInitial());

//   // تأكد من وجود {String? query} هنا
//   Future<void> getAllReceiversDisplay({String? query}) async {
//     emit(ReceiversDisplayLoading());

//     // هنا نمرر query إلى fullName الخاص بالـ Repo
//     final result = await repo.getAllReceiversDisplay(fullName: query);

//     result.fold(
//       (failure) => emit(ReceiversDisplayFailure(failure.errMassage)),
//       (receivers) => emit(
//         ReceiversDisplaySuccess(
//           receivers: receivers,
//           message: "تم جلب البيانات بنجاح",
//         ),
//       ),
//     );
//   }
// }
class ReceiversDisplayCubit extends Cubit<ReceiversDisplayState> {
  final ReceiversDisplayRepo repo;
  
  // ننشئ قائمة داخلية لتخزين البيانات الأصلية القادمة من السيرفر
  List<ReceiversDisplayModel> _allReceivers = [];

  ReceiversDisplayCubit(this.repo) : super(ReceiversDisplayInitial());

  // الدالة الأساسية لجلب البيانات من السيرفر (استدعيها في initState فقط)
  Future<void> getAllReceiversDisplay() async {
    emit(ReceiversDisplayLoading());

    final result = await repo.getAllReceiversDisplay();

    result.fold(
      (failure) => emit(
        ReceiversDisplayFailure(
          failure.errMassage,
          statusCode: failure.statusCode,
        ),
      ),
      (receivers) {
        _allReceivers = receivers; // نخزن النسخة الكاملة هنا
        emit(
          ReceiversDisplaySuccess(
            receivers: receivers,
            message: "تم جلب البيانات بنجاح",
          ),
        );
      },
    );
  }

  // دالة البحث المحلي (لا تطلب API ولا تظهر Loading)
  void filterReceivers(String query) {
  if (_allReceivers.isEmpty) return;

  if (query.isEmpty) {
    emit(ReceiversDisplaySuccess(receivers: _allReceivers, message: ""));
  } else {
    // الفلترة مع التأكد من أن الكائن والاسم ليسا null
    final filteredList = _allReceivers.where((receiver) {
      final name = receiver.fullName.toLowerCase();
      final search = query.toLowerCase();
      
      return name.contains(search);
    }).toList();

    emit(ReceiversDisplaySuccess(receivers: filteredList, message: ""));
  }
}
}