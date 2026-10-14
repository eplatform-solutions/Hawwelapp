import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:hawwel/constans/appr_images.dart';
import 'package:hawwel/featue/auth/welcomyou/data/model_country.dart';
import 'package:world_flags/world_flags.dart' hide Country;

class CountryDefaultsHelper {
  /// ISO-3166 alpha-2, uppercased for [CountryLocalizations] lookups.
  static String normalizedCountryCode(String? countryCode) {
    return countryCode?.trim().toUpperCase() ?? '';
  }

  /// Localized country name from [country_picker] (Arabic when app locale is `ar`).
  static String localizedCountryName(
    BuildContext context,
    String countryCode, {
    String? fallback,
  }) {
    final code = normalizedCountryCode(countryCode);
    if (code.isEmpty) return fallback ?? '';
    final localized =
        CountryLocalizations.of(context)?.countryName(countryCode: code);
    if (localized != null && localized.isNotEmpty) return localized;
    return fallback ?? Country.tryParse(code)?.name ?? code;
  }

  /// Syria: wavy PNG asset (user-preferred). Others: [world_flags] vector (flat, up-to-date).
  /// For waved flags on all countries, upgrade Flutter/Dart and use world_flags 3.x [FlagShaderSurface].
  static Widget countryFlag(
    String countryCode, {
    double size = 22,
  }) {
    final code = normalizedCountryCode(countryCode);
    if (code.isEmpty) {
      return Text('🏳️', style: TextStyle(fontSize: size));
    }

    if (code == 'SY') {
      return Image.asset(
        AppImages.syria,
        width: size * 1.15,
        height: size * 0.82,
        fit: BoxFit.contain,
        filterQuality: FilterQuality.medium,
      );
    }

    final worldCountry = WorldCountry.maybeFromCodeShort(code);
    if (worldCountry != null) {
      // Same footprint as the Syrian asset so the two styles line up in
      // pickers; the wave treatment makes the vector flags read as cloth.
      return WavyFlag(
        width: size * 1.15,
        height: size * 0.82,
        child: CountryFlag.simplified(
          worldCountry,
          decoration: const BoxDecoration(),
        ),
      );
    }

    final emoji = Country.tryParse(code)?.flagEmoji ?? '🏳️';
    return Text(emoji, style: TextStyle(fontSize: size));
  }

  static const List<String> _neutralPhoneCountryCodes = ['JO', 'TR', 'LB', 'DE'];

  /// Uses the first destination country returned by the admin/API configuration.
  static CountryModel resolveDefaultCountry(List<CountryModel> countries) {
    if (countries.isEmpty) {
      throw StateError('countries must not be empty');
    }
    return countries.first;
  }

  /// Maps an API ISO code (e.g. from [CountriesCubit]) to a phone-picker country.
  static Country? phoneCountryForApiCode(String? apiCountryCode) {
    final code = apiCountryCode?.trim();
    if (code == null || code.isEmpty) return null;
    return _findPhoneCountry(code);
  }

  /// Neutral default for phone inputs when no API country is available yet.
  static Country defaultPhonePickerCountry({String? preferredApiCountryCode}) {
    final fromApi = phoneCountryForApiCode(preferredApiCountryCode);
    if (fromApi != null) return fromApi;

    for (final code in _neutralPhoneCountryCodes) {
      final match = _findPhoneCountry(code);
      if (match != null) return match;
    }

    return CountryService().getAll().first;
  }

  static Country? _findPhoneCountry(String code) {
    try {
      return CountryService().getAll().firstWhere(
        (country) =>
            country.countryCode.toUpperCase() == code.toUpperCase(),
      );
    } catch (_) {
      return null;
    }
  }

  static Widget phonePickerFlag(
    Country country, {
    double fontSize = 24,
  }) {
    return countryFlag(country.countryCode, size: fontSize);
  }
}

/// Gives a flat flag the look of a waving cloth: wavy top/bottom edges and
/// soft alternating light/shadow bands, like the Syrian PNG asset. Pure
/// clipping + gradients, no shaders, so it works on every device/renderer
/// (world_flags 3.x's shader-based waves need a newer Dart SDK).
class WavyFlag extends StatelessWidget {
  final Widget child;
  final double width;
  final double height;

  const WavyFlag({
    super.key,
    required this.child,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ClipPath(
        clipper: const _WaveClipper(),
        child: Stack(
          fit: StackFit.expand,
          children: [
            child,
            const IgnorePointer(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment(-1, -0.4),
                    end: Alignment(1, 0.4),
                    colors: [
                      Color(0x40FFFFFF),
                      Color(0x00FFFFFF),
                      Color(0x33000000),
                      Color(0x00000000),
                      Color(0x38FFFFFF),
                      Color(0x00FFFFFF),
                      Color(0x30000000),
                    ],
                    stops: [0, 0.16, 0.36, 0.52, 0.66, 0.84, 1],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WaveClipper extends CustomClipper<Path> {
  const _WaveClipper();

  @override
  Path getClip(Size size) {
    final w = size.width;
    final h = size.height;
    final amp = h * 0.09;
    final path = Path();
    // Top edge: one and a half waves; bottom edge follows the same phase so
    // the cloth keeps its thickness, like a real flag.
    path.moveTo(0, amp);
    path.cubicTo(w * 0.17, -amp * 0.6, w * 0.33, amp * 2.2, w * 0.5, amp);
    path.cubicTo(w * 0.67, -amp * 0.2, w * 0.83, amp * 2.0, w, amp * 0.6);
    path.lineTo(w, h - amp * 0.4);
    path.cubicTo(w * 0.83, h - amp * 2.0, w * 0.67, h + amp * 0.2, w * 0.5,
        h - amp);
    path.cubicTo(w * 0.33, h - amp * 2.2, w * 0.17, h + amp * 0.6, 0, h - amp);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
