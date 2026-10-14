import 'package:flutter/services.dart';

/// يحوّل الأرقام العربية/الفارسية (١٢٣) إلى أرقام غربية (123) للحساب والتحقق.
String normalizeToWesternDigits(String input) {
  if (input.isEmpty) return input;

  final buffer = StringBuffer();
  for (final codeUnit in input.runes) {
    if (codeUnit >= 0x0660 && codeUnit <= 0x0669) {
      buffer.writeCharCode(0x30 + (codeUnit - 0x0660));
    } else if (codeUnit >= 0x06F0 && codeUnit <= 0x06F9) {
      buffer.writeCharCode(0x30 + (codeUnit - 0x06F0));
    } else if (codeUnit >= 0x0966 && codeUnit <= 0x096F) {
      // Hindi / Devanagari digits: ०१२३४५६७८९
      buffer.writeCharCode(0x30 + (codeUnit - 0x0966));
    } else if (codeUnit == 0x066B) {
      // الفاصلة العشرية العربية ٫
      buffer.write('.');
    } else if (codeUnit == 0x060C || codeUnit == 0x066C) {
      // فاصلة عربية أو فاصل آلاف — نتجاهلها في حقول المبلغ
      continue;
    } else {
      buffer.writeCharCode(codeUnit);
    }
  }
  return buffer.toString();
}

/// يطبع أرقام ASCII فقط من أي إدخال رقمي متعدد اللغات.
String normalizeAuthDigits(String input) => normalizeToWesternDigits(input);

/// يحافظ على "+" في البداية (للأرقام الدولية) ويحوّل باقي الأرقام إلى ASCII.
String normalizePhoneLikeInput(String input) {
  final normalized = normalizeAuthDigits(input);
  final buffer = StringBuffer();
  for (int i = 0; i < normalized.length; i++) {
    final ch = normalized[i];
    if (i == 0 && ch == '+') {
      buffer.write(ch);
      continue;
    }
    if (RegExp(r'[0-9]').hasMatch(ch)) {
      buffer.write(ch);
      continue;
    }
    if (RegExp(r'[\s\-\(\)]').hasMatch(ch)) {
      buffer.write(ch);
    }
  }
  return buffer.toString();
}

/// يُطبَّق على حقول الأرقام لتحويل الإدخال تلقائياً أثناء الكتابة.
class WesternDigitsTextInputFormatter extends TextInputFormatter {
  const WesternDigitsTextInputFormatter();

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final normalized = normalizeToWesternDigits(newValue.text);
    if (normalized == newValue.text) return newValue;

    final selectionIndex = newValue.selection.end.clamp(0, newValue.text.length);
    final normalizedOffset = normalizeToWesternDigits(
      newValue.text.substring(0, selectionIndex),
    ).length;

    return TextEditingValue(
      text: normalized,
      selection: TextSelection.collapsed(
        offset: normalizedOffset.clamp(0, normalized.length),
      ),
      composing: TextRange.empty,
    );
  }
}

/// يُحلّل مبلغاً قد يحتوي أرقاماً عربية أو فاصلة عشرية عربية.
double? tryParseWesternAmount(String? value) {
  if (value == null || value.trim().isEmpty) return null;
  final normalized = normalizeToWesternDigits(value).replaceAll(',', '');
  return double.tryParse(normalized);
}
