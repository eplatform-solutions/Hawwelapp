// class BlockchainWalletModel {
//   final String network;
//   final String address;
//   final DateTime createdAt;

//   BlockchainWalletModel({
//     required this.network,
//     required this.address,
//     required this.createdAt,
//   });

//   factory BlockchainWalletModel.fromJson(Map<String, dynamic> json) {
//     return BlockchainWalletModel(
//       network: json['network'],
//       address: json['address'],
//       createdAt: DateTime.parse(json['createdAt']),
//     );
//   }
// }
// class PaymentMethodResponseModel {
//   final String id;
//   final String name;
//   final String symbol;
//   final String logoPath;

//   PaymentMethodResponseModel({
//     required this.id,
//     required this.name,
//     required this.symbol,
//     required this.logoPath,
//   });

//   factory PaymentMethodResponseModel.fromJson(Map<String, dynamic> json) {
//     return PaymentMethodResponseModel(
//       id: json['_id'],
//       name: json['name'],
//       symbol: json['symbol'],
//       logoPath: json['logoPath'],
//     );
//   }
// }
// class ReceiverModel {
//   final String fullName;
//   final String mobilePhone;

//   ReceiverModel({
//     required this.fullName,
//     required this.mobilePhone,
//   });

//   factory ReceiverModel.fromJson(Map<String, dynamic> json) {
//     return ReceiverModel(
//       fullName: json['fullName'],
//       mobilePhone: json['mobilePhone'],
//     );
//   }
// }
// class SenderModel {
//   final String id;
//   final String name;
//   final String nickname;
//   final String fatherName;
//   final String mobilePhone;
//   final String email;

//   SenderModel({
//     required this.id,
//     required this.name,
//     required this.nickname,
//     required this.fatherName,
//     required this.mobilePhone,
//     required this.email,
//   });

//   factory SenderModel.fromJson(Map<String, dynamic> json) {
//     return SenderModel(
//       id: json['_id'],
//       name: json['name'],
//       nickname: json['nickname'],
//       fatherName: json['fatherName'],
//       mobilePhone: json['mobilePhone'],
//       email: json['email'],
//     );
//   }
// }
// class TransferResponseModel {
//   final String id;
//   final ReceiverModel receiver;
//   final SenderModel sender;
//   final String fromCountry;
//   final String toCountry;
//   final String city;
//   final String area;
//   final num amount;
//   final num total;
//   final num fee;
//   final num rate;
//   final String currencyName;
//   final String symbol;
//   final String status;
//   final DateTime expirationAt;
//   final DateTime createdAt;
//   final int transferNumber;
//   final PaymentMethodResponseModel paymentMethod;
//   final List<BlockchainWalletModel> blockchainWallets;

//   TransferResponseModel({
//     required this.id,
//     required this.receiver,
//     required this.sender,
//     required this.fromCountry,
//     required this.toCountry,
//     required this.city,
//     required this.area,
//     required this.amount,
//     required this.total,
//     required this.fee,
//     required this.rate,
//     required this.currencyName,
//     required this.symbol,
//     required this.status,
//     required this.expirationAt,
//     required this.createdAt,
//     required this.transferNumber,
//     required this.paymentMethod,
//     required this.blockchainWallets,
//   });

//   factory TransferResponseModel.fromJson(Map<String, dynamic> json) {
//     return TransferResponseModel(
//       id: json['_id'],
//       receiver: ReceiverModel.fromJson(json['receiver']),
//       sender: SenderModel.fromJson(json['sender']),
//       fromCountry: json['fromCountry'],
//       toCountry: json['toCountry'],
//       city: json['city'],
//       area: json['area'],
//       amount: json['amount'],
//       total: json['total'],
//       fee: json['fee'],
//       rate: json['rate'],
//       currencyName: json['currencyName'],
//       symbol: json['symbol'],
//       status: json['status'],
//       expirationAt: DateTime.parse(json['expirationAt']),
//       createdAt: DateTime.parse(json['createdAt']),
//       transferNumber: json['transferNumber'],
//       paymentMethod:
//           PaymentMethodResponseModel.fromJson(json['paymentMethod']),
//       blockchainWallets: (json['blockchainWallets'] as List)
//           .map((e) => BlockchainWalletModel.fromJson(e))
//           .toList(),
//     );
//   }
// }
class BlockchainWalletModel {
  final String network;
  final String address;
  final DateTime? createdAt; // جعل التاريخ قابل للعدم

