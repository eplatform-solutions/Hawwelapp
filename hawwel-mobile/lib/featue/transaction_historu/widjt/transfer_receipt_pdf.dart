import 'dart:typed_data';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

/// Wraps an already-rendered notice image in a single-page PDF whose page
/// is sized to the image, so the shared file keeps the notice's own design
/// pixel for pixel.
Future<Uint8List> wrapNoticeImageAsPdf(
  Uint8List png, {
  required int pixelWidth,
  required int pixelHeight,
  required double pixelRatio,
  String title = 'Hawwel transfer notice',
}) async {
  final pageWidth = pixelWidth / pixelRatio;
  final pageHeight = pixelHeight / pixelRatio;
  final doc = pw.Document(title: title, author: 'Hawwel');
  final image = pw.MemoryImage(png);
  doc.addPage(
    pw.Page(
      pageFormat: PdfPageFormat(pageWidth, pageHeight, marginAll: 0),
      build: (_) => pw.Image(image, fit: pw.BoxFit.fill),
    ),
  );
  return doc.save();
}
