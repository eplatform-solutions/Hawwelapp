import 'dart:developer';
import 'dart:math' as math;

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hawwel/constans/api_servise.dart';
import 'package:hawwel/constans/send_currency_helper.dart';

class AppBrandingConfig {
  final String themeMode;
  final String solidBackgroundColor;
  final String gradientStartColor;
  final String gradientEndColor;
  final String textColor;
  final String logoPath;
  final String backgroundImagePath;
  final Map<String, dynamic> uiTokens;

  const AppBrandingConfig({
    required this.themeMode,
    required this.solidBackgroundColor,
    required this.gradientStartColor,
    required this.gradientEndColor,
    required this.textColor,
    required this.logoPath,
    required this.backgroundImagePath,
    required this.uiTokens,
  });

  factory AppBrandingConfig.defaults() {
    return const AppBrandingConfig(
      themeMode: 'gradient',
      solidBackgroundColor: '#FFFFFF',
      gradientStartColor: '#00443A',
      gradientEndColor: '#00AA91',
      textColor: '#000000',
      logoPath: '',
      backgroundImagePath: '',
      uiTokens: {
        'screenBackgroundColor': '#F3F4F6',
        'cardBackgroundColor': '#FFFFFF',
        'cardStyleMode': 'solid',
        'cardGradientStartColor': '#FFFFFF',
        'cardGradientEndColor': '#E5E7EB',
        'cardBorderColor': '#D1D5DB',
        'primaryTextColor': '#111827',
        'secondaryTextColor': '#6B7280',
        'inputBackgroundColor': '#FFFFFF',
        'inputStyleMode': 'solid',
        'inputGradientStartColor': '#FFFFFF',
        'inputGradientEndColor': '#F3F4F6',
        'inputBorderColor': '#D1D5DB',
        'inputTextColor': '#111827',
        'buttonBackgroundColor': '#6B1F2A',
        'buttonStyleMode': 'solid',
        'buttonGradientStartColor': '#6B1F2A',
        'buttonGradientEndColor': '#9B3A49',
        'buttonTextColor': '#FFFFFF',
        'accentColor': '#B9A779',
        'linkColor': '#295F4D',
        'successColor': '#4A856A',
        'errorColor': '#E53935',
        'warningColor': '#FFCC00',
        'dividerColor': '#D9D9D9',
        'hintTextColor': '#7A7A7A',
        'iconPrimaryColor': '#6B1F2A',
        'iconSecondaryColor': '#B9A779',
        'navBarActiveIconColor': '#E6C07A',
        'dialogBackgroundColor': '#FFFFFF',
        'badgeColor': '#128372',
        'appBarColor': '#128271',
        'headerGradientAngle': 180,
        'buttonGradientAngle': 135,
        'cardGradientAngle': 180,
        'navBarGradientAngle': 0,
        'headerOpacity': 1.0,
        'buttonOpacity': 1.0,
        'cardOpacity': 1.0,
        'navBarOpacity': 1.0,
      },
    );
  }

  factory AppBrandingConfig.fromJson(Map<String, dynamic> json) {
    final defaults = AppBrandingConfig.defaults();
    return AppBrandingConfig(
      themeMode: (json['themeMode'] ?? defaults.themeMode).toString(),
      solidBackgroundColor:
          (json['solidBackgroundColor'] ?? defaults.solidBackgroundColor)
              .toString(),
      gradientStartColor:
          (json['gradientStartColor'] ?? defaults.gradientStartColor)
              .toString(),
      gradientEndColor:
          (json['gradientEndColor'] ?? defaults.gradientEndColor).toString(),
      textColor: (json['textColor'] ?? defaults.textColor).toString(),
      logoPath: (json['logoPath'] ?? defaults.logoPath).toString(),
      backgroundImagePath:
          (json['backgroundImagePath'] ?? defaults.backgroundImagePath)
              .toString(),
      uiTokens: {
        ...defaults.uiTokens,
        ...((json['uiTokens'] is Map)
            ? Map<String, dynamic>.from(json['uiTokens'])
            : <String, dynamic>{}),
      },
    );
  }

  Color parseColor(String hex, Color fallback) {
    final value = hex.trim();
    if (!RegExp(r'^#?[0-9a-fA-F]{6}$').hasMatch(value)) return fallback;
    final normalized = value.startsWith('#') ? value.substring(1) : value;
    return Color(int.parse('FF$normalized', radix: 16));
  }

