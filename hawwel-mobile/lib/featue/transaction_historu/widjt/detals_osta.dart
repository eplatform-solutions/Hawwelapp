// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:usdt/constans/appr_images.dart';
// import 'package:usdt/constans/localization/app_tranzaction.dart';

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
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';
import 'package:usdt/constans/api_servise.dart';
import 'package:usdt/constans/appr_images.dart';
import 'package:usdt/constans/localization/app_tranzaction.dart';
import 'package:usdt/constans/localization/lang_cubit.dart';
import 'package:usdt/featue/auth/login/widjt/snack_bara.dart';
import 'package:usdt/featue/name_saved/name_saved_vew/datat/cubit/cubit.dart';
import 'package:usdt/featue/name_saved/name_saved_vew/datat/cubit/cubit_stat.dart';
import 'package:usdt/constans/app_branding.dart';
import 'package:usdt/constans/pdf_arabic_text.dart';

class Detalestranzationosta extends StatefulWidget {
  final String currency;
  final double amount;
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
  });

  @override
  State<Detalestranzationosta> createState() => _DetalestranzationostaState();
}

class _DetalestranzationostaState extends State<Detalestranzationosta> {
  bool _isSharingPdf = false;

  bool get _hasPaymentProofDetails =>
      widget.paymentProofNote.trim().isNotEmpty &&
      widget.paymentProofImagePath.trim().isNotEmpty;

  Future<void> _shareTransferPdf() async {
    if (_isSharingPdf) return;

    setState(() => _isSharingPdf = true);
    try {
      final proofUrl = ApiService.resolveAssetUrl(widget.paymentProofImagePath);
      final response = await Dio().get<List<int>>(
        proofUrl,
        options: Options(responseType: ResponseType.bytes),
      );
      final imageBytes = Uint8List.fromList(response.data ?? <int>[]);
      if (!mounted) return;
      final pdfBytes = await _buildTransferPdf(context, imageBytes);

      if (!mounted) return;
      final shareTitle = AppTranslations.getTextStatic(
        context,
        'pdf_share_subject',
      ).replaceAll('{number}', widget.transferNumber);

      await SharePlus.instance.share(
        ShareParams(
          files: [
            XFile.fromData(
              pdfBytes,
              mimeType: 'application/pdf',
              name: _pdfFileName(),
            ),
          ],
          subject: shareTitle,
          title: shareTitle,
        ),
      );
    } catch (_) {
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
    } finally {
      if (mounted) {
        setState(() => _isSharingPdf = false);
      }
    }
  }

  String _pdfFileName() {
    final now = DateTime.now();
    final ts =
        '${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}-'
        '${now.hour.toString().padLeft(2, '0')}${now.minute.toString().padLeft(2, '0')}';
    return 'hawwel-transaction-$ts.pdf';
  }

