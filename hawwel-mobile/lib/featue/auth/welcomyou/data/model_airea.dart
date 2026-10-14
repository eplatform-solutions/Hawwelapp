// class AreaModel {
//   final String id;
//   final String name;

//   AreaModel({
//     required this.id,
//     required this.name,
//   });

//   factory AreaModel.fromJson(Map<String, dynamic> json) {
//     return AreaModel(
//       id: json['_id'],
//       name: json['name'],
//     );
//   }
// }
class AreaModel {
  final String id;
  final String nameAr;
  final String nameEn;

  AreaModel({
    required this.id,
    required this.nameAr,
    required this.nameEn,
  });

  factory AreaModel.fromJson(Map<String, dynamic> json) {
    return AreaModel(
      id: json['_id'] as String,
      // سحب القيمتين من الخريطة (Map)
      nameAr: json['name']['ar'] ?? '',
      nameEn: json['name']['en'] ?? '',
    );
  }
}