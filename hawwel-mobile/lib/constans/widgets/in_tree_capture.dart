import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

/// Rasterizes [child] by mounting it off-screen in the app's root Overlay
/// and snapshotting its RepaintBoundary. Unlike capturing a detached widget
/// tree, the child lives in the real tree (MediaQuery, Directionality,
/// fonts already loaded, image cache) - the detached approach crashed the
/// app on some Android devices.
Future<Uint8List> captureWidgetPng(
  BuildContext context,
  Widget child, {
  required double width,
  double pixelRatio = 1.5,
}) async {
  final overlay = Overlay.of(context, rootOverlay: true);
  final boundaryKey = GlobalKey();
  final entry = OverlayEntry(
    builder: (_) => Positioned(
      // Parked far outside the viewport; Stack children are still laid out
      // and painted there, which is all toImage() needs.
      left: -width * 4,
      top: 0,
      child: IgnorePointer(
        child: Material(
          color: Colors.transparent,
          child: RepaintBoundary(
            key: boundaryKey,
            child: SizedBox(width: width, child: child),
          ),
        ),
      ),
    ),
  );

  overlay.insert(entry);
  try {
    // Two frames: one to lay out, one for text/images to settle. Frames are
    // requested explicitly so this never waits on a frame nobody scheduled.
    WidgetsBinding.instance.scheduleFrame();
    await WidgetsBinding.instance.endOfFrame;
    await Future<void>.delayed(const Duration(milliseconds: 150));
    WidgetsBinding.instance.scheduleFrame();
    await WidgetsBinding.instance.endOfFrame;

    final renderObject = boundaryKey.currentContext?.findRenderObject();
    if (renderObject is! RenderRepaintBoundary) {
      throw StateError('capture boundary was not mounted');
    }
    final image = await renderObject.toImage(pixelRatio: pixelRatio);
    try {
      final data = await image.toByteData(format: ui.ImageByteFormat.png);
      if (data == null) throw StateError('png encoding failed');
      return data.buffer.asUint8List();
    } finally {
      image.dispose();
    }
  } finally {
    entry.remove();
  }
}