  BlockchainWalletModel({
    required this.network,
    required this.address,
    this.createdAt,
  });

  factory BlockchainWalletModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) return BlockchainWalletModel(network: "", address: "");
    return BlockchainWalletModel(
      network: json['network']?.toString() ?? "",
      address: json['address']?.toString() ?? "",
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
    );
  }
}

class PaymentMethodResponseModel {
  final String id;
  final String name;
  final String symbol;
  final String logoPath;

  PaymentMethodResponseModel({
    required this.id,
    required this.name,
    required this.symbol,
    required this.logoPath,
  });

  factory PaymentMethodResponseModel.fromJson(Map<String, dynamic>? json) {
    // هنا عالجنا مشكلة الـ Null التي تسببت في الخطأ عندك في السطر 35
    return PaymentMethodResponseModel(
      id: json?['_id']?.toString() ?? "",
      name: json?['name']?.toString() ?? "",
      symbol: json?['symbol']?.toString() ?? "",
      logoPath: json?['logoPath']?.toString() ?? "",
    );
  }
}

class ReceiverModel {
  final String fullName;
  final String mobilePhone;

  ReceiverModel({required this.fullName, required this.mobilePhone});

  factory ReceiverModel.fromJson(Map<String, dynamic>? json) {
    return ReceiverModel(
      fullName: json?['fullName']?.toString() ?? "",
      mobilePhone: json?['mobilePhone']?.toString() ?? "",
    );
  }
}

class SenderModel {
  final String id;
  final String name;
  final String nickname;
  final String fatherName;
  final String mobilePhone;
  final String email;

  SenderModel({
    required this.id,
    required this.name,
    required this.nickname,
    required this.fatherName,
    required this.mobilePhone,
    required this.email,
  });

  factory SenderModel.fromJson(Map<String, dynamic>? json) {
    return SenderModel(
      id: json?['_id']?.toString() ?? "",
      name: json?['name']?.toString() ?? "",
      nickname: json?['nickname']?.toString() ?? "",
      fatherName: json?['fatherName']?.toString() ?? "",
      mobilePhone: json?['mobilePhone']?.toString() ?? "",
      email: json?['email']?.toString() ?? "",
    );
  }
}

class TransferResponseModel {
  final String id;
  final ReceiverModel receiver;
  final SenderModel sender;
  final String fromCountry;
  final String toCountry;
  final String city;
  final String area;
  final num amount;
  final num total;
  final num fee;
  final num rate;
  final String currencyName;
  final String symbol;
  final String status;
  final DateTime? expirationAt;
  final DateTime? createdAt;
  final int transferNumber;
  final PaymentMethodResponseModel paymentMethod;
  final List<BlockchainWalletModel> blockchainWallets;

  TransferResponseModel({
    required this.id,
    required this.receiver,
    required this.sender,
    required this.fromCountry,
    required this.toCountry,
    required this.city,
    required this.area,
    required this.amount,
    required this.total,
    required this.fee,
    required this.rate,
    required this.currencyName,
    required this.symbol,
    required this.status,
    this.expirationAt,
    this.createdAt,
    required this.transferNumber,
    required this.paymentMethod,
    required this.blockchainWallets,
  });

  factory TransferResponseModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) throw Exception("Data is null");

    return TransferResponseModel(
      id: json['_id']?.toString() ?? "",
      receiver: ReceiverModel.fromJson(json['receiver']),
      sender: SenderModel.fromJson(json['sender']),
      fromCountry: json['fromCountry']?.toString() ?? "",
      toCountry: json['toCountry']?.toString() ?? "",
      city: json['city']?.toString() ?? "",
      area: json['area']?.toString() ?? "",
      amount: json['amount'] ?? 0,
      total: json['total'] ?? 0,
      fee: json['fee'] ?? 0,
      rate: json['rate'] ?? 0,
      currencyName: json['currencyName']?.toString() ?? "",
      symbol: json['symbol']?.toString() ?? "",
      status: json['status']?.toString() ?? "",
      expirationAt: json['expirationAt'] != null
          ? DateTime.tryParse(json['expirationAt'])
          : null,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
      transferNumber: json['transferNumber'] ?? 0,
      paymentMethod: PaymentMethodResponseModel.fromJson(json['paymentMethod']),
      blockchainWallets: json['blockchainWallets'] != null
          ? (json['blockchainWallets'] as List)
                .map((e) => BlockchainWalletModel.fromJson(e))
                .toList()
          : [],
    );
  }
}
