import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hawwel/constans/widgets/in_tree_capture.dart';
import 'package:hawwel/featue/transaction_historu/widjt/transfer_receipt_pdf.dart';

// Exercises the in-tree capture path (Overlay + RepaintBoundary) and the
// image-to-PDF wrapper end to end; set RECEIPT_PDF_OUT to keep the file.
void main() {
  testWidgets('captures an in-tree widget and wraps it as a PDF page',
      (tester) async {
    late BuildContext hostContext;
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) {
            hostContext = context;
            return const Scaffold(body: Center(child: Text('host')));
          },
        ),
      ),
    );

    final bytes = await tester.runAsync(() async {
      final capture = captureWidgetPng(
        hostContext,
        Container(
          color: const Color(0xFFF8FAF9),
          padding: const EdgeInsets.all(24),
          child: const Text('sample notice', textDirection: TextDirection.rtl),
        ),
        width: 400,
        pixelRatio: 1.5,
      );
      // The test binding only produces frames when pumped, so drive the
      // frames the capture waits for.
      var done = false;
      capture.whenComplete(() => done = true);
      for (var i = 0; i < 40 && !done; i++) {
        await tester.pump(const Duration(milliseconds: 50));
        await Future<void>.delayed(const Duration(milliseconds: 20));
      }
      final png = await capture;
      expect(png.length, greaterThan(100));
      final decoded = await decodeImageFromList(png);
      expect(decoded.width, 600); // 400 * 1.5
      return wrapNoticeImageAsPdf(
        png,
        pixelWidth: decoded.width,
        pixelHeight: decoded.height,
        pixelRatio: 1.5,
      );
    });

    expect(bytes, isNotNull);
    expect(bytes!.length, greaterThan(500));
    final out = Platform.environment['RECEIPT_PDF_OUT'];
    if (out != null && out.isNotEmpty) File(out).writeAsBytesSync(bytes);
  });
}
