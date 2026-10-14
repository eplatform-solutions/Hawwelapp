// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:hawwel/constans/appr_images.dart';
// import 'package:hawwel/constans/localization/app_tranzaction.dart';

// class Detalestranzationosta extends StatelessWidget {
//   final String currency;
//   final double amount;
//   final bool isReceived; // âœ… true = Ø§Ø³ØªÙ„Ø§Ù…ØŒ false = Ø¥Ø±Ø³Ø§Ù„

//   const Detalestranzationosta({
//     super.key,
//     required this.currency,
//     required this.amount,
//     required this.isReceived,
//   });

//   @override
//   Widget build(BuildContext context) {
//     // âœ… Ø¥Ø¹Ø¯Ø§Ø¯Ø§Øª Ø­Ø³Ø¨ Ù†ÙˆØ¹ Ø§Ù„Ø¹Ù…Ù„ÙŠØ©
//     final bool isNegative = !isReceived;
//     final Color amountColor = isReceived
//         ? const Color(0xFF007E6B) // Ø£Ø®Ø¶Ø±
//         : const Color(0xFF6B1F2A); // Ø£Ø­Ù…Ø±
//     final String sign = isReceived ? '+' : '-';
//     final String statusText = isReceived
//         ? 'ØªÙ… Ø§Ø³ØªÙ„Ø§Ù…Ù‡'
//         : AppTranslations.getText(context, 'It was sent');
//     final String fromToText = isReceived
//         ? 'Ø§Ù„Ø§Ø³ØªÙ„Ø§Ù… Ù…Ù†'
//         : AppTranslations.getText(context, 'Send to');
//     final String iconPath = isReceived ? AppImages.ricive : AppImages.send;
//     final bool isArabic = Localizations.localeOf(context).languageCode == 'ar';
//     return Directionality(
//       textDirection: isArabic ? TextDirection.ltr : TextDirection.rtl,
//       child: Scaffold(
//         backgroundColor: Colors.white,
//         body: Column(
//           children: [
//             SizedBox(height: 50.h),
//             // ðŸ”¹ Ø§Ù„Ø¹Ù†ÙˆØ§Ù†
//             Padding(
//               padding: EdgeInsets.symmetric(horizontal: 128.w),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Image.asset(
//                     currency == 'USDC' ? AppImages.usdc : AppImages.usdt,
//                     height: 30.h,
//                     width: 30.w,
//                   ),
//                   SizedBox(width: 6.w),
//                   Text(
//                     '$currency Coin',
//                     style: GoogleFonts.cairo(
//                       fontSize: 18.sp,
//                       fontWeight: FontWeight.w700,
//                       color: const Color(0xFF545454),
//                     ),
//                   ),
//                 ],
//               ),
//             ),

//             SizedBox(height: 10.h),

//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text(
//                   '$sign${amount.toStringAsFixed(1)} ',
//                   style: GoogleFonts.cairo(
//                     fontSize: 24.sp,
//                     fontWeight: FontWeight.bold,
//                     color: amountColor,
//                   ),
//                 ),
//                 SizedBox(width: 10.w),
//                 Text(
//                   currency,
//                   style: GoogleFonts.cairo(
//                     fontSize: 24.sp,
//                     fontWeight: FontWeight.bold,
//                     color: branding.primaryText,
//                   ),
//                 ),
//               ],
//             ),

//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Image.asset(
//                   AppImages.check,
//                   color: const Color(0xFF138372),
//                   height: 20.h,
//                   width: 20.w,
//                 ),
//                 SizedBox(width: 10.w),
//                 Text(
//                   statusText,
//                   style: GoogleFonts.cairo(
//                     fontSize: 18.sp,
//                     fontWeight: FontWeight.bold,
//                     color: const Color(0xFF138372),
//                   ),
//                 ),
//               ],
//             ),

//             SizedBox(height: 80.h),

//             Padding(
//               padding: EdgeInsets.symmetric(horizontal: 16.w),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceAround,
//                 children: [
//                   Column(
//                     children: [
//                       Text(
//                         'Ahmad Ali',
//                         style: GoogleFonts.cairo(
//                           fontSize: 18.sp,
//                           fontWeight: FontWeight.bold,
//                           color: branding.secondaryText,
//                         ),
//                       ),
//                       SizedBox(height: 25.h),
//                       Text(
//                         '9699834564+',
//                         style: GoogleFonts.cairo(
//                           fontSize: 18.sp,
//                           fontWeight: FontWeight.bold,
//                           color: branding.secondaryText,
//                         ),
//                       ),
//                     ],
//                   ),
//                   SizedBox(width: 50.w),
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.end,
//                     children: [
//                       SizedBox(height: 15.h),
//                       Text(
//                         fromToText,
//                         style: GoogleFonts.cairo(
//                           fontSize: 19.sp,
//                           fontWeight: FontWeight.bold,
//                           color: branding.primaryText,
//                         ),
//                       ),
//                       Row(
//                         children: [
//                           Image.asset(
//                             AppImages.shamcash,
//                             height: 70.h,
//                             width: 70.w,
//                           ),

//                           Text(
//                             'Ø¹Ø¨Ø± Ø´Ø§Ù… ÙƒØ§Ø´ ',
//                             style: GoogleFonts.cairo(
//                               fontSize: 14.sp,
//                               fontWeight: FontWeight.bold,
//                               color: const Color(0xFFB9A779),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),

//             SizedBox(height: 70.h),

//             // ðŸ”¹ Ø²Ø± Ø§Ù„Ø­ÙØ¸
//             Container(
//               height: 60.h,
//               width: 200.w,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(30),
//                 color: const Color(0xFF138372),
//               ),
//               child: Center(
//                 child: Text(
//                   AppTranslations.getText(context, 'Saving information'),
//                   style: GoogleFonts.cairo(
//                     color: Colors.white,
//                     fontSize: 20.sp,
//                     fontWeight: FontWeight.w700,
//                   ),
//                 ),
//               ),
//             ),

//             SizedBox(height: 30.h),

//             // ðŸ”¹ ÙØ§ØµÙ„
//             Container(
//               height: 2.h,
//               width: double.infinity,
//               color: const Color(0xFF000000),
//             ),

