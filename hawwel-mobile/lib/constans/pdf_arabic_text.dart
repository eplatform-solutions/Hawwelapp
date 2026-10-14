import 'package:bidi/bidi.dart' as ubidi;

/// Arabic / Arabic-supplement blocks plus presentation forms used after shaping.
final RegExp _arabicScriptChars = RegExp(
  r'[\u0600-\u06FF\u0750-\u077F\u08A0-\u08FF\uFB50-\uFDFF\uFE70-\uFEFF]',
);

bool pdfTextContainsArabicScript(String s) =>
    s.isNotEmpty && _arabicScriptChars.hasMatch(s);

/// Converts logical Arabic to visually ordered, shaped code points for renderers
/// that do not apply OpenType shaping (e.g. package `pdf`).
String preparePdfArabicDisplayText(String logical) {
  if (!pdfTextContainsArabicScript(logical)) return logical;
  return String.fromCharCodes(ubidi.logicalToVisual(logical));
}
