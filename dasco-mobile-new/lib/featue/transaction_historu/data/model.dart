// class TransferModel {
//   final String id;
//   final double amount;
//   final double total;
//   final int rate;
//   final int fee;
//   final String currencyName;
//   final String symbol;
//   final String city;
//   final String area;
//   final String status;
//   final int transferNumber;
//   final DateTime createdAt;
//   final DateTime expirationAt;
//   final ReceiverModel receiver;
//   final PaymentMethodModel paymentMethod;

//   TransferModel({
//     required this.id,
//     required this.amount,
//     required this.total,
//     required this.rate,
//     required this.fee,
//     required this.currencyName,
//     required this.symbol,
//     required this.city,
//     required this.area,
//     required this.status,
//     required this.transferNumber,
//     required this.createdAt,
//     required this.expirationAt,
//     required this.receiver,
//     required this.paymentMethod,
//   });
class TransferModel {
  final String id;
  final double amount;
  final double paid;
  final double total;
  final int rate;
  final int fee;
  final String currencyName;
  final String symbol;

  // تعديل: تخزين اللغتين للمدينة والمنطقة
  final String cityAr;
  final String cityEn;
  final String areaAr;
  final String areaEn;

  final String status;
  final int transferNumber;
  final DateTime createdAt;
  final DateTime expirationAt;
  final ReceiverModel receiver;
  final PaymentMethodModel paymentMethod;
  final String paymentProofNote;
  final String paymentProofImagePath;
  final String receivingPlaceImagePath;
  final List<BlockchainWalletLiteModel> blockchainWallets;

  TransferModel({
    required this.id,
    required this.amount,
    this.paid = 0.0,
    required this.total,
    required this.rate,
    required this.fee,
    required this.currencyName,
    required this.symbol,
    required this.cityAr,
    required this.cityEn,
    required this.areaAr,
    required this.areaEn,
    required this.status,
    required this.transferNumber,
    required this.createdAt,
    required this.expirationAt,
    required this.receiver,
    required this.paymentMethod,
    this.paymentProofNote = '',
    this.paymentProofImagePath = '',
    this.receivingPlaceImagePath = '',
    this.blockchainWallets = const [],
  });

  factory TransferModel.fromJson(Map<String, dynamic> json) {
    return TransferModel(
      id: json['_id'] ?? '',
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      paid: (json['paid'] as num?)?.toDouble() ?? 0.0,
      total: (json['total'] as num?)?.toDouble() ?? 0.0,
      rate: (json['rate'] as num?)?.toInt() ?? 0,
      fee: (json['fee'] as num?)?.toInt() ?? 0,
      currencyName: json['currencyName'] ?? '',
      symbol: json['symbol'] ?? '',

      // حل مشكلة المدينة: سحب العربي والإنجليزي من الخريطة
      cityAr: json['city']?['ar'] ?? '',
      cityEn: json['city']?['en'] ?? '',

      // حل مشكلة المنطقة: سحب العربي والإنجليزي من الخريطة
      areaAr: json['area']?['ar'] ?? '',
      areaEn: json['area']?['en'] ?? '',

      status: json['status'] ?? '',
      transferNumber: (json['transferNumber'] as num?)?.toInt() ?? 0,
      createdAt: DateTime.parse(
        json['createdAt'] ?? DateTime.now().toIso8601String(),
      ),
      expirationAt: DateTime.parse(
        json['expirationAt'] ?? DateTime.now().toIso8601String(),
      ),

      receiver: ReceiverModel.fromJson(json['receiver'] ?? {}),

      // تأكد أن PaymentMethodModel.fromJson تم تعديله أيضاً ليدعم nameAr و nameEn
      paymentMethod: PaymentMethodModel.fromJson(json['paymentMethod'] ?? {}),
      paymentProofNote: json['paymentProofNote']?.toString() ?? '',
      paymentProofImagePath: json['paymentProofImagePath']?.toString() ?? '',
      receivingPlaceImagePath:
          json['receivingPlaceImagePath']?.toString() ?? '',
      blockchainWallets: json['blockchainWallets'] != null
          ? (json['blockchainWallets'] as List)
                .map((e) => BlockchainWalletLiteModel.fromJson(e))
                .toList()
          : [],
    );
  }
}
//   factory TransferModel.fromJson(Map<String, dynamic> json) {
//     return TransferModel(
//       id: json['_id'],
//       amount: (json['amount'] as num).toDouble(),
//       total: (json['total'] as num).toDouble(),
//       rate: json['rate'],
//       fee: json['fee'],
//       currencyName: json['currencyName'],
//       symbol: json['symbol'],
//       city: json['city'],
//       area: json['area'],
//       status: json['status'],
//       transferNumber: json['transferNumber'],
//       createdAt: DateTime.parse(json['createdAt']),
//       expirationAt: DateTime.parse(json['expirationAt']),
//       receiver: ReceiverModel.fromJson(json['receiver']),
//       paymentMethod: PaymentMethodModel.fromJson(json['paymentMethod']),
//     );
//   }
// }