//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Padding(
//                   padding: EdgeInsets.symmetric(
//                     horizontal: 16.w,
//                     vertical: 20.h,
//                   ),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       SizedBox(width: 0.w),
//                       Text(
//                         '2025/11/06 16:50:05',
//                         style: GoogleFonts.cairo(
//                           fontSize: 14.sp,
//                           fontWeight: FontWeight.bold,
//                           color: branding.primaryText,
//                         ),
//                       ),
//                       SizedBox(width: 110.w),
//                       Text(
//                         AppTranslations.getText(context, 'Created'),
//                         style: GoogleFonts.cairo(
//                           fontSize: 18.sp,
//                           fontWeight: FontWeight.bold,
//                           color: branding.primaryText,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Padding(
//                   padding: EdgeInsets.symmetric(horizontal: 16.w),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         '2025110613441219864294',
//                         style: GoogleFonts.cairo(
//                           fontSize: 12.sp,
//                           fontWeight: FontWeight.bold,
//                           color: branding.primaryText,
//                         ),
//                       ),
//                       // SizedBox(width: 65.w),
//                       Text(
//                         AppTranslations.getText(context, 'Reference request'),
//                         style: GoogleFonts.cairo(
//                           fontSize: 18.sp,
//                           fontWeight: FontWeight.bold,
//                           color: branding.primaryText,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class TransactionModel {
//   final String amount;
//   final String currency;
//   final bool isSend; // ðŸ”¹ true = Ø¥Ø±Ø³Ø§Ù„ØŒ false = Ø§Ø³ØªÙ„Ø§Ù…
//   // final String email;
//   // final String date;
//   // final String reference;

//   TransactionModel({
//     required this.amount,
//     required this.currency,
//     required this.isSend,
//     // required this.email,
//     // required this.date,
//     // required this.reference,
//   });
// }
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';
import 'package:hawwel/constans/widgets/in_tree_capture.dart';
import 'package:hawwel/featue/transaction_historu/widjt/transfer_photo_card.dart';
import 'package:hawwel/featue/transaction_historu/widjt/transfer_receipt_pdf.dart';
// ignore_for_file: non_constant_identifier_names

import 'package:hawwel/constans/api_servise.dart';
import 'package:hawwel/constans/appr_images.dart';
import 'package:hawwel/constans/localization/app_tranzaction.dart';
import 'package:hawwel/constans/localization/lang_cubit.dart';
import 'package:hawwel/constans/transfer_status_theme.dart';
import 'package:hawwel/featue/auth/login/widjt/snack_bara.dart';
import 'package:hawwel/featue/name_saved/name_saved_vew/datat/cubit/cubit.dart';
import 'package:hawwel/featue/name_saved/name_saved_vew/datat/cubit/cubit_stat.dart';
import 'package:hawwel/featue/auth/welcomyou/data/cubit_amount_to_send.dart';
import 'package:hawwel/constans/app_branding.dart';
import 'package:hawwel/constans/widgets/app_back_button.dart';

class Detalestranzationosta extends StatefulWidget {
  final String currency;
  final double amount;
  final double paidAmount;
  final bool isReceived;
  final String stat;
  final String senderName;
  final String senderPhone;
  final String receiverName;
  final String receiverPhone;
  final String paymentMethodName;
  final String paymentMethodLogo;
  final String createdAt;
  final String transferNumber;
  final String City;
  final String Area;
  final String total;
  final String transferamount;
  final String fee;
  final String paymentProofNote;
  final String paymentProofImagePath;
  final String receivingPlaceImagePath;

  const Detalestranzationosta({
    super.key,
    required this.total,
    required this.transferamount,
    required this.stat,
    required this.Area,
    required this.fee,
    required this.City,
    required this.currency,
    required this.amount,
    this.paidAmount = 0.0,
    required this.isReceived,
    required this.senderName,
    required this.senderPhone,
    required this.receiverName,
    required this.receiverPhone,
    required this.paymentMethodName,
    required this.paymentMethodLogo,
    required this.createdAt,
    required this.transferNumber,
    this.paymentProofNote = '',
    this.paymentProofImagePath = '',
    this.receivingPlaceImagePath = '',
  });

  @override
  State<Detalestranzationosta> createState() => _DetalestranzationostaState();
}

class _DetalestranzationostaState extends State<Detalestranzationosta> {
  bool _isSharingPdf = false;
  bool _isSharingImage = false;

  String get _resolvedCurrency {
    final c = widget.currency.trim().toUpperCase();
    return c.isEmpty ? 'USDT' : c;
  }

  String get _deliveryCurrencyLabel {
    switch (_resolvedCurrency) {
      case 'USDT':
      case 'USDC':
      case 'USD':
        return 'دولار أمريكي';
      case 'SYP':
      case 'SYR':
        return 'ليرة سورية';
      case 'TRY':
      case 'TL':
        return 'ليرة تركية';
      default:
        final raw = widget.currency.trim();
        return raw.isEmpty ? 'دولار أمريكي' : raw;
    }
  }

  String _dateOnly(String raw) {
    final value = raw.trim();
    if (value.isEmpty) return value;

    final parsed = DateTime.tryParse(value);
    if (parsed != null) {
      return '${parsed.year}/${parsed.month.toString().padLeft(2, '0')}/${parsed.day.toString().padLeft(2, '0')}';
    }

    final ymd = RegExp(r'(\d{4}[/-]\d{1,2}[/-]\d{1,2})').firstMatch(value);
    if (ymd != null) return ymd.group(1)!;

    final dmy = RegExp(r'(\d{1,2}[/-]\d{1,2}[/-]\d{4})').firstMatch(value);
    if (dmy != null) return dmy.group(1)!;

    final parts = value.split(RegExp(r'\s+'));
    return parts.isEmpty ? value : parts.last;
  }

  // The requested amount (widget.amount) never changes once the transfer is
  // created - only the actually-received amount (widget.paidAmount) reflects
  // what the sender really paid. Surface both explicitly whenever they
  // differ, instead of letting the customer assume the requested amount is
  // what went through.
  bool get _hasAmountMismatch {
    final normalized = normalizeTransferStatus(widget.stat);
    return (normalized == 'under-paid' || normalized == 'over-paid') &&
        widget.paidAmount > 0;
  }

  String _detailsStatusText(bool isArabic) {
    final normalized = normalizeTransferStatus(widget.stat);
    if (normalized == 'full-paid') {
      return isArabic
          ? 'تم الدفع - جاري اعداد عنوان الاستلام'
          : 'Paid - pickup address is being prepared';
    }
    return transferStatusLabel(context, widget.stat);
  }

  String get _displayCurrency {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    return SendCurrencyHelper.displayLabelForSymbol(
      _resolvedCurrency,
      isArabic: isArabic,
    );
  }

  // The notice is still worth sharing without a photo, so a failed download
  // just leaves that section out instead of aborting the whole share.
  Future<Uint8List?> _downloadImage(String path) async {
    final trimmed = path.trim();
    if (trimmed.isEmpty) return null;
    try {
      final response = await Dio().get<List<int>>(
        ApiService.resolveAssetUrl(trimmed),
        options: Options(responseType: ResponseType.bytes),
      );
      final data = response.data;
      if (data == null || data.isEmpty) return null;
      return Uint8List.fromList(data);
    } catch (_) {
      return null;
    }
  }

