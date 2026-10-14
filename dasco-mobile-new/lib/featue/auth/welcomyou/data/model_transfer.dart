/// طلب إنشاء تحويل.
///
/// عقد الحقول:
/// - [fromCountry]: معرّف بلد المرسل (Mongo ObjectId) من `/users/info`
/// - [toCountry]: معرّف بلد الوجهة المختار في الشاشة الرئيسية
/// - [mobilePhone]: رقم المستلم فقط
/// - [city]/[area]: اختياريان معاً — إما يُرسلان الاثنان أو لا يُرسل أي
///   منهما. عندما تكون وسيلة الدفع متاحة على مستوى الدولة كلها (مثال:
///   Vodafone Cash في مصر) لا حاجة لمدينة/منطقة، فيتحقق السيرفر من الربط
///   على مستوى الدولة بدلاً من المنطقة.
class TransferRequestModel {
  final String symbol;
  final num amount;
  final String fromCountry;
  final String toCountry;
  final String? city;
  final String? area;
  final String paymentMethod;
  final String fullName;
  final String mobilePhone;

  TransferRequestModel({
    required this.symbol,
    required this.amount,
    required this.fromCountry,
    required this.toCountry,
    this.city,
    this.area,
    required this.paymentMethod,
    required this.fullName,
    required this.mobilePhone,
  }) : assert(
         (city == null) == (area == null),
         'city and area must be sent together, or not at all',
       );

  Map<String, dynamic> toJson() {
    return {
      "fromCountry": fromCountry,
      "symbol": symbol,
      "amount": amount,
      "toCountry": toCountry,
      if (city != null) "city": city,
      if (area != null) "area": area,
      "paymentMethod": paymentMethod,
      "receiver": {"fullName": fullName, "mobilePhone": mobilePhone},
    };
  }
}
