// class Change2FAResponse {
//   final bool error;
//   final String messageAr;
//   final String messageEn;

//   Change2FAResponse({
//     required this.error,
//     required this.messageAr,
//     required this.messageEn,
//   });

//   factory Change2FAResponse.fromJson(Map<String, dynamic> json) {
//     return Change2FAResponse(
//       error: json["error"] ?? true,
//       messageAr: json["msg"]?["ar"] ?? "",
//       messageEn: json["msg"]?["en"] ?? "",
//     );
//   }
// }
class Change2FAResponse {
  final bool error;
  final String message;

  Change2FAResponse({
    required this.error,
    required this.message,
  });

  factory Change2FAResponse.fromJson(
    Map<String, dynamic> json,
    String lang,
  ) {
    final msgMap = json["msg"] as Map<String, dynamic>?;

    return Change2FAResponse(
      error: json["error"] ?? false,
      message: msgMap?[lang] ??
          msgMap?["en"] ??
          msgMap?["ar"] ??
          "",
    );
  }
}