  static const double _noticeWidth = 980;
  static const double _noticePixelRatio = 1.5;

  /// The payment-notice design (header, order details, notes + delivery
  /// address photo, footer) exactly as before; only the rendering path
  /// changed - see [captureWidgetPng].
  Widget _buildNoticeWidget(Uint8List? deliveryImageBytes) {
    final destinationParts = <String>[
      if (widget.City.trim().isNotEmpty) widget.City.trim(),
      if (widget.Area.trim().isNotEmpty) widget.Area.trim(),
    ];
    return TransferNoticeCard(
      transferNumber: widget.transferNumber.trim(),
      recipientName: widget.receiverName.trim(),
      recipientPhone: widget.receiverPhone.trim(),
      destination: destinationParts.join(' - '),
      createdAt: _dateOnly(widget.createdAt),
      amountLabel: '${widget.amount.toStringAsFixed(2)} $_deliveryCurrencyLabel',
      adminNote: widget.paymentProofNote.trim(),
      deliveryImageBytes: deliveryImageBytes,
      orderDetailsTitle: AppTranslations.getTextStatic(
        context,
        'order_details_section',
      ),
      paymentNoticeTitle: AppTranslations.getTextStatic(
        context,
        'payment_notice_title',
      ),
    );
  }

  /// Renders the notice to PNG bytes (shared by the image and PDF actions).
  Future<Uint8List?> _renderNoticePng() async {
    // The delivery-address photo is what the beneficiary needs; fall back
    // to the handover proof for transfers uploaded before the split.
    final deliveryImage =
        await _downloadImage(widget.receivingPlaceImagePath) ??
            await _downloadImage(widget.paymentProofImagePath);
    if (!mounted) return null;
    if (deliveryImage != null) {
      // Decode before capture so the snapshot doesn't catch an empty slot.
      await precacheImage(MemoryImage(deliveryImage), context);
      if (!mounted) return null;
    }
    return captureWidgetPng(
      context,
      _buildNoticeWidget(deliveryImage),
      width: _noticeWidth,
      pixelRatio: _noticePixelRatio,
    );
  }

