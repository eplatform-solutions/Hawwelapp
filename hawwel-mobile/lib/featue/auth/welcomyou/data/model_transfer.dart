class TransferRequestModel {
  final String symbol;
  final num amount;
  final String toCountry;
  final String city;
  final String area;
  final String paymentMethod;
  final String fullName;
  final String mobilePhone;
  // final String kkk;

  TransferRequestModel({
    // required this.kkk,
    required this.symbol,
    required this.amount,
    required this.toCountry,
    required this.city,
    required this.area,
    required this.paymentMethod,
    required this.fullName,
    required this.mobilePhone,
  });

  Map<String, dynamic> toJson() {
    return {
      // "fromCountry": kkk,
      "symbol": symbol,
      "amount": amount,
      "toCountry": toCountry,
      "city": city,
      "area": area,
      "paymentMethod": paymentMethod,
      "receiver": {"fullName": fullName, "mobilePhone": mobilePhone},
    };
  }
}
