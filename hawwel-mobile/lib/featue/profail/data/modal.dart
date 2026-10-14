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
  final String country;
  final String mobilePhone;
  final String email;
  final int accountNumber;
  final String createdAt;
  final String imagePath;
  final bool isVerified;
  final String status; // حالة الحساب (active/blocked)
  final KycInfo? kyc;

  StudentInfo({
    required this.id,
    required this.name,
    required this.nickname,
    required this.fatherName,
    required this.country,
    required this.mobilePhone,
    required this.email,
    required this.accountNumber,
    required this.createdAt,
    required this.imagePath,
    required this.isVerified,
    required this.status,
    this.kyc,
  });

  factory StudentInfo.fromJson(Map<String, dynamic> json) {
    return StudentInfo(
      // الـ API يرسل "_id" و "id"، نستخدم "_id" كمرجع أساسي
      id: json["_id"] ?? json["id"] ?? "",
      name: json["name"] ?? "",
      nickname: json["nickname"] ?? "",
      fatherName: json["fatherName"] ?? "",
      country: json["country"] ?? "",
      mobilePhone: json["mobilePhone"] ?? "",
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
    );
  }
}
class KycInfo {
  final String id;
  final String user;
  final String filePath;
  final String status; // (pending, verified, blocked)
  final String? createdAt;
  final String? verifiedAt;
  final String? blockedAt;
  final String? blockingReason; // مهم جداً لعرض سبب الرفض

  KycInfo({
    required this.id,
    required this.user,
    required this.filePath,
    required this.status,
    this.createdAt,
    this.verifiedAt,
    this.blockedAt,
    this.blockingReason,
  });

  factory KycInfo.fromJson(Map<String, dynamic> json) {
    return KycInfo(
      id: json["_id"] ?? "",
      user: json["user"] ?? "",
      filePath: json["filePath"] ?? "",
      status: json["status"] ?? "",
      createdAt: json["createdAt"],
      verifiedAt: json["verifiedAt"],
      blockedAt: json["blockedAt"],
      blockingReason: json["blockingReason"], // جلب "تجريب" من الـ JSON
    );
  }
}