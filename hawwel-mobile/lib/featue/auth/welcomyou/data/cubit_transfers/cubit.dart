import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:usdt/featue/auth/welcomyou/data/cubit/cubit.dart';
import 'package:usdt/featue/auth/welcomyou/data/cubit/cubit_stat.dart';
import 'package:usdt/featue/auth/welcomyou/data/cubit_airea/cubit.dart';
import 'package:usdt/featue/auth/welcomyou/data/cubit_airea/cubit_stat.dart';
import 'package:usdt/featue/auth/welcomyou/data/cubit_amount_to_send.dart';
import 'package:usdt/featue/auth/welcomyou/data/cubit_city/cubit_city.dart';
import 'package:usdt/featue/auth/welcomyou/data/cubit_city/cubit_stat_city.dart';
import 'package:usdt/featue/auth/welcomyou/data/cubit_conversion_methods/cubit.dart';
import 'package:usdt/featue/auth/welcomyou/data/cubit_conversion_methods/cubit_stat.dart';
import 'package:usdt/featue/auth/welcomyou/data/cubit_transfers/cubit_stat.dart';
import 'package:usdt/featue/auth/welcomyou/data/model_transfer.dart';
import 'package:usdt/featue/auth/welcomyou/data/repo_trnsfer/repo.dart';

class TransferCubit extends Cubit<TransferState> {
  final TransferRepo repo;

  TransferCubit(this.repo) : super(TransferInitial());

  Future<void> submitTransfer({
    required BuildContext context,
    required String fullName,
    required String phone,
  }) async {
    emit(TransferLoading());

    final country = context.read<CountriesCubit>().state;
    final city = context.read<CitiesCubit>().state;
    final area = context.read<AreasCubit>().state;
    final method = context.read<PaymentMethodsCubit>().state;
    final currencyState = context.read<CurrencyCubit>().state;
    if (country is! CountriesSuccess ||
        currencyState.amount == "" ||
        city is! CitiesSuccess ||
        area is! AreasSuccess ||
        method is! PaymentMethodsSuccess ||
        method.selected == null ||
        city.selected == null ||
        area.selected == null) {
      emit(TransferFailure('يرجى اختيار جميع البيانات'));
      return;
    }

    final model = TransferRequestModel(
      // kkk: "6940072016b8e8a020d089c0",
      symbol: currencyState.currency == CurrencyType.usdt ? "USDT" : "USDC",
      amount: double.parse(currencyState.amount),
      toCountry: country.selected.id,
      city: city.selected!.id,
      area: area.selected!.id,
      paymentMethod: method.selected!.id,
      fullName: fullName,
      mobilePhone: phone,
    );

    // final result = await repo.sendTransfer(model);
    // currencyState.amount == '';
    // result.fold(
    //   (fail) => emit(TransferFailure(fail.errMassage)),
    //   (_) => emit(TransferSuccess()),
    // );
    final result = await repo.sendTransfer(model);

    result.fold(
      (fail) => emit(TransferFailure(fail.errMassage)),
      (transfer) => emit(TransferSuccess(transfer)),
    );
  }
}
