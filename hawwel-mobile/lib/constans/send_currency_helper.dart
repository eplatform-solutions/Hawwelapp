import 'package:flutter/material.dart';
import 'package:hawwel/constans/appr_images.dart';
import 'package:hawwel/featue/auth/welcomyou/data/cubit_amount_to_send.dart';

/// Maps send currencies for API payloads and UI labels (USDT / USDC).
class SendCurrencyHelper {
  static const Set<String> _sendApiSymbols = {'USDT', 'USDC'};

  /// USDC is the default because USDT has no MiCA authorisation: since
  /// 1 July 2026 no licensed venue in the EEA may offer it, so no licensed
  /// partner can settle a USDT transfer for us.
  static const CurrencyType defaultCurrency = CurrencyType.usdc;

  /// Which currencies the server still accepts for new transfers, in the order
  /// it gave them. Refreshed from /app-visual-identity/public at launch, so a
  /// stablecoin can be withdrawn without an app release. The fallback is the
  /// default alone rather than everything - if the config call fails, offering
  /// a coin that may have been withdrawn is the worse error.
  static List<CurrencyType> _allowedCurrencies = const [defaultCurrency];

  static List<CurrencyType> get allowedCurrencies => _allowedCurrencies;

  static bool get hasCurrencyChoice => _allowedCurrencies.length > 1;

  /// Bumped whenever the server's list changes, so a screen already holding a
  /// selection can pull it back onto something still allowed.
  static final ValueNotifier<int> allowedCurrenciesRevision =
      ValueNotifier<int>(0);

  static void updateAllowedFromSymbols(List<String> symbols) {
    final parsed = <CurrencyType>[];
    for (final symbol in symbols) {
      final type = typeForSymbol(symbol);
      if (type != null && !parsed.contains(type)) {
        parsed.add(type);
      }
    }
    // An empty or unrecognised list must not leave the app with no currency at
    // all, which would make the send screen unusable.
    final resolved = parsed.isEmpty ? const [defaultCurrency] : parsed;
    final changed = resolved.length != _allowedCurrencies.length ||
        !resolved.every(_allowedCurrencies.contains);
    _allowedCurrencies = resolved;
    if (changed) {
      allowedCurrenciesRevision.value++;
    }
  }

  static CurrencyType? typeForSymbol(String symbol) {
    switch (symbol.trim().toUpperCase()) {
      case 'USDC':
        return CurrencyType.usdc;
      case 'USDT':
        return CurrencyType.usdt;
      default:
        return null;
    }
  }

  static String apiSymbolFor(CurrencyType type) {
    return type == CurrencyType.usdt ? 'USDT' : 'USDC';
  }

  static String displayLabelForType(
    CurrencyType type, {
    required bool isArabic,
  }) {
    return displayLabelForSymbol(apiSymbolFor(type), isArabic: isArabic);
  }

  static String displayLabelForSymbol(
    String symbol, {
    required bool isArabic,
  }) {
    final normalized = symbol.trim().toUpperCase();
    return normalized.isEmpty ? symbol : normalized;
  }

  static bool isSendApiSymbol(String symbol) {
    return _sendApiSymbols.contains(symbol.trim().toUpperCase());
  }

  /// Legacy asset naming is inverted on several payment/history screens.
  static String legacyCoinImageAsset(String symbol) {
    final normalized = symbol.trim().toUpperCase();
    return normalized == 'USDC' ? AppImages.usdt : AppImages.usdc;
  }

  static Widget buildCoinIcon({
    required String symbol,
    required double height,
    required double width,
    Color? iconColor,
    BoxFit fit = BoxFit.cover,
  }) {
    return Image.asset(
      legacyCoinImageAsset(symbol),
      height: height,
      width: width,
      fit: fit,
    );
  }

  static ImageProvider? qrEmbeddedCoinImage(String symbol) {
    return AssetImage(legacyCoinImageAsset(symbol));
  }
}