  Color _token(String key, Color fallback) =>
      parseColor((uiTokens[key] ?? '').toString(), fallback);

  double _numToken(String key, double fallback) {
    final val = uiTokens[key];
    if (val is num) return val.toDouble();
    final parsed = double.tryParse(val?.toString() ?? '');
    return parsed ?? fallback;
  }

  Color get textColorValue => parseColor(textColor, Colors.black);

  Color get solidBackgroundColorValue =>
      parseColor(solidBackgroundColor, Colors.white);

  Color get gradientStartColorValue =>
      parseColor(gradientStartColor, const Color(0xFF00443A));

  Color get gradientEndColorValue =>
      parseColor(gradientEndColor, const Color(0xFF00AA91));

  Color get screenBg =>
      _token('screenBackgroundColor', const Color(0xFFF3F4F6));
  Color get cardBg =>
      _token('cardBackgroundColor', Colors.white);
  Color get cardBorder =>
      _token('cardBorderColor', const Color(0xFFD1D5DB));
  Color get cardGradientStart =>
      _token('cardGradientStartColor', Colors.white);
  Color get cardGradientEnd =>
      _token('cardGradientEndColor', const Color(0xFFE5E7EB));
  String get cardStyleMode =>
      (uiTokens['cardStyleMode'] ?? 'solid').toString();

  Color get primaryText =>
      _token('primaryTextColor', const Color(0xFF111827));
  Color get secondaryText =>
      _token('secondaryTextColor', const Color(0xFF6B7280));

  Color get inputBg =>
      _token('inputBackgroundColor', Colors.white);
  Color get inputBorder =>
      _token('inputBorderColor', const Color(0xFFD1D5DB));
  Color get inputText =>
      _token('inputTextColor', const Color(0xFF111827));
  Color get inputGradientStart =>
      _token('inputGradientStartColor', Colors.white);
  Color get inputGradientEnd =>
      _token('inputGradientEndColor', const Color(0xFFF3F4F6));
  String get inputStyleMode =>
      (uiTokens['inputStyleMode'] ?? 'solid').toString();

  Color get buttonBg =>
      _token('buttonBackgroundColor', const Color(0xFF6B1F2A));
  Color get buttonText =>
      _token('buttonTextColor', Colors.white);
  Color get buttonGradientStart =>
      _token('buttonGradientStartColor', const Color(0xFF6B1F2A));
  Color get buttonGradientEnd =>
      _token('buttonGradientEndColor', const Color(0xFF9B3A49));
  String get buttonStyleMode =>
      (uiTokens['buttonStyleMode'] ?? 'solid').toString();

  Color get accent =>
      _token('accentColor', const Color(0xFFB9A779));
  Color get link =>
      _token('linkColor', const Color(0xFF295F4D));
  Color get success =>
      _token('successColor', const Color(0xFF4A856A));
  Color get error =>
      _token('errorColor', const Color(0xFFE53935));
  Color get warning =>
      _token('warningColor', const Color(0xFFFFCC00));
  Color get divider =>
      _token('dividerColor', const Color(0xFFD9D9D9));
  Color get hintText =>
      _token('hintTextColor', const Color(0xFF7A7A7A));
  Color get iconPrimary =>
      _token('iconPrimaryColor', const Color(0xFF6B1F2A));
  Color get iconSecondary =>
      _token('iconSecondaryColor', const Color(0xFFB9A779));
  Color get navBarActiveIcon =>
      _token('navBarActiveIconColor', const Color(0xFFE6C07A));
  Color get dialogBg =>
      _token('dialogBackgroundColor', Colors.white);
  Color get badge =>
      _token('badgeColor', const Color(0xFF128372));
  Color get appBar =>
      _token('appBarColor', const Color(0xFF128271));