// class PaymentMethodModel {
//   final String id;
//   final String name;
//   final String symbol;
//   final String logoPath;

//   PaymentMethodModel({
//     required this.id,
//     required this.name,
//     required this.symbol,
//     required this.logoPath,
//   });

//   factory PaymentMethodModel.fromJson(Map<String, dynamic> json) {
//     return PaymentMethodModel(
//       id: json['_id'],
//       name: json['name'],
//       symbol: json['symbol'],
//       logoPath: json['logoPath'],
//     );
//   }
// }
// class PaymentMethodModel {
//   final String id;
//   final String name;
//   final String symbol;
//   final double minAmount;
//   final double maxAmount;
//   final double fee;
//   final bool isActivated;
//   final String logoPath;
//   final int version;

//   PaymentMethodModel({
//     required this.id,
//     required this.name,
//     required this.symbol,
//     required this.minAmount,
//     required this.maxAmount,
//     required this.fee,
//     required this.isActivated,
//     required this.logoPath,
//     required this.version,
//   });

//   factory PaymentMethodModel.fromJson(Map<String, dynamic> json) {
//     return PaymentMethodModel(
//       id: json['_id'] ?? '',
//       name: json['name'] ?? '',
//       symbol: json['symbol'] ?? '',
//       minAmount: (json['minAmount'] ?? 0).toDouble(),
//       maxAmount: (json['maxAmount'] ?? 0).toDouble(),
//       fee: (json['fee'] ?? 0).toDouble(),
//       isActivated: json['isActivated'] ?? false,
//       logoPath: json['logoPath'] ?? '',
//       version: json['__v'] ?? 0,
//     );
//   }
// }
class PaymentMethodModel {
  final String id;
  final String nameAr; // حفظ العربي
  final String nameEn; // حفظ الإنكليزي
  final String symbol;
  final double minAmount;
  final double maxAmount;
  final double fee;
  final bool isActivated;
  final String logoPath;
  final String cardLogoPath;
  final String normalizedLogoPath;
  final String originalLogoUrl;
  final String normalizedLogoUrl;
  final int version;

  PaymentMethodModel({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    required this.symbol,
    required this.minAmount,
    required this.maxAmount,
    required this.fee,
    required this.isActivated,
    required this.logoPath,
    required this.cardLogoPath,
    required this.normalizedLogoPath,
    required this.originalLogoUrl,
    required this.normalizedLogoUrl,
    required this.version,
  });

  factory PaymentMethodModel.fromJson(Map<String, dynamic> json) {
    return PaymentMethodModel(
      id: json['_id'] ?? '',
      // الحل السحري: سحبنا اللغتين من خريطة الـ name
      nameAr: json['name']?['ar'] ?? '',
      nameEn: json['name']?['en'] ?? '',
      symbol: json['symbol'] ?? '',
      minAmount: (json['minAmount'] ?? 0).toDouble(),
      maxAmount: (json['maxAmount'] ?? 0).toDouble(),
      fee: (json['fee'] ?? 0).toDouble(),
      isActivated: json['isActivated'] ?? false,
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
      version: (json['__v'] as num?)?.toInt() ?? 0,
    );
  }
}

class ReceiverModel {
  final String fullName;
  final String mobilePhone;

  ReceiverModel({required this.fullName, required this.mobilePhone});

  factory ReceiverModel.fromJson(Map<String, dynamic> json) {
    return ReceiverModel(
      fullName: json['fullName'],
      mobilePhone: json['mobilePhone'],
    );
  }
}

class BlockchainWalletLiteModel {
  final String network;
  final String address;
  final DateTime? createdAt;

  BlockchainWalletLiteModel({
    required this.network,
    required this.address,
    this.createdAt,
  });

  factory BlockchainWalletLiteModel.fromJson(Map<String, dynamic> json) {
    return BlockchainWalletLiteModel(
      network: json['network']?.toString() ?? '',
      address: json['address']?.toString() ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())
          : null,
    );
  }
}

class TransfersByDateModel {
  final String date;
  final List<TransferModel> transfers;

  TransfersByDateModel({required this.date, required this.transfers});

  factory TransfersByDateModel.fromJson(Map<String, dynamic> json) {
    return TransfersByDateModel(
      date: json['date'],
      transfers: (json['transfers'] as List)
          .map((e) => TransferModel.fromJson(e))
          .toList(),
    );
  }
}
