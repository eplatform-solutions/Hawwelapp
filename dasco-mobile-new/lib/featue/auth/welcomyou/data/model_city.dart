// class CityModel {
//   final String id;
//   final String name;

//   CityModel({
//     required this.id,
//     required this.name,
//   });

//   factory CityModel.fromJson(Map<String, dynamic> json) {
//     return CityModel(
//       id: json['_id'],
//       name: json['name'],
//     );
//   }
// }
// class CityModel {
//   final String id;
//   final String nameAr;
//   final String nameEn;

//   CityModel({
//     required this.id,
//     required this.nameAr,
//     required this.nameEn,
//   });

//   factory CityModel.fromJson(Map<String, dynamic> json) {
//     return CityModel(
//       // الوصول للبيانات من داخل الخريطة (Map) كما تأتي من السيرفر
//       id: json['_id'] as String,
//       nameAr: json['name']['ar'] ?? '', 
//       nameEn: json['name']['en'] ?? '',
//     );
//   }

//   // دالة مساعدة للحصول على الاسم حسب اللغة الممررة لها
//   String getName(String lang) {
//     return lang == 'ar' ? nameAr : nameEn;
//   }
// }
class CityModel {
  final String id;
  final String nameAr; // حفظ العربي
  final String nameEn; // حفظ الإنجليزي

  CityModel({
    required this.id, 
    required this.nameAr, 
    required this.nameEn
  });

  factory CityModel.fromJson(Map<String, dynamic> json) {
    return CityModel(
      id: json['_id'] as String,
      // نسحب القيمتين مباشرة من الـ Map القادم من السيرفر
      nameAr: json['name']['ar'] ?? '',
      nameEn: json['name']['en'] ?? '',
    );
  }
}