  double get headerGradientAngle => _numToken('headerGradientAngle', 180);
  double get buttonGradientAngle => _numToken('buttonGradientAngle', 135);
  double get cardGradientAngle => _numToken('cardGradientAngle', 180);
  double get navBarGradientAngle => _numToken('navBarGradientAngle', 0);
  double get headerOpacity => _numToken('headerOpacity', 1.0).clamp(0.0, 1.0);
  double get buttonOpacity => _numToken('buttonOpacity', 1.0).clamp(0.0, 1.0);
  double get cardOpacity => _numToken('cardOpacity', 1.0).clamp(0.0, 1.0);
  double get navBarOpacity => _numToken('navBarOpacity', 1.0).clamp(0.0, 1.0);

  static List<Alignment> gradientAlignments(double angleDeg) {
    final rad = angleDeg * math.pi / 180;
    return [
      Alignment(-math.cos(rad), -math.sin(rad)),
      Alignment(math.cos(rad), math.sin(rad)),
    ];
  }

  LinearGradient buildHeaderGradient() {
    final a = gradientAlignments(headerGradientAngle);
    return LinearGradient(begin: a[0], end: a[1], colors: [
      gradientStartColorValue.withValues(alpha: headerOpacity),
      gradientEndColorValue.withValues(alpha: headerOpacity),
    ]);
  }

  LinearGradient buildButtonGradient() {
    final a = gradientAlignments(buttonGradientAngle);
    return LinearGradient(begin: a[0], end: a[1], colors: [
      buttonGradientStart.withValues(alpha: buttonOpacity),
      buttonGradientEnd.withValues(alpha: buttonOpacity),
    ]);
  }

  LinearGradient buildCardGradient() {
    final a = gradientAlignments(cardGradientAngle);
    return LinearGradient(begin: a[0], end: a[1], colors: [
      cardGradientStart.withValues(alpha: cardOpacity),
      cardGradientEnd.withValues(alpha: cardOpacity),
    ]);
  }

  LinearGradient buildNavBarGradient() {
    final a = gradientAlignments(navBarGradientAngle);
    return LinearGradient(begin: a[0], end: a[1], colors: [
      gradientStartColorValue.withValues(alpha: navBarOpacity),
      gradientEndColorValue.withValues(alpha: navBarOpacity),
    ]);
  }

  Decoration buildButtonDecoration({double radius = 15}) {
    if (buttonStyleMode == 'gradient') {
      return BoxDecoration(
        gradient: buildButtonGradient(),
        borderRadius: BorderRadius.circular(radius),
      );
    }
    return BoxDecoration(
      color: buttonBg.withValues(alpha: buttonOpacity),
      borderRadius: BorderRadius.circular(radius),
    );
  }

  Decoration buildCardDecoration({double radius = 20, double borderWidth = 1}) {
    if (cardStyleMode == 'gradient') {
      return BoxDecoration(
        gradient: buildCardGradient(),
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: cardBorder, width: borderWidth),
      );
    }
    return BoxDecoration(
      color: cardBg.withValues(alpha: cardOpacity),
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(color: cardBorder, width: borderWidth),
    );
  }

  String _resolveUrl(String path) {
    if (path.isEmpty) return '';
    if (path.startsWith('http://') || path.startsWith('https://')) return path;
    return '${ApiService.baseURL}/${path.replaceFirst(RegExp(r'^/+'), '')}';
  }

  String get logoUrl => _resolveUrl(logoPath);

  String get backgroundImageUrl => _resolveUrl(backgroundImagePath);
}

final ValueNotifier<AppBrandingConfig> appBrandingNotifier = ValueNotifier(
  AppBrandingConfig.defaults(),
);

class AppBrandingService {
  static Future<void> load() async {
    try {
      final response = await Dio(
        BaseOptions(
          connectTimeout: const Duration(seconds: 8),
          receiveTimeout: const Duration(seconds: 8),
        ),
      ).get('${ApiService.baseURL}/app-visual-identity/public');
      final data = response.data;
      if (data is Map && data['error'] == false && data['data'] is Map) {
        final payload = Map<String, dynamic>.from(data['data']);
        appBrandingNotifier.value = AppBrandingConfig.fromJson(payload);
        // Same call carries which stablecoins may still fund a transfer, so a
        // coin can be withdrawn server-side without an app-store release.
        final allowed = payload['allowedSendCurrencies'];
        if (allowed is List) {
          SendCurrencyHelper.updateAllowedFromSymbols(
            allowed.map((value) => value.toString()).toList(),
          );
        }
      }
    } catch (e) {
      log('Branding load failed: $e');
    }
  }
}
