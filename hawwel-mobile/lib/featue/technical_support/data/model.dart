import 'dart:convert';

class TechnicalSupportModel {
  final MessageModel? msg;
  final bool? error;
  final SupportData? data;

  TechnicalSupportModel({this.msg, this.error, this.data});

  factory TechnicalSupportModel.fromJson(Map<String, dynamic>? json) {
    return TechnicalSupportModel(
      msg: json?['msg'] != null ? MessageModel.fromJson(json?['msg']) : null,
      error: json?['error'] ?? true,
      data: json?['data'] != null ? SupportData.fromJson(json?['data']) : null,
    );
  }
}

class MessageModel {
  final String en;
  final String ar;

  MessageModel({required this.en, required this.ar});

  factory MessageModel.fromJson(Map<String, dynamic>? json) {
    return MessageModel(
      en: json?['en']?.toString() ?? "",
      ar: json?['ar']?.toString() ?? "",
    );
  }
}

class SupportData {
  final List<FaqModel> faqs;
  final int faqsCount;
  final ContactInfoModel? contactInfo;

  SupportData({required this.faqs, required this.faqsCount, this.contactInfo});

  factory SupportData.fromJson(Map<String, dynamic>? json) {
    return SupportData(
      faqs: json?['faqs'] != null
          ? (json?['faqs'] as List).map((e) => FaqModel.fromJson(e)).toList()
          : [],
      faqsCount: json?['faqsCount'] ?? 0,
      contactInfo: json?['contactInfo'] != null
          ? ContactInfoModel.fromJson(json?['contactInfo'])
          : null,
    );
  }
}

class FaqModel {
  // هنا التعديل الجوهري: جعلنا الحقول تدعم الـ Map أو النصوص المباشرة
  final String questionEn;
  final String questionAr;
  final String answerEn;
  final String answerAr;

  FaqModel({
    required this.questionEn,
    required this.questionAr,
    required this.answerEn,
    required this.answerAr,
  });

  factory FaqModel.fromJson(Map<String, dynamic>? json) {
    // هذه الطريقة تفحص إذا كان السيرفر يرسل السؤال كـ Object (ar/en) أو كحقل نصي عادي
    var q = json?['question'];
    var a = json?['answer'];

    return FaqModel(
      questionEn: q is Map
          ? (q['en']?.toString() ?? "")
          : (json?['questionEn']?.toString() ?? ""),
      questionAr: q is Map
          ? (q['ar']?.toString() ?? "")
          : (json?['questionAr']?.toString() ?? ""),
      answerEn: a is Map
          ? (a['en']?.toString() ?? "")
          : (json?['answerEn']?.toString() ?? ""),
      answerAr: a is Map
          ? (a['ar']?.toString() ?? "")
          : (json?['answerAr']?.toString() ?? ""),
    );
  }

  // دالة مساعدة لاستخدامها في الـ UI مباشرة
  String getQuestion(String lang) => lang == 'ar' ? questionAr : questionEn;
  String getAnswer(String lang) => lang == 'ar' ? answerAr : answerEn;
}

class ContactInfoModel {
  final String? email;
  final List<String> mobilePhones;

  ContactInfoModel({this.email, this.mobilePhones = const []});

  factory ContactInfoModel.fromJson(Map<String, dynamic>? json) {
    return ContactInfoModel(
      email: json?['email']?.toString(),
      mobilePhones: json?['mobilePhones'] != null
          ? List<String>.from(json?['mobilePhones'])
          : [],
    );
  }
}
