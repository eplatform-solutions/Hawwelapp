import 'package:country_picker/country_picker.dart';
import 'package:hawwel/featue/auth/welcomyou/data/model_country.dart';
import 'package:hawwel/featue/profail/data/modal.dart';

/// سبب فشل تحديد بلد المرسل (للتشخيص والرسائل).
enum SenderCountryResolveFailure {
  missingCountryRef,
  invalidCountryRef,
}

/// نتيجة محاولة تحديد `fromCountry` للمرسل.
class SenderCountryResolveResult {
  const SenderCountryResolveResult.success(this.countryId)
      : failure = null;

  const SenderCountryResolveResult.failure(this.failure)
      : countryId = null;

  final String? countryId;
  final SenderCountryResolveFailure? failure;

  bool get isSuccess => countryId != null && countryId!.isNotEmpty;
}

/// يحدد معرّف بلد المرسل من بيانات الحساب فقط.
///
/// العقد:
/// - المصدر الأساسي: [StudentInfo.countryId] من `/users/info`
/// - المصدر الثانوي: [StudentInfo.country] إذا كان ObjectId
/// - المصدر الثالوي: [StudentInfo.country] كـ ISO يُحوَّل عبر قائمة الدول
/// - المصدر الرابع: [StudentInfo.mobilePhoneCode] أو بادئة [StudentInfo.mobilePhone]
/// - المصدر الخامس: رمز ISO من الملف أو من رقم الهاتف إذا لم يُعثر على MongoId
///   (مثلاً المرسل من CH والوجهة SY — CH ليست في قائمة دول الوجهة)
/// - لا يُستخدم `toCountry` ولا رقم المستلم
SenderCountryResolveResult resolveSenderCountryId({
  required StudentInfo user,
  List<CountryModel> destinationCountries = const [],
}) {
  final profileCountryId = user.countryId?.trim() ?? '';
  if (profileCountryId.isNotEmpty) {
    if (_isMongoId(profileCountryId)) {
      return SenderCountryResolveResult.success(profileCountryId);
    }
    return const SenderCountryResolveResult.failure(
      SenderCountryResolveFailure.invalidCountryRef,
    );
  }

  final profileCountry = user.country.trim();
  if (profileCountry.isNotEmpty) {
    if (_isMongoId(profileCountry)) {
      return SenderCountryResolveResult.success(profileCountry);
    }

    if (destinationCountries.isNotEmpty) {
      final byId = _findCountryById(destinationCountries, profileCountry);
      if (byId != null) {
        return SenderCountryResolveResult.success(byId.id);
      }

      final byCode = _findCountryByIsoCode(destinationCountries, profileCountry);
      if (byCode != null) {
        return SenderCountryResolveResult.success(byCode.id);
      }
    }
  }

  final dialCandidates = _dialCodeCandidates(user);
  for (final dial in dialCandidates) {
    final byDial = _findCountryByDialCode(destinationCountries, dial);
    if (byDial != null) {
      return SenderCountryResolveResult.success(byDial.id);
    }

    final isoFromDial = _isoFromDialCode(dial);
    if (isoFromDial != null) {
      return SenderCountryResolveResult.success(isoFromDial);
    }
  }

  final isoFromProfile = user.country.trim().toUpperCase();
  if (_isIso2CountryCode(isoFromProfile)) {
    return SenderCountryResolveResult.success(isoFromProfile);
  }

  return const SenderCountryResolveResult.failure(
    SenderCountryResolveFailure.missingCountryRef,
  );
}

List<String> _dialCodeCandidates(StudentInfo user) {
  final candidates = <String>[];
  void add(String? value) {
    final digits = value?.replaceAll(RegExp(r'[^0-9]'), '') ?? '';
    if (digits.isNotEmpty && !candidates.contains(digits)) {
      candidates.add(digits);
    }
  }

  add(user.mobilePhoneCode);
  final phone = user.mobilePhone.trim();
  if (phone.startsWith('+')) {
    add(phone.substring(1));
  } else {
    add(phone);
  }
  return candidates;
}

String? _isoFromDialCode(String rawDialCode) {
  final dial = rawDialCode.replaceAll(RegExp(r'[^0-9]'), '');
  if (dial.isEmpty) return null;

  Country? bestMatch;
  for (final country in CountryService().getAll()) {
    final code = country.phoneCode;
    if (dial == code || dial.startsWith(code)) {
      if (bestMatch == null || code.length > bestMatch.phoneCode.length) {
        bestMatch = country;
      }
    }
  }
  return bestMatch?.countryCode.toUpperCase();
}

bool _isIso2CountryCode(String value) {
  return RegExp(r'^[A-Z]{2}$').hasMatch(value);
}

CountryModel? _findCountryByDialCode(
  List<CountryModel> countries,
  String rawDialCode,
) {
  if (countries.isEmpty) return null;

  final dial = rawDialCode.replaceAll(RegExp(r'[^0-9]'), '');
  if (dial.isEmpty) return null;

  Country? bestMatch;
  for (final country in CountryService().getAll()) {
    final code = country.phoneCode;
    if (dial == code || dial.startsWith(code)) {
      if (bestMatch == null || code.length > bestMatch.phoneCode.length) {
        bestMatch = country;
      }
    }
  }

  if (bestMatch == null) return null;
  return _findCountryByIsoCode(countries, bestMatch.countryCode);
}

bool _isMongoId(String value) {
  return RegExp(r'^[a-fA-F0-9]{24}$').hasMatch(value);
}

CountryModel? _findCountryById(List<CountryModel> countries, String id) {
  for (final country in countries) {
    if (country.id == id) return country;
  }
  return null;
}

CountryModel? _findCountryByIsoCode(
  List<CountryModel> countries,
  String isoOrCode,
) {
  final upper = isoOrCode.trim().toUpperCase();
  for (final country in countries) {
    if (country.code.toUpperCase() == upper) {
      return country;
    }
  }
  return null;
}

String localizedSenderCountryFailureMessage(
  SenderCountryResolveFailure failure,
) {
  switch (failure) {
    case SenderCountryResolveFailure.missingCountryRef:
      return 'تعذر إكمال الطلب حالياً. حاول مرة أخرى';
    case SenderCountryResolveFailure.invalidCountryRef:
      return 'تعذر إكمال الطلب حالياً. حاول مرة أخرى';
  }
}
