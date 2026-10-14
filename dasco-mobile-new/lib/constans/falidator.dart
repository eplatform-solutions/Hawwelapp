// import 'package:flutter/material.dart';

// String? validatePhoneNumber(value, BuildContext context) {
//   if (value == null || value.isEmpty) {
//     return 'mobile_number_error1';
//   }
//   if (!RegExp(r'^[0-9\u0660-\u0669]{10}$').hasMatch(value)) {
//     return 'mobile_number_error2';
//   }
//   return null;
// }

// String? valedatotp(value, BuildContext context) {
//   if (value == null || value.isEmpty) {
//     return 'enter_otp';
//   }

//   return null;
// }

// String? validatePasswordl(String? value) {
//   if (value == null || value.isEmpty) {
//     return 'الرجاء إدخال كلمة المرور';
//   }

//   if (value.length < 8) {
//     return 'يجب أن تكون كلمة المرور 8 محارف على الأقل';
//   }

//   if (!RegExp(r'[A-Z]').hasMatch(value)) {
//     return 'يجب أن تحتوي على حرف كبير واحد على الأقل';
//   }

//   if (!RegExp(r'[a-z]').hasMatch(value)) {
//     return 'يجب أن تحتوي على حرف صغير واحد على الأقل';
//   }

//   if (!RegExp(r'[0-9]').hasMatch(value)) {
//     return 'يجب أن تحتوي على رقم واحد على الأقل';
//   }

//   if (!RegExp(r'[@!#\$%\^&\*]').hasMatch(value)) {
//     return 'يجب أن تحتوي على رمز واحد على الأقل';
//   }

//   return null;
// }

// String? validatePassword(String? value, BuildContext context) {
//   if (value == null || value.isEmpty) {
//     return "الرجاء إدخال كلمة المرور";
//   }

//   // الطول
//   if (value.length < 8) {
//     return "يجب أن تكون كلمة المرور 8 محارف على الأقل";
//   }

//   // حرف كبير
//   if (!RegExp(r'[A-Z]').hasMatch(value)) {
//     return "يجب أن تحتوي كلمة المرور على حرف كبير واحد على الأقل";
//   }

//   // حرف صغير
//   if (!RegExp(r'[a-z]').hasMatch(value)) {
//     return "يجب أن تحتوي كلمة المرور على حرف صغير واحد على الأقل";
//   }

//   // رقم
//   if (!RegExp(r'[0-9]').hasMatch(value)) {
//     return "يجب أن تحتوي كلمة المرور على رقم واحد على الأقل";
//   }

//   // رمز واحد
//   if (!RegExp(r'[@!#\$%\^&\*]').hasMatch(value)) {
//     return "يجب أن تحتوي كلمة المرور على رمز واحد على الأقل ( @ ! # \$ % ^ & * )";
//   }

//   return null;
// }

// String? validateEmail(String? value, BuildContext context) {
//   if (value == null || value.isEmpty) {
//     return 'please_enter_your_email'; // رسالة: الرجاء إدخال البريد الإلكتروني
//   }

//   // Regex للتحقق من صحة صيغة الإيميل
//   final emailRegex = RegExp(
//     r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
//   );

//   if (!emailRegex.hasMatch(value)) {
//     return'please_enter_valid_email'; // رسالة: صيغة البريد الإلكتروني غير صحيحة
//   }

//   return null; // الإيميل صحيح
// }

// String? validateFullName(String? value, BuildContext context) {
//   if (value == null || value.isEmpty) {
//     return 'full_name_error1';
//   }

//   if (!RegExp(r'^[a-zA-Zا-ي\s]+$').hasMatch(value)) {
//     return 'full_name_error2';
//   }

//   return null;
// }

// String? validateNotHaveValue(String? value, BuildContext context) {
//   if (value == null || value.isEmpty) {
//     return 'Empty_fill'; // Assuming this returns a localized error message
//   }
//   return null; // No error
// }

// String? contry(String? value, BuildContext context) {
//   if (value == null || value.isEmpty) {
//     return 'enter_countey'; // Assuming this returns a localized error message
//   }
//   return null; // No error
// }
import 'package:flutter/material.dart';
import 'package:hawwel/constans/digit_utils.dart';

// Future<bool> validatePhoneWithCountry({
//   required String phone,
//   required String countryCode, // SY, LB
// }) async {
//   final cleanedPhone = phone.replaceAll(' ', '');

//   // final bool? isValid = await PhoneNumberUtil.isValidPhoneNumber(
//   //   cleanedPhone,
//   //   countryCode,
//   // );

//   return  true ; // ✅ الحل هنا
// }
import 'package:phone_numbers_parser/phone_numbers_parser.dart';