  Future<Uint8List> _buildTransferPdf(
    BuildContext context,
    Uint8List proofImageBytes,
  ) async {
    final isArabic = context.read<LanguageCubit>().state == Language.arabic;
    final pdfDir = isArabic ? pw.TextDirection.rtl : pw.TextDirection.ltr;

    String tr(String key) => AppTranslations.getTextStatic(context, key);

    String trNum(String key, String number) =>
        tr(key).replaceAll('{number}', number);

    final pdf = pw.Document();
    final arabicFontData = await rootBundle.load('asset/arabic_pdf_font.ttf');
    final arabicFont = pw.Font.ttf(arabicFontData);
    final proofImage = pw.MemoryImage(proofImageBytes);
    const primaryColor = PdfColor.fromInt(0xFF138372);
    const darkColor = PdfColor.fromInt(0xFF263238);
    const mutedColor = PdfColor.fromInt(0xFF6B7280);
    const softBg = PdfColor.fromInt(0xFFF4F7F6);
    const borderColor = PdfColor.fromInt(0xFFE1E7E5);

    final textStyle = pw.TextStyle(
      font: arabicFont,
      fontSize: 11.5,
      color: darkColor,
    );
    final titleStyle = pw.TextStyle(
      font: arabicFont,
      fontSize: 22,
      fontWeight: pw.FontWeight.bold,
      color: PdfColors.white,
    );
    final sectionStyle = pw.TextStyle(
      font: arabicFont,
      fontSize: 13.5,
      fontWeight: pw.FontWeight.bold,
      color: primaryColor,
    );

    pw.Widget infoRow(String label, String value, {bool forceLtr = false}) {
      final labelAlign = isArabic ? pw.TextAlign.right : pw.TextAlign.left;
      final hasArabic = !forceLtr && pdfTextContainsArabicScript(value);
      final displayValue = hasArabic
          ? preparePdfArabicDisplayText(value)
          : value;
      // Shaped Arabic from `bidi` is a visual LTR glyph stream; raw Latin stays logical.
      final valueDirection = forceLtr
          ? pw.TextDirection.ltr
          : (hasArabic ? pw.TextDirection.ltr : pdfDir);
      final valueAlign = forceLtr
          ? pw.TextAlign.left
          : (hasArabic
                ? pw.TextAlign.right
                : (isArabic ? pw.TextAlign.right : pw.TextAlign.left));

      return pw.Container(
        padding: const pw.EdgeInsets.symmetric(vertical: 7, horizontal: 10),
        decoration: const pw.BoxDecoration(
          border: pw.Border(
            bottom: pw.BorderSide(color: borderColor, width: 0.6),
          ),
        ),
        child: pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Expanded(
              child: pw.Text(
                '$label:',
                textAlign: labelAlign,
                style: textStyle.copyWith(
                  color: mutedColor,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
            pw.SizedBox(width: 12),
            pw.Expanded(
              flex: 2,
              child: pw.Directionality(
                textDirection: valueDirection,
                child: pw.Text(
                  displayValue,
                  textAlign: valueAlign,
                  style: textStyle.copyWith(fontWeight: pw.FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      );
    }

    pw.Widget sectionCard(String title, List<pw.Widget> children) {
      return pw.Container(
        margin: const pw.EdgeInsets.only(bottom: 14),
        padding: const pw.EdgeInsets.all(14),
        decoration: pw.BoxDecoration(
          color: PdfColors.white,
          borderRadius: pw.BorderRadius.circular(12),
          border: pw.Border.all(color: borderColor, width: 0.8),
        ),
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.stretch,
          children: [
            pw.Text(
              title,
              style: sectionStyle,
              textAlign: isArabic ? pw.TextAlign.right : pw.TextAlign.left,
            ),
            pw.SizedBox(height: 8),
            pw.Container(
              decoration: pw.BoxDecoration(
                color: softBg,
                borderRadius: pw.BorderRadius.circular(8),
              ),
              child: pw.Column(children: children),
            ),
          ],
        ),
      );
    }

    pw.Widget summaryItem(String label, String value) {
      return pw.Expanded(
        child: pw.Container(
          padding: const pw.EdgeInsets.symmetric(vertical: 10, horizontal: 8),
          decoration: pw.BoxDecoration(
            color: PdfColors.white,
            borderRadius: pw.BorderRadius.circular(10),
          ),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              pw.Text(
                label,
                style: textStyle.copyWith(color: mutedColor, fontSize: 10.5),
                textAlign: pw.TextAlign.center,
              ),
              pw.SizedBox(height: 4),
              pdfTextContainsArabicScript(value)
                  ? pw.Directionality(
                      textDirection: pw.TextDirection.ltr,
                      child: pw.Text(
                        preparePdfArabicDisplayText(value),
                        style: textStyle.copyWith(
                          color: primaryColor,
                          fontSize: 14,
                          fontWeight: pw.FontWeight.bold,
                        ),
                        textAlign: pw.TextAlign.center,
                      ),
                    )
                  : pw.Text(
                      value,
                      style: textStyle.copyWith(
                        color: primaryColor,
                        fontSize: 14,
                        fontWeight: pw.FontWeight.bold,
                      ),
                      textAlign: pw.TextAlign.center,
                    ),
            ],
          ),
        ),
      );
    }

    final noteAlign = isArabic ? pw.TextAlign.right : pw.TextAlign.left;

    final statusLabelRaw = AppTranslations.transferStatusLabel(
      context,
      widget.stat,
    );
    final statusLabelPdf = pdfTextContainsArabicScript(statusLabelRaw)
        ? preparePdfArabicDisplayText(statusLabelRaw)
        : statusLabelRaw;
    final statusArabicShaped = pdfTextContainsArabicScript(statusLabelRaw);
    final paymentMethodHeader =
        pdfTextContainsArabicScript(widget.paymentMethodName)
        ? preparePdfArabicDisplayText(widget.paymentMethodName)
        : widget.paymentMethodName;
    final noteRaw = widget.paymentProofNote.trim();
    final compactNote = noteRaw.length > 180
        ? '${noteRaw.substring(0, 180)}...'
        : noteRaw;

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(22),
        theme: pw.ThemeData.withFont(base: arabicFont, bold: arabicFont),
        build: (_) => pw.Directionality(
          textDirection: pdfDir,
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.stretch,
            children: [
              pw.Container(
                padding: const pw.EdgeInsets.all(14),
                decoration: pw.BoxDecoration(
                  color: primaryColor,
                  borderRadius: pw.BorderRadius.circular(14),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.stretch,
                  children: [
                    pw.Text(
                      tr('pdf_transfer_proof_title'),
                      style: titleStyle.copyWith(fontSize: 18),
                      textAlign: pw.TextAlign.center,
                    ),
                    pw.SizedBox(height: 6),
                    pw.Text(
                      trNum('pdf_transfer_number_line', widget.transferNumber),
                      style: textStyle.copyWith(
                        color: PdfColors.white,
                        fontSize: 10.5,
                      ),
                      textAlign: pw.TextAlign.center,
                    ),
                    pw.SizedBox(height: 8),
                    infoRow(
                      tr('pdf_label_created_at'),
                      widget.createdAt,
                      forceLtr: true,
                    ),
                    infoRow(
                      tr('pdf_label_payment_method'),
                      paymentMethodHeader,
                    ),
                    pw.SizedBox(height: 8),
                    pw.Center(
                      child: pw.Container(
                        padding: const pw.EdgeInsets.symmetric(
                          vertical: 4,
                          horizontal: 12,
                        ),
                        decoration: pw.BoxDecoration(
                          color: PdfColors.white,
                          borderRadius: pw.BorderRadius.circular(20),
                        ),
                        child: statusArabicShaped
                            ? pw.Directionality(
                                textDirection: pw.TextDirection.ltr,
                                child: pw.Text(
                                  statusLabelPdf,
                                  style: textStyle.copyWith(
                                    color: primaryColor,
                                    fontWeight: pw.FontWeight.bold,
                                  ),
                                ),
                              )
                            : pw.Text(
                                statusLabelPdf,
                                style: textStyle.copyWith(
                                  color: primaryColor,
                                  fontWeight: pw.FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
              pw.SizedBox(height: 10),
              pw.Container(
                padding: const pw.EdgeInsets.all(10),
                decoration: pw.BoxDecoration(
                  color: softBg,
                  borderRadius: pw.BorderRadius.circular(12),
                  border: pw.Border.all(color: borderColor, width: 0.8),
                ),
                child: pw.Row(
                  children: [
                    summaryItem(tr('pdf_summary_total'), widget.total),
                    pw.SizedBox(width: 6),
                    summaryItem(
                      tr('pdf_summary_transfer_amount'),
                      widget.transferamount,
                    ),
                    pw.SizedBox(width: 6),
                    summaryItem(tr('pdf_summary_currency'), widget.currency),
                  ],
                ),
              ),
              pw.SizedBox(height: 10),
              sectionCard(tr('pdf_section_recipient_details'), [
                infoRow(tr('pdf_label_receiver_name'), widget.receiverName),
                infoRow(
                  tr('pdf_label_receiver_phone'),
                  widget.receiverPhone,
                  forceLtr: true,
                ),
                infoRow(tr('pdf_label_city'), widget.City),
                infoRow(tr('pdf_label_area'), widget.Area),
              ]),
              if (compactNote.isNotEmpty)
                pw.Container(
                  margin: const pw.EdgeInsets.only(bottom: 10),
                  padding: const pw.EdgeInsets.all(12),
                  decoration: pw.BoxDecoration(
                    color: PdfColors.white,
                    borderRadius: pw.BorderRadius.circular(12),
                    border: pw.Border.all(color: borderColor, width: 0.8),
                  ),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.stretch,
                    children: [
                      pw.Text(
                        tr('pdf_admin_note_heading'),
                        style: sectionStyle,
                        textAlign: noteAlign,
                      ),
                      pw.SizedBox(height: 6),
                      pdfTextContainsArabicScript(compactNote)
                          ? pw.Directionality(
                              textDirection: pw.TextDirection.ltr,
                              child: pw.Text(
                                preparePdfArabicDisplayText(compactNote),
                                style: textStyle.copyWith(fontSize: 10.5),
                                textAlign: pw.TextAlign.right,
                              ),
                            )
                          : pw.Text(
                              compactNote,
                              style: textStyle.copyWith(fontSize: 10.5),
                              textAlign: noteAlign,
                            ),
                    ],
                  ),
                ),
              pw.Container(
                padding: const pw.EdgeInsets.all(10),
                decoration: pw.BoxDecoration(
                  color: PdfColors.white,
                  borderRadius: pw.BorderRadius.circular(12),
                  border: pw.Border.all(color: borderColor, width: 0.8),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.stretch,
                  children: [
                    pw.Text(
                      tr('transfer_proof_photo'),
                      style: sectionStyle,
                      textAlign: noteAlign,
                    ),
                    pw.SizedBox(height: 6),
                    pw.Center(
                      child: pw.Container(
                        padding: const pw.EdgeInsets.all(6),
                        decoration: pw.BoxDecoration(
                          color: softBg,
                          borderRadius: pw.BorderRadius.circular(10),
                          border: pw.Border.all(color: borderColor, width: 0.8),
                        ),
                        constraints: const pw.BoxConstraints(maxHeight: 185),
                        child: pw.Image(proofImage, fit: pw.BoxFit.contain),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );

    return pdf.save();
  }

  // â”€â”€ Status color â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  Color _statusColor(dynamic branding) {
    switch (widget.stat.trim().toLowerCase()) {
      case 'full-paid':
      case 'compleated':
      case 'completed':
      case 'received':
      case 'is-received':
      case 'is_received':
        return branding.success;
      case 'partial-paid':
      case 'under-paid':
        return const Color(0xFF2563EB);
      case 'preparing-address':
      case 'preparing_address':
      case 'address-preparing':
      case 'pending':
      case 'can-receive':
      case 'can_receive':
      case 'ready-to-receive':
      case 'ready_to_receive':
        return const Color(0xFFF59E0B);
      case 'rejected':
      case 'cancelled':
        return branding.error;
      default:
        return const Color(0xFFF59E0B);
    }
  }

  IconData _statusIcon() {
    switch (widget.stat.trim().toLowerCase()) {
      case 'full-paid':
      case 'compleated':
      case 'completed':
      case 'received':
      case 'is-received':
      case 'is_received':
        return Icons.check_circle_rounded;
      case 'partial-paid':
      case 'under-paid':
        return Icons.pause_circle_rounded;
      case 'preparing-address':
      case 'preparing_address':
      case 'address-preparing':
        return Icons.location_on_outlined;
      case 'can-receive':
      case 'can_receive':
      case 'ready-to-receive':
      case 'ready_to_receive':
        return Icons.store_mall_directory_outlined;
      case 'rejected':
      case 'cancelled':
        return Icons.cancel_rounded;
      default:
        return Icons.hourglass_top_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final branding = appBrandingNotifier.value;
    final bool isArabic =
        context.watch<LanguageCubit>().state == Language.arabic;
    final statusColor = _statusColor(branding);

    // â”€â”€ helper: info row â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
    // Label Ø¹Ù„Ù‰ Ø§Ù„ÙŠØ³Ø§Ø± (start) Ø«Ù… Ø§Ù„Ù†Ù‚Ø·ØªØ§Ù†ØŒ Ø§Ù„Ù‚ÙŠÙ…Ø© Ø¹Ù„Ù‰ Ø§Ù„ÙŠÙ…ÙŠÙ† (end)
    Widget infoRow(String label, String value, {bool ltr = false}) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 11.h),
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
        margin: EdgeInsets.only(bottom: 14.h),
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
              padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 10.h),
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
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                children: rows.expand((w) => [w, divider()]).toList()
                  ..removeLast(),
              ),
            ),
            SizedBox(height: 4.h),
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
                  bottomLeft: Radius.circular(32.r),
                  bottomRight: Radius.circular(32.r),
                ),
              ),
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 28.h),
                  child: Column(
                    children: [
                      // Back button row
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Container(
                              width: 38.r,
                              height: 38.r,
                              decoration: BoxDecoration(
                                color: branding.buttonText.withValues(
                                  alpha: 0.18,
                                ),
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              child: Icon(
                                isArabic
                                    ? Icons.arrow_forward_ios_rounded
                                    : Icons.arrow_back_ios_new_rounded,
                                color: branding.buttonText,
                                size: 18,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              AppTranslations.getText(
                                context,
                                'transaction_details',
                              ),
                              textAlign: TextAlign.center,
                              style: GoogleFonts.cairo(
                                fontSize: 17.sp,
                                fontWeight: FontWeight.w700,
                                color: branding.buttonText,
                              ),
                            ),
                          ),
                          SizedBox(width: 38.r),
                        ],
                      ),

                      SizedBox(height: 20.h),

                      // Amount + currency icon
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            widget.currency == 'USDC'
                                ? AppImages.usdc
                                : AppImages.usdt,
                            height: 28.r,
                            width: 28.r,
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            '${widget.amount.toStringAsFixed(2)} ${widget.currency}',
                            style: GoogleFonts.cairo(
                              fontSize: 26.sp,
                              fontWeight: FontWeight.bold,
                              color: branding.buttonText,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 12.h),

                      // Status badge
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 6.h,
                        ),
                        decoration: BoxDecoration(
                          color: branding.buttonText.withValues(alpha: 0.18),
                          borderRadius: BorderRadius.circular(50.r),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(_statusIcon(), color: statusColor, size: 16),
                            SizedBox(width: 6.w),
                            Text(
                              AppTranslations.transferStatusLabel(
                                context,
                                widget.stat,
                              ),
                              style: GoogleFonts.cairo(
                                fontSize: 13.sp,
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
                padding: EdgeInsets.fromLTRB(16.w, 20.h, 16.w, 30.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
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

                    SizedBox(height: 16.h),

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

                    // â”€â”€ Payment proof â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
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
                                16.w,
                                14.h,
                                16.w,
                                10.h,
                              ),
                              child: Text(
                                AppTranslations.getText(
                                  context,
                                  'transfer_admin_note',
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
                                padding: EdgeInsets.all(14.r),
                                child: Container(
                                  padding: EdgeInsets.all(12.r),
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
                                  14.w,
                                  widget.paymentProofNote.isEmpty ? 14.h : 0,
                                  14.w,
                                  14.h,
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12.r),
                                  child: Image.network(
                                    ApiService.resolveAssetUrl(
                                      widget.paymentProofImagePath,
                                    ),
                                    fit: BoxFit.contain,
                                    loadingBuilder: (context, child, progress) {
                                      if (progress == null) return child;
                                      return Padding(
                                        padding: EdgeInsets.all(24.r),
                                        child: Center(
                                          child: CircularProgressIndicator(
                                            color: branding.badge,
                                          ),
                                        ),
                                      );
                                    },
                                    errorBuilder: (_, __, ___) => Text(
                                      AppTranslations.getText(
                                        context,
                                        'image_load_error',
                                      ),
                                      style: GoogleFonts.cairo(
                                        color: branding.iconPrimary,
                                        fontSize: 14.sp,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      SizedBox(height: 14.h),
                    ],

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
                          final isLoading = state is ReceiversLoading;
                          return Row(
                            children: [
                              // Save receiver button
                              Expanded(
                                child: GestureDetector(
                                  onTap: isLoading
                                      ? null
                                      : () {
                                          context
                                                  .read<ReceiversCubit>()
                                                  .fullNameController
                                                  .text =
                                              widget.receiverName;
                                          context
                                                  .read<ReceiversCubit>()
                                                  .mobilePhoneController
                                                  .text =
                                              widget.senderPhone;
                                          context
                                              .read<ReceiversCubit>()
                                              .addReceiver();
                                        },
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
                                                  Icons.bookmark_add_rounded,
                                                  color: branding.buttonText,
                                                  size: 18,
                                                ),
                                                SizedBox(width: 6.w),
                                                Text(
                                                  AppTranslations.getText(
                                                    context,
                                                    'Saving information',
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
                              if (_hasPaymentProofDetails) ...[
                                SizedBox(width: 10.w),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: _isSharingPdf
                                        ? null
                                        : _shareTransferPdf,
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
