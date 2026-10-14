import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hawwel/featue/auth/welcomyou/data/cubit/cubit.dart';
import 'package:hawwel/featue/auth/welcomyou/data/cubit/cubit_stat.dart';
import 'package:hawwel/featue/auth/welcomyou/data/cubit_airea/cubit.dart';
import 'package:hawwel/featue/auth/welcomyou/data/cubit_amount_to_send.dart';
import 'package:hawwel/featue/auth/welcomyou/data/cubit_city/cubit_city.dart';
import 'package:hawwel/featue/auth/welcomyou/data/cubit_conversion_methods/cubit.dart';
import 'package:hawwel/featue/auth/welcomyou/data/cubit_country_payment_methods/cubit.dart';
import 'package:hawwel/featue/auth/welcomyou/data/cubit_transfers/cubit_stat.dart';
import 'package:hawwel/featue/auth/welcomyou/data/model_transfer.dart';
import 'package:hawwel/featue/auth/welcomyou/data/repo_trnsfer/repo.dart';
import 'package:hawwel/featue/auth/welcomyou/data/resolved_payment_selection.dart';
import 'package:hawwel/featue/auth/welcomyou/data/sender_country_resolver.dart';
import 'package:hawwel/featue/profail/data/kyc_status_helper.dart';
import 'package:hawwel/featue/profail/data/cubit/cubit.dart';
import 'package:hawwel/featue/profail/data/cubit/cubit_stat.dart';

class TransferCubit extends Cubit<TransferState> {
  final TransferRepo repo;

  TransferCubit(this.repo) : super(TransferInitial());

  Future<void> submitTransfer({
    required BuildContext context,
    required String fullName,
    required String receiverPhone,
  }) async {
    debugPrint('🚀 [TRANSFER] submitTransfer started');
    emit(TransferLoading());

    final country = context.read<CountriesCubit>().state;
    final city = context.read<CitiesCubit>().state;
    final area = context.read<AreasCubit>().state;
    final method = context.read<PaymentMethodsCubit>().state;
    final countryMethod = context.read<CountryPaymentMethodsCubit>().state;
    final currencyState = context.read<CurrencyCubit>().state;
    final resolvedSelection = resolvePaymentSelection(
      cityState: city,
      areaState: area,
      paymentState: method,
      countryPaymentState: countryMethod,
    );
    debugPrint(
      '🧪 [TRANSFER] preflight ui-state | country=${country.runtimeType} | city=${city.runtimeType} | area=${area.runtimeType} | method=${method.runtimeType} | countryMethod=${countryMethod.runtimeType} | resolved=${resolvedSelection == null ? 'none' : (resolvedSelection.isCountryLevel ? 'country-level' : 'region')} | amount=${currencyState.amount}',
    );
    if (country is! CountriesSuccess ||
        currencyState.amount == "" ||
        resolvedSelection == null) {
      emit(TransferFailure('يرجى اختيار جميع البيانات'));
      return;
    }

    final userInfoCubit = context.read<Userinfogcubit>();
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    debugPrint('📥 [TRANSFER] fetching /users/info before submit');
    await userInfoCubit.fetchUserInfo();
    final userState = userInfoCubit.state;

    if (userState is! UserinfoSuccessState) {
      debugPrint('❌ [TRANSFER] /users/info failed | state=${userState.runtimeType}');
      if (userState is UserinfoFailureState) {
        emit(
          TransferFailure(
            userState.error.isNotEmpty
                ? userState.error
                : 'تعذر تحميل بيانات المرسل. يرجى المحاولة مرة أخرى',
            statusCode: userState.statusCode,
          ),
        );
      } else {
        emit(
          TransferFailure(
            'تعذر تحميل بيانات المرسل. يرجى المحاولة مرة أخرى',
          ),
        );
      }
      return;
    }

    if (!KycStatusHelper.canTransfer(userState.user)) {
      emit(
        TransferFailure(
          KycStatusHelper.gateMessage(userState.user, isArabic),
          statusCode: 403,
          errorCode: 'KYC_REQUIRED',
        ),
      );
      return;
    }

    final resolveResult = resolveSenderCountryId(
      user: userState.user,
      destinationCountries: country.countries,
    );
    debugPrint(
      '🧪 [TRANSFER] sender-country input | country=${userState.user.country} | countryId=${userState.user.countryId} | destinationCount=${country.countries.length}',
    );

    if (!resolveResult.isSuccess) {
      final failure = resolveResult.failure!;
      final profileCountry = userState.user.country.trim().toUpperCase();
      final hasProfileIsoInDestination = country.countries.any(
        (c) => c.code.toUpperCase() == profileCountry,
      );
      final firstCodes = country.countries
          .take(8)
          .map((c) => '${c.code}:${c.id}')
          .join(', ');
      debugPrint(
        '⚠️ [TRANSFER] senderCountry preflight failed | reason=$failure | country=${userState.user.country} | countryId=${userState.user.countryId} | profileIsoInDestination=$hasProfileIsoInDestination',
      );
      debugPrint('🧪 [TRANSFER] destination countries sample => $firstCodes');
      log(
        '⚠️ senderCountry preflight failed | reason=$failure | country=${userState.user.country} | countryId=${userState.user.countryId} | destinationCountriesCount=${country.countries.length} | profileIsoInDestination=$hasProfileIsoInDestination',
      );
      emit(
        TransferFailure(
          'تعذر إكمال الطلب حالياً. حاول مرة أخرى',
        ),
      );
      return;
    }

    final fromCountryId = resolveResult.countryId!;
    final resolvedAsIso = !_isMongoObjectId(fromCountryId);
    debugPrint(
      '✅ [TRANSFER] sender country resolved | fromCountry=$fromCountryId | resolvedAsIso=$resolvedAsIso | toCountry=${country.selected.id}',
    );

    final model = TransferRequestModel(
      symbol: SendCurrencyHelper.apiSymbolFor(currencyState.currency),
      amount: double.parse(currencyState.amount),
      fromCountry: fromCountryId,
      toCountry: country.selected.id,
      // Sent together, or not at all: a country-level pick (no city/region
      // in the flow) omits both so the backend validates the payment
      // method against the country binding instead of the area binding.
      city: resolvedSelection.isCountryLevel ? null : resolvedSelection.city!.id,
      area: resolvedSelection.isCountryLevel ? null : resolvedSelection.area!.id,
      paymentMethod: resolvedSelection.method.id,
      fullName: fullName,
      mobilePhone: receiverPhone,
    );

    final result = await repo.sendTransfer(model);

    result.fold(
      (fail) {
        debugPrint(
          '❌ [TRANSFER] sendTransfer failed | status=${fail.statusCode} | message=${fail.errMassage}',
        );
        emit(
          TransferFailure(
            fail.errMassage,
            statusCode: fail.statusCode,
            errorCode: fail.errorCode,
          ),
        );
      },
      (transfer) {
        debugPrint('✅ [TRANSFER] sendTransfer success');
        emit(TransferSuccess(transfer));
      },
    );
  }
}

bool _isMongoObjectId(String value) {
  return RegExp(r'^[a-fA-F0-9]{24}$').hasMatch(value);
}