String buildPhoneNumberWithCountryCode({
  required String phone,
  required String phoneCode,
}) {
  final normalizedPhoneCode = normalizeAuthDigits(phoneCode);
  final dialDigits = normalizedPhoneCode.replaceAll(RegExp(r'\D'), '');
  String cleanPhone = normalizePhoneLikeInput(phone).trim();
  cleanPhone = cleanPhone.replaceAll(RegExp(r'[\s\-\(\)]'), '');

  if (cleanPhone.startsWith('00')) {
    cleanPhone = '+${cleanPhone.substring(2)}';
  }

  if (cleanPhone.startsWith('+')) {
    final international = cleanPhone.substring(1).replaceAll(RegExp(r'\D'), '');
    if (international.startsWith(dialDigits)) {
      final national = international
          .substring(dialDigits.length)
          .replaceFirst(RegExp(r'^0+'), '');
      return '+$dialDigits$national';
    }
    return '+$international';
  }

  cleanPhone = cleanPhone.replaceAll(RegExp(r'\D'), '');

  if (cleanPhone.startsWith(dialDigits)) {
    final national = cleanPhone
        .substring(dialDigits.length)
        .replaceFirst(RegExp(r'^0+'), '');
    return '+$dialDigits$national';
  }

  cleanPhone = cleanPhone.replaceFirst(RegExp(r'^0+'), '');
  return '+$dialDigits$cleanPhone';
}

Future<bool> validatePhoneWithCountry({
  required String phone,
  required String countryCode,
}) async {
  try {
    final upper = countryCode.toUpperCase();
    IsoCode? matched;
    for (final e in IsoCode.values) {
      if (e.name.toUpperCase() == upper) {
        matched = e;
        break;
      }
    }
    if (matched == null) {
      return false;
    }

    String normalizedPhone = normalizePhoneLikeInput(phone).trim();
    normalizedPhone = normalizedPhone.replaceAll(RegExp(r'[\s\-\(\)]'), '');
    if (normalizedPhone.startsWith('00')) {
      normalizedPhone = '+${normalizedPhone.substring(2)}';
    }
    if (!normalizedPhone.startsWith('+')) {
      normalizedPhone = normalizedPhone
          .replaceAll(RegExp(r'\D'), '')
          .replaceFirst(RegExp(r'^0+'), '');
    }

    final phoneNumber = PhoneNumber.parse(
      normalizedPhone,
      destinationCountry: matched,
    );

    return phoneNumber.isValid(type: PhoneNumberType.mobile);
  } catch (e) {
    return false;
  }
}

String? validatePhoneNumber1111(value, BuildContext context) {
  if (value == null || value.isEmpty) {
    return 'mobile_number_required';
  }
  // if (!RegExp(r'^[0-9\u0660-\u0669]{10}$').hasMatch(value)) {
  //   return 'mobile_number_invalid';
  // }
  return null;
}

String? validatePhoneNumber(value, BuildContext context) {
  if (value == null || value.isEmpty) {
    return 'mobile_number_required';
  }
  // if (!RegExp(r'^[0-9\u0660-\u0669]{10}$').hasMatch(value)) {
  //   return 'mobile_number_invalid';
  // }
  return null;
}

String? valedatotp(value, BuildContext context) {
  if (value == null || value.isEmpty) {
    return 'otp_required';
  }

  return null;
}

String? validatePasswordl(String? value) {
  if (value == null || value.isEmpty) {
    return 'password_required';
  }

  if (value.length < 8) {
    return 'password_min_length';
  }

  if (!RegExp(r'[A-Z]').hasMatch(value)) {
    return 'password_uppercase';
  }

  if (!RegExp(r'[a-z]').hasMatch(value)) {
    return 'password_lowercase';
  }

  if (!RegExp(r'[0-9]').hasMatch(value)) {
    return 'password_number';
  }

  return null;
}

String? validatePassword(String? value, BuildContext context) {
  if (value == null || value.isEmpty) {
    return 'password_required';
  }

  if (value.length < 8) {
    return 'password_min_length';
  }

  if (!RegExp(r'[A-Z]').hasMatch(value)) {
    return 'password_uppercase';
  }

  if (!RegExp(r'[a-z]').hasMatch(value)) {
    return 'password_lowercase';
  }

  if (!RegExp(r'[0-9]').hasMatch(value)) {
    return 'password_number';
  }

  if (!RegExp(r'''[!@#$%^&*(),.?":{}|<>_\-+=\[\]/\\~`;]''').hasMatch(value)) {
    return 'password_symbol';
  }

  return null;
}

// For an EXISTING credential (e.g. the old password on a change-password
// screen) - only checks it was typed. The complexity rules in
// [validatePassword] are for a password being newly chosen, and older
// accounts can plausibly have passwords that predate those rules; the
// backend is what actually verifies the old password is correct.
String? validateNotEmptyPassword(String? value, BuildContext context) {
  if (value == null || value.isEmpty) {
    return 'password_required';
  }
  return null;
}

String? validateEmail(String? value, BuildContext context) {
  if (value == null || value.isEmpty) {
    return 'email_required';
  }

  final emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  if (!emailRegex.hasMatch(value)) {
    return 'email_invalid';
  }

  return null;
}

String? validateFullName(String? value, BuildContext context) {
  if (value == null || value.isEmpty) {
    return 'full_name_required';
  }

  // السماح بالحروف الإنجليزية + الحروف العربية (بما فيها أ، إ، آ، ة، ى...) + المسافات
  if (!RegExp(r'^[\u0600-\u06FFa-zA-Z\s]+$').hasMatch(value)) {
    return 'full_name_invalid';
  }

  return null;
}

String? validateNotHaveValue(String? value, BuildContext context) {
  if (value == null || value.isEmpty) {
    return 'field_required';
  }
  return null;
}

String? contry(String? value, BuildContext context) {
  if (value == null || value.isEmpty) {
    return 'country_required';
  }
  return null;
}
