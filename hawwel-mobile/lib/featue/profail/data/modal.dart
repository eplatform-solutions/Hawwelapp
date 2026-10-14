// // class StudentInfo {
// //   final String id;
// //   final String name;
// //   final String nickname;
// //   final String fatherName;
// //   final String country;
// //   final String mobilePhone;
// //   final String email;
// //   final int accountNumber;
// //   final String createdAt;
// //   final String imagePath;
// //   final bool isVerified;

// //   StudentInfo({
// //     required this.id,
// //     required this.name,
// //     required this.nickname,
// //     required this.fatherName,
// //     required this.country,
// //     required this.mobilePhone,
// //     required this.email,
// //     required this.accountNumber,
// //     required this.createdAt,
// //     required this.imagePath,
// //     required this.isVerified,
// //   });

// //   factory StudentInfo.fromJson(Map<String, dynamic> json) {
// //     return StudentInfo(
// //       id: json["_id"] ?? "",
// //       name: json["name"] ?? "",
// //       nickname: json["nickname"] ?? "",
// //       fatherName: json["fatherName"] ?? "",
// //       country: json["country"] ?? "",
// //       mobilePhone: json["mobilePhone"] ?? "",
// //       email: json["email"] ?? "",
// //       accountNumber: json["accountNumber"] ?? 0,
// //       createdAt: json["createdAt"] ?? "",
// //       imagePath: json["imagePath"] ?? "",
// //       isVerified: json["isVerified"].toString() == "true",
// //     );
// //   }
// // }
// class StudentInfo {
//   final String id;
//   final String name;
//   final String nickname;
//   final String fatherName;
//   final String country;
//   final String mobilePhone;
//   final String email;
//   final int accountNumber;
//   final String createdAt;
//   final String imagePath;
//   final bool isVerified;
//   final KycInfo? kyc; // ← هون أضفنا KYC

//   StudentInfo({
//     required this.id,
//     required this.name,
//     required this.nickname,
//     required this.fatherName,
//     required this.country,
//     required this.mobilePhone,
//     required this.email,
//     required this.accountNumber,
//     required this.createdAt,
//     required this.imagePath,
//     required this.isVerified,
//     required this.kyc,
//   });

//   factory StudentInfo.fromJson(Map<String, dynamic> json) {
//     return StudentInfo(
//       id: json["_id"] ?? "",
//       name: json["name"] ?? "",
//       nickname: json["nickname"] ?? "",
//       fatherName: json["fatherName"] ?? "",
//       country: json["country"] ?? "",
//       mobilePhone: json["mobilePhone"] ?? "",
//       email: json["email"] ?? "",
//       accountNumber: json["accountNumber"] ?? 0,
//       createdAt: json["createdAt"] ?? "",
//       imagePath: json["imagePath"] ?? "",
//       isVerified: json["isVerified"] == true,
//       kyc: json["kyc"] != null ? KycInfo.fromJson(json["kyc"]) : null,
//     );
//   }
// }

// class KycInfo {
//   final String id;
//   final String user;
//   final String filePath;
//   final String status;
//   final String? createdAt;

//   KycInfo({
//     required this.id,
//     required this.user,
//     required this.filePath,
//     required this.status,
//     this.createdAt,
//   });

//   factory KycInfo.fromJson(Map<String, dynamic> json) {
//     return KycInfo(
//       id: json["_id"] ?? "",
//       user: json["user"] ?? "",
//       filePath: json["filePath"] ?? "",
//       status: json["status"] ?? "",
//       createdAt: json["createdAt"],
//     );
//   }
// }
class StudentInfo {
  final String id;
  final String name;
  final String nickname;
  final String fatherName;
  /// ISO code (مثل SY/CH) أو نص آخر من الملف الشخصي.
  final String country;
  /// معرّف بلد المرسل (Mongo ObjectId) — المصدر الموثوق لـ `fromCountry`.
  final String? countryId;
  final String mobilePhone;
  final String mobilePhoneCode;
  final String email;
  final int accountNumber;
  final String createdAt;
  final String imagePath;
  final bool isVerified;
  final String status; // حالة الحساب (active/blocked)
  final KycInfo? kyc;
  final String kycStatus;
  final bool kycRequiredForTransfers;
  final Map<String, String>? kycRequiredMessage;
  final bool twoFAEnabled;
  final List<String> twoFAMethods;

  StudentInfo({
    required this.id,
    required this.name,
    required this.nickname,
    required this.fatherName,
    required this.country,
    this.countryId,
    required this.mobilePhone,
    this.mobilePhoneCode = '',
    required this.email,
    required this.accountNumber,
    required this.createdAt,
    required this.imagePath,
    required this.isVerified,
    required this.status,
    this.kyc,
    this.kycStatus = '',
    this.kycRequiredForTransfers = true,
    this.kycRequiredMessage,
    this.twoFAEnabled = false,
    this.twoFAMethods = const [],
  });

