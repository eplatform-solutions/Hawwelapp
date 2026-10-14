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

  PaymentMethodModel({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    required this.logoPath,
  });

  factory PaymentMethodModel.fromJson(Map<String, dynamic> json) {
    return PaymentMethodModel(
      id: json['_id'] as String,
      // هون كان الخطأ السطر 105: سحبنا القيمتين من داخل خريطة name
      nameAr: json['name']['ar'] ?? '', 
      nameEn: json['name']['en'] ?? '',
      logoPath: json['logoPath'] ?? '',
    );
  }
}