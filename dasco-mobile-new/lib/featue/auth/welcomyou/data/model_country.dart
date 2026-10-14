class CountryModel {
  final String id;
  final String code; // SY, LB ...

  CountryModel({
    required this.id,
    required this.code,
  });

  factory CountryModel.fromJson(Map<String, dynamic> json) {
    return CountryModel(
      id: json['_id'],
      code: json['code'],
    );
  }
}