  void _showShareError() {
    if (!mounted) return;
    final branding = appBrandingNotifier.value;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.zero,
        padding: EdgeInsets.zero,
        content: CustomSnackBar(
          backgroundColor: branding.iconPrimary,
          message: AppTranslations.getTextStatic(context, 'image_load_error'),
          imagePath: AppImages.eerorrimage,
        ),
      ),
    );
  }

  /// Shares the same notice as a PNG - the quick "send it on WhatsApp" path.
  Future<void> _shareTransferNoticeImage() async {
    if (_isSharingImage) return;
    setState(() => _isSharingImage = true);
    try {
      final number = widget.transferNumber.trim();
      final shareTitle = AppTranslations.getTextStatic(
        context,
        'pdf_share_subject',
      ).replaceAll('{number}', number);
      final png = await _renderNoticePng();
      if (png == null || !mounted) return;
      await SharePlus.instance.share(
        ShareParams(
          files: [
            XFile.fromData(
              png,
              mimeType: 'image/png',
              name: 'hawwel_transfer_notice_$number.png',
            ),
          ],
          subject: shareTitle,
          title: shareTitle,
        ),
      );
    } catch (_) {
      _showShareError();
    } finally {
      if (mounted) setState(() => _isSharingImage = false);
    }
  }

  Future<void> _shareTransferReceiptPdf() async {
    if (_isSharingPdf) return;

    setState(() => _isSharingPdf = true);
    try {
      final number = widget.transferNumber.trim();
      final shareTitle = AppTranslations.getTextStatic(
        context,
        'pdf_share_subject',
      ).replaceAll('{number}', number);
      final fileName = AppTranslations.getTextStatic(
        context,
        'pdf_filename',
      ).replaceAll('{number}', number);

      final png = await _renderNoticePng();
      if (png == null || !mounted) return;
      final decoded = await decodeImageFromList(png);
      final pixelWidth = decoded.width;
      final pixelHeight = decoded.height;
      decoded.dispose();

      final bytes = await wrapNoticeImageAsPdf(
        png,
        pixelWidth: pixelWidth,
        pixelHeight: pixelHeight,
        pixelRatio: _noticePixelRatio,
        title: shareTitle,
      );
      if (!mounted) return;

      await SharePlus.instance.share(
        ShareParams(
          files: [
            XFile.fromData(
              bytes,
              mimeType: 'application/pdf',
              name: fileName,
            ),
          ],
          subject: shareTitle,
          title: shareTitle,
        ),
      );
    } catch (_) {
      _showShareError();
    } finally {
      if (mounted) {
        setState(() => _isSharingPdf = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final branding = appBrandingNotifier.value;
    final bool isArabic =
        context.watch<LanguageCubit>().state == Language.arabic;
    final statusVisual = resolveTransferStatusVisual(widget.stat, branding);
    final statusColor = statusVisual.color;

    // â”€â”€ helper: info row â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
    // Label Ø¹Ù„Ù‰ Ø§Ù„ÙŠØ³Ø§Ø± (start) Ø«Ù… Ø§Ù„Ù†Ù‚Ø·ØªØ§Ù†ØŒ Ø§Ù„Ù‚ÙŠÙ…Ø© Ø¹Ù„Ù‰ Ø§Ù„ÙŠÙ…ÙŠÙ† (end)
    Widget infoRow(String label, String value, {bool ltr = false}) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 6.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Label + colon always on the start side
            Text(
              '$label:',
              style: GoogleFonts.cairo(
                fontSize: 13.sp,
                color: branding.secondaryText,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: Directionality(
                textDirection: ltr ? TextDirection.ltr : TextDirection.ltr,
                child: Text(
                  value,
                  textAlign: isArabic ? TextAlign.end : TextAlign.start,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.cairo(
                    fontSize: 13.sp,
                    color: branding.primaryText,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    Widget divider() =>
        Divider(color: branding.hintText.withValues(alpha: 0.12), height: 1);

    Widget sectionCard({required String title, required List<Widget> rows}) {
      return Container(
        margin: EdgeInsets.only(bottom: 10.h),
        decoration: BoxDecoration(
          color: branding.inputBorder.withValues(alpha: 0.45),
          borderRadius: BorderRadius.circular(18.r),
          border: Border.all(
            color: branding.hintText.withValues(alpha: 0.1),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(14.w, 10.h, 14.w, 7.h),
              child: Text(
                title,
                style: GoogleFonts.cairo(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  color: branding.iconPrimary,
                ),
              ),
            ),
            Divider(
              color: branding.iconPrimary.withValues(alpha: 0.15),
              height: 1,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 14.w),
              child: Column(
                children: rows.expand((w) => [w, divider()]).toList()
                  ..removeLast(),
              ),
            ),
            SizedBox(height: 2.h),
          ],
        ),
      );
    }

    return Directionality(
      textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: branding.screenBg,
        body: Column(
          children: [
            // â”€â”€ Gradient Header â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: branding.buildHeaderGradient(),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(18.r),
                  bottomRight: Radius.circular(18.r),
                ),
              ),
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(14.w, 2.h, 14.w, 8.h),
                  child: Column(
                    children: [
                      // Back button row
                      Row(
                        children: [
                          AppBackButton(),
                          Expanded(
                            child: Text(
                              AppTranslations.getText(
                                context,
                                'transaction_details',
                              ),
                              textAlign: TextAlign.center,
                              style: GoogleFonts.cairo(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w700,
                                color: branding.buttonText,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: _isSharingPdf
                                ? null
                                : _shareTransferReceiptPdf,
                            child: Opacity(
                              opacity: 1,
                              child: Container(
                                width: 34.r,
                                height: 34.r,
                                decoration: BoxDecoration(
                                  color: branding.buttonText.withValues(
                                    alpha: 0.18,
                                  ),
                                  borderRadius: BorderRadius.circular(10.r),
                                ),
                                child: _isSharingPdf
                                    ? Center(
                                        child: SizedBox(
                                          width: 15.r,
                                          height: 15.r,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: branding.buttonText,
                                          ),
                                        ),
                                      )
                                    : Icon(
                                        Icons.share_rounded,
                                        color: branding.buttonText,
                                        size: 16,
                                      ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 5.h),

                      // Amount + currency icon
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SendCurrencyHelper.buildCoinIcon(
                            symbol: _resolvedCurrency,
                            height: 24.r,
                            width: 24.r,
                          ),
                          SizedBox(width: 6.w),
                          Text(
                            '${widget.amount.toStringAsFixed(2)} $_displayCurrency',
                            style: GoogleFonts.cairo(
                              fontSize: 22.sp,
                              fontWeight: FontWeight.bold,
                              color: branding.buttonText,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 5.h),

                      // Status badge
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 14.w,
                          vertical: 5.h,
                        ),
                        decoration: BoxDecoration(
                          color: branding.buttonText.withValues(alpha: 0.18),
                          borderRadius: BorderRadius.circular(50.r),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              statusVisual.icon,
                              color: statusColor,
                              size: 16,
                            ),
                            SizedBox(width: 6.w),
                            Text(
                              _detailsStatusText(isArabic),
                              style: GoogleFonts.cairo(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w700,
                                color: branding.buttonText,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // â”€â”€ Body â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.fromLTRB(14.w, 8.h, 14.w, 22.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // â”€â”€ Amount mismatch notice â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
                    if (_hasAmountMismatch) ...[
                      Container(
                        padding: EdgeInsets.all(14.r),
                        decoration: BoxDecoration(
                          color: statusColor.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(16.r),
                          border: Border.all(
                            color: statusColor.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Row(
                              children: [
                                Icon(statusVisual.icon,
                                    color: statusColor, size: 18.sp),
                                SizedBox(width: 8.w),
                                Expanded(
                                  child: Text(
                                    _detailsStatusText(isArabic),
                                    style: GoogleFonts.cairo(
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w700,
                                      color: statusColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10.h),
                            Row(
                              children: [
                                Expanded(
                                  child: infoRow(
                                    AppTranslations.getText(
                                      context,
                                      'requested_amount_label',
                                    ),
                                    '${widget.amount.toStringAsFixed(2)} $_displayCurrency',
                                    ltr: true,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: infoRow(
                                    AppTranslations.getText(
                                      context,
                                      'actually_paid_amount_label',
                                    ),
                                    '${widget.paidAmount.toStringAsFixed(2)} $_displayCurrency',
                                    ltr: true,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10.h),
                    ],

                    // â”€â”€ Summary chips â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
                    Row(
                      children: [
                        _SummaryChip(
                          label: AppTranslations.getText(
                            context,
                            'total_amount',
                          ),
                          value: widget.total,
                          branding: branding,
                        ),
                        SizedBox(width: 10.w),
                        _SummaryChip(
                          label: AppTranslations.getText(
                            context,
                            'transfer_amount1',
                          ),
                          value: widget.transferamount,
                          branding: branding,
                          highlight: true,
                        ),
                        SizedBox(width: 10.w),
                        _SummaryChip(
                          label: AppTranslations.getText(
                            context,
                            'fees_label1',
                          ),
                          value: '${widget.fee}%',
                          branding: branding,
                        ),
                      ],
                    ),

                    SizedBox(height: 10.h),

                    // â”€â”€ Receiver details â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
                    sectionCard(
                      title: AppTranslations.getText(context, 'Send to'),
                      rows: [
                        infoRow(
                          AppTranslations.getText(context, 'full_name'),
                          widget.receiverName,
                        ),
                        infoRow(
                          AppTranslations.getText(context, 'phone_label'),
                          widget.receiverPhone,
                          ltr: true,
                        ),
                        infoRow(
                          AppTranslations.getText(context, 'city1'),
                          widget.City,
                        ),
                        infoRow(
                          AppTranslations.getText(context, 'area_label'),
                          widget.Area,
                        ),
                      ],
                    ),

                    // Receiving place photo (attached while the transfer is
                    // still on its way) - separate from the handover proof.
                    if (widget.receivingPlaceImagePath.isNotEmpty) ...[
                      TransferPhotoCard(
                        imagePath: widget.receivingPlaceImagePath,
                        title: AppTranslations.getText(
                          context,
                          'receiving_place_image',
                        ),
                      ),
                      SizedBox(height: 10.h),
                    ],

                    // Payment proof (note + image) directly after receiver
                    if (widget.paymentProofNote.isNotEmpty ||
                        widget.paymentProofImagePath.isNotEmpty) ...[
                      Container(
                        decoration: BoxDecoration(
                          color: branding.inputBorder.withValues(alpha: 0.45),
                          borderRadius: BorderRadius.circular(18.r),
                          border: Border.all(
                            color: branding.hintText.withValues(alpha: 0.1),
                            width: 1,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Padding(
                              padding: EdgeInsets.fromLTRB(
                                14.w,
                                10.h,
                                14.w,
                                7.h,
                              ),
                              child: Text(
                                AppTranslations.getText(
                                  context,
                                  widget.paymentProofImagePath.isNotEmpty
                                      ? 'payment_proof_image'
                                      : 'transfer_admin_note',
                                ),
                                style: GoogleFonts.cairo(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w700,
                                  color: branding.iconPrimary,
                                ),
                              ),
                            ),
                            Divider(
                              color: branding.iconPrimary.withValues(
                                alpha: 0.15,
                              ),
                              height: 1,
                            ),
                            if (widget.paymentProofNote.isNotEmpty)
                              Padding(
                                padding: EdgeInsets.all(10.r),
                                child: Container(
                                  padding: EdgeInsets.all(10.r),
                                  decoration: BoxDecoration(
                                    color: branding.screenBg,
                                    borderRadius: BorderRadius.circular(12.r),
                                  ),
                                  child: Directionality(
                                    textDirection: isArabic
                                        ? TextDirection.rtl
                                        : TextDirection.ltr,
                                    child: Text(
                                      widget.paymentProofNote,
                                      style: GoogleFonts.cairo(
                                        fontSize: 14.sp,
                                        color: branding.secondaryText,
                                        height: 1.6,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            if (widget.paymentProofImagePath.isNotEmpty)
                              Padding(
                                padding: EdgeInsets.fromLTRB(
                                  10.w,
                                  widget.paymentProofNote.isEmpty ? 10.h : 0,
                                  10.w,
                                  10.h,
                                ),
                                child: TransferPhotoCard(
                                  imagePath: widget.paymentProofImagePath,
                                  title: AppTranslations.getText(
                                    context,
                                    'payment_proof_image',
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10.h),
                    ],

                    // â”€â”€ Payment method â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
                    sectionCard(
                      title: AppTranslations.getText(context, 'payment_method'),
                      rows: [
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 11.h),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                AppTranslations.getText(context, 'via'),
                                style: GoogleFonts.cairo(
                                  fontSize: 13.sp,
                                  color: branding.secondaryText,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (widget.paymentMethodLogo.isNotEmpty)
                                    Image.network(
                                      ApiService.resolveAssetUrl(
                                        widget.paymentMethodLogo,
                                      ),
                                      height: 20.h,
                                      width: 28.w,
                                      fit: BoxFit.contain,
                                      errorBuilder: (_, __, ___) =>
                                          const SizedBox.shrink(),
                                    ),
                                  SizedBox(width: 6.w),
                                  Text(
                                    widget.paymentMethodName,
                                    style: GoogleFonts.cairo(
                                      fontSize: 13.sp,
                                      color: branding.iconPrimary,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    // â”€â”€ Transaction info â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
                    sectionCard(
                      title: AppTranslations.getText(context, 'Created'),
                      rows: [
                        infoRow(
                          AppTranslations.getText(context, 'Created'),
                          widget.createdAt,
                          ltr: true,
                        ),
                        infoRow(
                          AppTranslations.getText(context, 'Reference request'),
                          widget.transferNumber,
                          ltr: true,
                        ),
                      ],
                    ),

                    // â”€â”€ Action buttons â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
                    BlocListener<ReceiversCubit, ReceiversState>(
                      listener: (context, state) {
                        if (state is ReceiversSuccess) {
                          context
                              .read<ReceiversCubit>()
                              .fullNameController
                              .clear();
                          context
                              .read<ReceiversCubit>()
                              .mobilePhoneController
                              .clear();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: Colors.transparent,
                              elevation: 0,
                              behavior: SnackBarBehavior.floating,
                              margin: EdgeInsets.zero,
                              padding: EdgeInsets.zero,
                              content: CustomSnackBar(
                                backgroundColor: branding.success,
                                message: state.message,
                                imagePath: AppImages.doneimage,
                              ),
                            ),
                          );
                        } else if (state is ReceiversFailure) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: Colors.transparent,
                              elevation: 0,
                              behavior: SnackBarBehavior.floating,
                              margin: EdgeInsets.zero,
                              padding: EdgeInsets.zero,
                              content: CustomSnackBar(
                                backgroundColor: branding.iconPrimary,
                                message: state.error,
                                imagePath: AppImages.eerorrimage,
                              ),
                            ),
                          );
                        }
                      },
                      child: BlocBuilder<ReceiversCubit, ReceiversState>(
                        builder: (context, state) {
                          // Beneficiaries are stored automatically with the
                          // transfer, so the old "save information" button
                          // was redundant; its slot now shares the notice as
                          // an image (the PDF button next to it stays).
                          final isLoading = _isSharingImage;
                          return Row(
                            children: [
                              // Share notice as image
                              Expanded(
                                child: GestureDetector(
                                  onTap: isLoading
                                      ? null
                                      : _shareTransferNoticeImage,
                                  child: Container(
                                    height: 50.h,
                                    decoration: BoxDecoration(
                                      color: isLoading
                                          ? branding.hintText
                                          : branding.badge,
                                      borderRadius: BorderRadius.circular(14.r),
                                    ),
                                    child: Center(
                                      child: isLoading
                                          ? SizedBox(
                                              height: 20.r,
                                              width: 20.r,
                                              child: CircularProgressIndicator(
                                                color: branding.buttonText,
                                                strokeWidth: 2,
                                              ),
                                            )
                                          : Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Icon(
                                                  Icons.image_outlined,
                                                  color: branding.buttonText,
                                                  size: 18,
                                                ),
                                                SizedBox(width: 6.w),
                                                Text(
                                                  AppTranslations.getText(
                                                    context,
                                                    'share_transfer_image',
                                                  ),
                                                  style: GoogleFonts.cairo(
                                                    color: branding.buttonText,
                                                    fontSize: 13.sp,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                              ],
                                            ),
                                    ),
                                  ),
                                ),
                              ),

                              // Share PDF button
                              ...[
                                SizedBox(width: 10.w),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: _isSharingPdf
                                        ? null
                                        : _shareTransferReceiptPdf,
                                    child: Ink(
                                      decoration: BoxDecoration(
                                        gradient: branding
                                            .buildHeaderGradient(),
                                        borderRadius: BorderRadius.circular(
                                          14.r,
                                        ),
                                      ),
                                      child: Container(
                                        height: 50.h,
                                        alignment: Alignment.center,
                                        child: _isSharingPdf
                                            ? SizedBox(
                                                height: 20.r,
                                                width: 20.r,
                                                child:
                                                    const CircularProgressIndicator(
                                                      color: Colors.white,
                                                      strokeWidth: 2,
                                                    ),
                                              )
                                            : Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  const Icon(
                                                    Icons.share_rounded,
                                                    color: Colors.white,
                                                    size: 18,
                                                  ),
                                                  SizedBox(width: 6.w),
                                                  Text(
                                                    AppTranslations.getText(
                                                      context,
                                                      'Share information',
                                                    ),
                                                    style: GoogleFonts.cairo(
                                                      color: Colors.white,
                                                      fontSize: 13.sp,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ReceiptHeader extends StatelessWidget {
  const ReceiptHeader({
    super.key,
    this.orderNumber,
    this.transparentIconAsset,
    this.title,
  });

  final String? orderNumber;
  final String? transparentIconAsset;
  final String? title;

  static const Color darkTeal = Color(0xFF062224);
  static const Color teal = Color(0xFF0A4A43);
  static const Color gold = Color(0xFFD4AF37);
  static const Color subtitleGray = Color(0xFF6F7782);
  static const Color lightBg = Color(0xFFFAFAF8);
  static const Color borderColor = Color(0xFFE3E8E6);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 138,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: borderColor),
        boxShadow: const [
          BoxShadow(
            color: Color(0x10003D3A),
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Stack(
              children: [
                Container(color: Colors.white),
                Positioned.fill(
                  child: CustomPaint(
                    painter: ReceiptHeaderPainter(),
                  ),
                ),
                Positioned(
                  left: 24,
                  top: 0,
                  bottom: 0,
                  width: 248,
                  child: HawwelHeaderLogo(
                    iconAsset: transparentIconAsset,
                  ),
                ),
                Positioned(
                  right: 24,
                  top: 34,
                  width: 235,
                  child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          title ??
                              AppTranslations.getText(
                                context,
                                'payment_notice_title',
                              ),
                          maxLines: 1,
                          overflow: TextOverflow.visible,
                          textAlign: TextAlign.right,
                          style: GoogleFonts.cairo(
                            color: const Color(0xFF0A4A43),
                            fontSize: 27,
                            fontWeight: FontWeight.w900,
                            height: 1.1,
                          ),
                        ),
                        const SizedBox(height: 8),
                        if (orderNumber != null && orderNumber!.trim().isNotEmpty) ...[
                          Align(
                            alignment: Alignment.centerRight,
                            child: Container(
                              constraints: const BoxConstraints(minWidth: 180),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 7,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF8FAF9),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: const Color(0xFFE3E8E6)),
                              ),
                              child: Text(
                                'رقم الطلب: ${orderNumber!.trim()}',
                                textDirection: TextDirection.rtl,
                                textAlign: TextAlign.right,
                                style: GoogleFonts.cairo(
                                  color: const Color(0xFF004B45),
                                  fontSize: 17,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class HawwelHeaderLogo extends StatelessWidget {
  const HawwelHeaderLogo({
    super.key,
    this.iconAsset,
  });

  final String? iconAsset;

  @override
  Widget build(BuildContext context) {
    final bool hasIcon = iconAsset != null && iconAsset!.trim().isNotEmpty;

    return Align(
      alignment: Alignment.centerLeft,
      child: Image.asset(
        'asset/hawwel_header_logo_800x200.webp',
        width: 232,
        height: 82,
        fit: BoxFit.contain,
        errorBuilder: (_, __, ___) {
          if (hasIcon) {
            return Image.asset(
              iconAsset!,
              width: 232,
              height: 82,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => const SizedBox(
                width: 70,
                height: 70,
                child: HawwelMiniMark(),
              ),
            );
          }
          return const SizedBox(
            width: 70,
            height: 70,
            child: HawwelMiniMark(),
          );
        },
      ),
    );
  }
}

class HawwelMiniMark extends StatelessWidget {
  const HawwelMiniMark({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: HawwelMiniMarkPainter(),
    );
  }
}

class HawwelMiniMarkPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final greenPaint = Paint()
      ..shader = const LinearGradient(
        colors: [
          Color(0xFF0E4A43),
          Color(0xFF1C6258),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    final goldPaint = Paint()
      ..shader = const LinearGradient(
        colors: [
          Color(0xFFF1D27A),
          Color(0xFFD4AF37),
          Color(0xFFB89245),
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final leftPath = Path()
      ..moveTo(size.width * 0.16, size.height * 0.15)
      ..lineTo(size.width * 0.49, size.height * 0.15)
      ..lineTo(size.width * 0.49, size.height * 0.56)
      ..lineTo(size.width * 0.16, size.height * 0.88)
      ..close();
    canvas.drawPath(leftPath, greenPaint);

    final rightShape = Path()
      ..moveTo(size.width * 0.49, size.height * 0.56)
      ..lineTo(size.width * 0.83, size.height * 0.22)
      ..lineTo(size.width * 0.83, size.height * 0.92)
      ..lineTo(size.width * 0.49, size.height * 0.92)
      ..close();
    canvas.drawPath(rightShape, goldPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class ReceiptHeaderPainter extends CustomPainter {
  static const Color darkTeal = Color(0xFF062224);
  static const Color teal = Color(0xFF003D3A);
  static const Color deepTeal = Color(0xFF0A3A37);
  static const Color gold = Color(0xFFD4AF37);

  @override
  void paint(Canvas canvas, Size size) {
    final tealPaint = Paint()
      ..shader = const LinearGradient(
        colors: [darkTeal, teal, deepTeal],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(
        Rect.fromLTWH(0, 0, size.width, size.height),
      );

    final patternPaint = Paint()
      ..color = const Color(0xFFD4AF37).withValues(alpha: 0.10)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    final goldPaint = Paint()
      ..shader = const LinearGradient(
        colors: [
          Color(0xFFF1D27A),
          Color(0xFFD4AF37),
          Color(0xFFB89245),
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.2
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final tealPath = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width * 0.63, 0)
      ..cubicTo(
        size.width * 0.56,
        size.height * 0.04,
        size.width * 0.50,
        size.height * 0.33,
        size.width * 0.44,
        size.height * 0.66,
      )
      ..cubicTo(
        size.width * 0.40,
        size.height * 0.91,
        size.width * 0.35,
        size.height,
        size.width * 0.25,
        size.height,
      )
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(tealPath, tealPaint);

    for (double x = 14; x < size.width * 0.34; x += 22) {
      canvas.drawLine(Offset(x, 6), Offset(x - 30, size.height - 8), patternPaint);
    }

    final goldPath = Path()
      ..moveTo(size.width * 0.63, 0)
      ..cubicTo(
        size.width * 0.56,
        size.height * 0.04,
        size.width * 0.50,
        size.height * 0.33,
        size.width * 0.44,
        size.height * 0.66,
      )
      ..cubicTo(
        size.width * 0.40,
        size.height * 0.91,
        size.width * 0.35,
        size.height,
        size.width * 0.25,
        size.height,
      )
      ..lineTo(0, size.height);

    canvas.drawPath(goldPath, goldPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class ReceiptSectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Widget> children;

  const ReceiptSectionCard({
    super.key,
    required this.title,
    this.icon = Icons.article_outlined,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 12),
          padding: const EdgeInsets.fromLTRB(14, 30, 14, 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE3E8E6)),
            boxShadow: const [
              BoxShadow(
                color: Color(0x12000000),
                blurRadius: 6,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: children,
          ),
        ),
        Positioned(
          top: 0,
          right: 10,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFF004B45),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xFFC9A24A).withValues(alpha: 0.35),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 18, color: const Color(0xFFC9A24A)),
                const SizedBox(width: 6),
                Text(
                  title,
                  textDirection: TextDirection.rtl,
                  style: GoogleFonts.cairo(
                    fontSize: 22,
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class ReceiptInfoTile extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const ReceiptInfoTile({
    super.key,
    required this.label,
    required this.value,
    this.icon = Icons.info_outline_rounded,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 50),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAF9),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE3E8E6)),
      ),
      child: Row(
        textDirection: TextDirection.rtl,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: const Color(0xFFC9A24A).withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 15, color: const Color(0xFFC9A24A)),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: RichText(
              textDirection: TextDirection.rtl,
              text: TextSpan(
                style: GoogleFonts.cairo(
                  fontSize: 19,
                  color: const Color(0xFF1F2937),
                  fontWeight: FontWeight.w700,
                ),
                children: [
                  TextSpan(
                    text: '$label: ',
                    style: GoogleFonts.cairo(
                      fontSize: 18,
                      color: const Color(0xFF6B7280),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  TextSpan(
                    text: value,
                    style: GoogleFonts.cairo(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF1F2937),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DeliveryAddressCard extends StatelessWidget {
  final String title;
  final Uint8List imageBytes;
  final String caption;

  const DeliveryAddressCard({
    super.key,
    required this.title,
    required this.imageBytes,
    required this.caption,
  });

  @override
  Widget build(BuildContext context) {
    return ReceiptSectionCard(
      title: title,
      icon: Icons.place_outlined,
      children: [
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAF9),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE3E8E6)),
          ),
          padding: const EdgeInsets.all(12),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 190),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.memory(
                  imageBytes,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          caption,
          textDirection: TextDirection.rtl,
          textAlign: TextAlign.center,
          style: GoogleFonts.cairo(
            fontSize: 15,
            color: const Color(0xFF6B7280),
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class TransferSummaryCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const TransferSummaryCard({
    super.key,
    required this.label,
    required this.value,
    this.icon = Icons.info_outline_rounded,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 322,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAF9),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE3E8E6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            textDirection: TextDirection.rtl,
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: const Color(0xFFC9A24A).withValues(alpha: 0.14),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 15, color: const Color(0xFFC9A24A)),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  label,
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.right,
                  style: GoogleFonts.cairo(
                    fontSize: 15,
                    color: const Color(0xFF6B7280),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            textDirection: TextDirection.rtl,
            textAlign: TextAlign.right,
            style: GoogleFonts.cairo(
              fontSize: 16,
              color: const Color(0xFF1F2937),
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class ImportantNotesCard extends StatelessWidget {
  final String line1;
  final String line2;
  final String line3;

  const ImportantNotesCard({
    super.key,
    required this.line1,
    required this.line2,
    required this.line3,
  });

  @override
  Widget build(BuildContext context) {
    Widget noteLine(String text) {
      return Row(
        textDirection: TextDirection.rtl,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsetsDirectional.only(end: 6, top: 4),
            child: Icon(Icons.circle, size: 7, color: Color(0xFF0B8A78)),
          ),
          Expanded(
            child: Text(
              text,
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.right,
              style: GoogleFonts.cairo(
                fontSize: 14,
                color: const Color(0xFF374151),
                fontWeight: FontWeight.w600,
                height: 1.3,
              ),
            ),
          ),
        ],
      );
    }

    return ReceiptSectionCard(
      title: 'ملاحظات هامة',
      icon: Icons.verified_outlined,
      children: [
        noteLine(line1),
        const SizedBox(height: 4),
        noteLine(line2),
        const SizedBox(height: 4),
        noteLine(line3),
      ],
    );
  }
}

class DeliveryImageCard extends StatelessWidget {
  final Uint8List? imageBytes;
  final String caption;

  const DeliveryImageCard({
    super.key,
    required this.imageBytes,
    required this.caption,
  });

  @override
  Widget build(BuildContext context) {
    return ReceiptSectionCard(
      title: 'عنوان التسليم',
      icon: Icons.place_outlined,
      children: [
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAF9),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE3E8E6)),
          ),
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              if (imageBytes != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxHeight: 240),
                    child: Image.memory(
                      imageBytes!,
                      fit: BoxFit.contain,
                    ),
                  ),
                )
              else
                Container(
                  constraints: const BoxConstraints(minHeight: 220),
                  alignment: Alignment.center,
                  child: Text(
                    'لا توجد صورة مرفقة للعنوان',
                    textDirection: TextDirection.rtl,
                    style: GoogleFonts.cairo(
                      color: const Color(0xFF6B7280),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              const SizedBox(height: 8),
              Text(
                caption,
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.center,
                style: GoogleFonts.cairo(
                  fontSize: 14,
                  color: const Color(0xFF6B7280),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class AdminNoteCard extends StatelessWidget {
  final String note;

  const AdminNoteCard({super.key, required this.note});

  @override
  Widget build(BuildContext context) {
    return ReceiptSectionCard(
      title: 'ملاحظة الإدارة',
      icon: Icons.campaign_outlined,
      children: [
        Text(
          note,
          textDirection: TextDirection.rtl,
          textAlign: TextAlign.right,
          style: GoogleFonts.cairo(
            fontSize: 15,
            color: const Color(0xFF263238),
            fontWeight: FontWeight.w600,
            height: 1.35,
          ),
        ),
      ],
    );
  }
}

class ReceiptFooter extends StatelessWidget {
  const ReceiptFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE1E7E5)),
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: 1,
            color: const Color(0xFFD4AF37).withValues(alpha: 0.45),
          ),
          const SizedBox(height: 8),
          Text(
            'حوّل ... تحويلك بأمان',
            style: GoogleFonts.cairo(
              fontSize: 21,
              color: const Color(0xFF004B45),
              fontWeight: FontWeight.w800,
            ),
            textDirection: TextDirection.rtl,
          ),
          const SizedBox(height: 4),
          Text(
            '${DateTime.now().year}/${DateTime.now().month.toString().padLeft(2, '0')}/${DateTime.now().day.toString().padLeft(2, '0')} '
            '${DateTime.now().hour.toString().padLeft(2, '0')}:${DateTime.now().minute.toString().padLeft(2, '0')}',
            style: GoogleFonts.cairo(
              fontSize: 16,
              color: const Color(0xFF6B7280),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class MergedNotesCard extends StatelessWidget {
  final Uint8List? deliveryImageBytes;
  final String adminNote;

  const MergedNotesCard({
    super.key,
    required this.deliveryImageBytes,
    required this.adminNote,
  });

  @override
  Widget build(BuildContext context) {
    Widget noteLine(String text) {
      return Row(
        textDirection: TextDirection.rtl,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsetsDirectional.only(end: 6, top: 4),
            child: Icon(Icons.circle, size: 7, color: Color(0xFF0B8A78)),
          ),
          Expanded(
            child: Text(
              text,
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.right,
              style: GoogleFonts.cairo(
                fontSize: 17,
                color: const Color(0xFF374151),
                fontWeight: FontWeight.w600,
                height: 1.35,
              ),
            ),
          ),
        ],
      );
    }

    final boxDecoration = BoxDecoration(
      color: const Color(0xFFF8FAF9),
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: const Color(0xFFE3E8E6)),
    );

    return ReceiptSectionCard(
      title: 'ملاحظات هامة',
      icon: Icons.verified_outlined,
      children: [
        // Both boxes share one fixed height and the delivery photo fills its
        // box - it used to sit as a small 220px thumbnail inside a much
        // larger frame. (A fixed height rather than IntrinsicHeight: the
        // photo's natural size must not dictate the layout.)
        SizedBox(
          height: 360,
          child: Row(
            textDirection: TextDirection.rtl,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                flex: 2,
                child: Container(
                  decoration: boxDecoration,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (adminNote.isNotEmpty) ...[
                        noteLine(adminNote),
                        const SizedBox(height: 7),
                      ],
                      const SizedBox(height: 7),
                      noteLine(
                        AppTranslations.getText(
                          context,
                          'order_share_privacy_note',
                        ),
                      ),
                      const SizedBox(height: 7),
                      noteLine(
                        AppTranslations.getText(
                          context,
                          'delivery_identity_note',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 3,
                child: Container(
                  decoration: boxDecoration,
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: deliveryImageBytes != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.memory(
                                  deliveryImageBytes!,
                                  fit: BoxFit.contain,
                                ),
                              )
                            : Center(
                                child: Text(
                                  'لا توجد صورة مرفقة للعنوان',
                                  textDirection: TextDirection.rtl,
                                  style: GoogleFonts.cairo(
                                    color: const Color(0xFF6B7280),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'عنوان التسليم',
                        textAlign: TextAlign.center,
                        textDirection: TextDirection.rtl,
                        style: GoogleFonts.cairo(
                          fontSize: 16,
                          color: const Color(0xFF6B7280),
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// â”€â”€ Summary chip helper â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
class _SummaryChip extends StatelessWidget {
  final String label;
  final String value;
  final dynamic branding;
  final bool highlight;

  const _SummaryChip({
    required this.label,
    required this.value,
    required this.branding,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 10.w),
        decoration: BoxDecoration(
          color: highlight
              ? branding.iconPrimary.withValues(alpha: 0.1)
              : branding.inputBorder.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(
            color: highlight
                ? branding.iconPrimary.withValues(alpha: 0.25)
                : branding.hintText.withValues(alpha: 0.1),
          ),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: GoogleFonts.cairo(
                fontSize: 14.sp,
                fontWeight: FontWeight.w800,
                color: highlight ? branding.iconPrimary : branding.primaryText,
              ),
            ),
            SizedBox(height: 3.h),
            Text(
              label,
              textAlign: TextAlign.center,
              style: GoogleFonts.cairo(
                fontSize: 10.sp,
                color: branding.secondaryText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// The transfer-notice design shared as PNG (image button) and wrapped as
/// PDF (PDF button). Pure presentation: every value is passed in so the
/// exact output can be rendered in a test without the details screen.
class TransferNoticeCard extends StatelessWidget {
  static const double width = 980;

  final String transferNumber;
  final String recipientName;
  final String recipientPhone;
  final String destination;
  final String createdAt;
  final String amountLabel;
  final String adminNote;
  final Uint8List? deliveryImageBytes;
  final String orderDetailsTitle;
  final String paymentNoticeTitle;

  const TransferNoticeCard({
    super.key,
    required this.transferNumber,
    required this.recipientName,
    required this.recipientPhone,
    required this.destination,
    required this.createdAt,
    required this.amountLabel,
    required this.adminNote,
    required this.deliveryImageBytes,
    required this.orderDetailsTitle,
    required this.paymentNoticeTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        width: width,
        color: const Color(0xFFF8FAF9),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ReceiptHeader(
              orderNumber: transferNumber,
              transparentIconAsset: null,
              title: paymentNoticeTitle,
            ),
            const SizedBox(height: 10),
            ReceiptSectionCard(
              title: orderDetailsTitle,
              icon: Icons.person_outline_rounded,
              children: [
                const SizedBox(height: 12),
                Row(
                  textDirection: TextDirection.rtl,
                  children: [
                    Expanded(
                      child: ReceiptInfoTile(
                        label: 'اسم المستفيد',
                        value: recipientName.isEmpty ? '-' : recipientName,
                        icon: Icons.person_outline_rounded,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ReceiptInfoTile(
                        label: 'الجوال',
                        value: recipientPhone.isEmpty
                            ? '-'
                            : '‎$recipientPhone',
                        icon: Icons.phone_android_rounded,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  textDirection: TextDirection.rtl,
                  children: [
                    Expanded(
                      child: ReceiptInfoTile(
                        label: 'الوجهة',
                        value: destination.isEmpty ? '-' : destination,
                        icon: Icons.place_outlined,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ReceiptInfoTile(
                        label: 'التاريخ',
                        value: createdAt.isEmpty ? '-' : createdAt,
                        icon: Icons.calendar_today_rounded,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 9),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 11,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAF9),
                    borderRadius: BorderRadius.circular(13),
                    border: Border.all(color: const Color(0xFFE3E8E6)),
                  ),
                  child: SizedBox(
                    height: 36,
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            'المبلغ',
                            textDirection: TextDirection.rtl,
                            style: GoogleFonts.cairo(
                              fontSize: 16,
                              color: const Color(0xFF6B7280),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        Center(
                          child: Text(
                            amountLabel,
                            textDirection: TextDirection.rtl,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.cairo(
                              fontSize: 28,
                              color: const Color(0xFF004B45),
                              fontWeight: FontWeight.w900,
                              height: 1.15,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              textDirection: TextDirection.rtl,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: MergedNotesCard(
                    deliveryImageBytes: deliveryImageBytes,
                    adminNote: adminNote,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            const ReceiptFooter(),
          ],
        ),
      ),
    );
  }
}