  factory StudentInfo.fromJson(Map<String, dynamic> json) {
    final parsedCountry = _parseCountryField(json["country"]);
    final explicitCountryId = json["countryId"]?.toString().trim();
    final resolvedCountryId = parsedCountry.id ??
        ((explicitCountryId != null && explicitCountryId.isNotEmpty)
            ? explicitCountryId
            : null);
    return StudentInfo(
      // الـ API يرسل "_id" و "id"، نستخدم "_id" كمرجع أساسي
      id: json["_id"] ?? json["id"] ?? "",
      name: json["name"] ?? "",
      nickname: json["nickname"] ?? "",
      fatherName: json["fatherName"] ?? "",
      country: parsedCountry.code,
      countryId: resolvedCountryId,
      mobilePhone: json["mobilePhone"]?.toString() ?? "",
      mobilePhoneCode: json["mobilePhoneCode"]?.toString() ?? "",
      email: json["email"] ?? "",
      accountNumber: (json["accountNumber"] is int) 
          ? json["accountNumber"] 
          : int.tryParse(json["accountNumber"].toString()) ?? 0,
      createdAt: json["createdAt"] ?? "",
      imagePath: json["imagePath"] ?? "",
      // نضمن أنها bool حتى لو جاءت من السيرفر بشكل مختلف
      isVerified: json["isVerified"] == true,
      status: json["status"] ?? "active",
      kyc: json["kyc"] != null ? KycInfo.fromJson(json["kyc"]) : null,
      kycStatus: json["kycStatus"]?.toString() ?? "",
      kycRequiredForTransfers: json["kycRequiredForTransfers"] == true,
      kycRequiredMessage: json["kycRequiredMessage"] is Map
          ? Map<String, String>.from(
              (json["kycRequiredMessage"] as Map).map(
                (key, value) => MapEntry(key.toString(), value?.toString() ?? ''),
              ),
            )
          : null,
      twoFAEnabled: json["twoFA"] is Map && json["twoFA"]["enabled"] == true,
      twoFAMethods: json["twoFA"] is Map && json["twoFA"]["methods"] is List
          ? (json["twoFA"]["methods"] as List)
              .map((m) => m.toString())
              .toList()
          : const [],
    );
  }
}

class _ParsedCountryField {
  const _ParsedCountryField({required this.code, this.id});
  final String code;
  final String? id;
}

_ParsedCountryField _parseCountryField(dynamic raw) {
  if (raw == null) {
    return const _ParsedCountryField(code: '');
  }
  if (raw is Map) {
    final id = raw['_id']?.toString() ?? raw['id']?.toString();
    final code = raw['code']?.toString().trim() ?? '';
    return _ParsedCountryField(code: code, id: id);
  }
  final value = raw.toString().trim();
  if (value.isEmpty) {
    return const _ParsedCountryField(code: '');
  }
  if (_looksLikeMongoId(value)) {
    return _ParsedCountryField(code: '', id: value);
  }
  return _ParsedCountryField(code: value);
}

bool _looksLikeMongoId(String value) {
  return RegExp(r'^[a-fA-F0-9]{24}$').hasMatch(value);
}

class KycInfo {
  final String id;
  final String user;
  final String filePath;
  final String status; // (pending, verified, blocked)
  final String? createdAt;
  final String? verifiedAt;
  final String? blockedAt;
  final String? blockingReason;
  final String? rejectionReason;
  final String? removeVerifyingReason;

  KycInfo({
    required this.id,
    required this.user,
    required this.filePath,
    required this.status,
    this.createdAt,
    this.verifiedAt,
    this.blockedAt,
    this.blockingReason,
    this.rejectionReason,
    this.removeVerifyingReason,
  });

  /// The admin's reason for the CURRENT status - each decision is stored
  /// in its own field on the backend, so reading only blockingReason left
  /// every rejected user with "no reason was provided".
  String? get decisionReason {
    switch (status) {
      case 'rejected':
        return rejectionReason;
      case 'blocked':
        return blockingReason;
      case 'remove-verified':
        return removeVerifyingReason;
      default:
        return null;
    }
  }

  factory KycInfo.fromJson(Map<String, dynamic> json) {
    return KycInfo(
      id: json["_id"] ?? "",
      user: json["user"] ?? "",
      filePath: json["filePath"] ?? "",
      status: json["status"] ?? "",
      createdAt: json["createdAt"],
      verifiedAt: json["verifiedAt"],
      blockedAt: json["blockedAt"],
      blockingReason: json["blockingReason"]?.toString(),
      rejectionReason: json["rejectionReason"]?.toString(),
      removeVerifyingReason: json["removeVerifyingReason"]?.toString(),
    );
  }
}