// class PaymentMethodModel {
//   final String id;
//   final String name;
//   final String logoPath;

//   PaymentMethodModel({
//     required this.id,
//     required this.name,
//     required this.logoPath,
//   });

//   factory PaymentMethodModel.fromJson(Map<String, dynamic> json) {
//     return PaymentMethodModel(
//       id: json['_id'],
//       name: json['name'],
//       logoPath: json['logoPath'],
//     );
//   }
// }
class PaymentMethodModel {
  final String id;
  final String nameAr; // أضف هذا
  final String nameEn; // أضف هذا
  final String logoPath;
  final String cardLogoPath;
  final String normalizedLogoPath;
  final String originalLogoUrl;
  final String normalizedLogoUrl;

  PaymentMethodModel({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    required this.logoPath,
    required this.cardLogoPath,
    required this.normalizedLogoPath,
    required this.originalLogoUrl,
    required this.normalizedLogoUrl,
  });

  factory PaymentMethodModel.fromJson(Map<String, dynamic> json) {
    return PaymentMethodModel(
      id: json['_id'] as String,
      // هون كان الخطأ السطر 105: سحبنا القيمتين من داخل خريطة name
      nameAr: json['name']['ar'] ?? '',
      nameEn: json['name']['en'] ?? '',
      logoPath: json['logoPath'] ?? '',
      cardLogoPath: json['cardLogoPath'] ?? '',
      normalizedLogoPath:
          json['normalizedLogoPath'] ?? json['cardLogoPath'] ?? '',
      originalLogoUrl: json['original_logo_url'] ?? json['logoPath'] ?? '',
      normalizedLogoUrl:
          json['normalized_logo_url'] ??
          json['normalizedLogoPath'] ??
          json['cardLogoPath'] ??
          '',
    );
  }
}
