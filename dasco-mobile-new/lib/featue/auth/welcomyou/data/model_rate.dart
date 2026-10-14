class ExchangeRateModel {
  final String messageAr;
  final String messageEn;
  final Map<String, dynamic> rates; // USDT, USDC, etc.

  ExchangeRateModel({
    required this.messageAr,
    required this.messageEn,
    required this.rates,
  });

  factory ExchangeRateModel.fromJson(Map<String, dynamic> json) {
    return ExchangeRateModel(
      messageAr: json['msg']['ar'] ?? "",
      messageEn: json['msg']['en'] ?? "",
      rates: json['data'] ?? {},
    );
  }
}