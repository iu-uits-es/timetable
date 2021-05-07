import 'dart:ui';

import 'package:flutter/material.dart';

import '../controller.dart';
import '../event.dart';
import '../utils/utils.dart';

class CurrentTimeIndicatorPainter<E extends Event> extends CustomPainter {
  CurrentTimeIndicatorPainter({
    @required this.controller,
    @required Color color,
    this.circleRadius = 4,
    Listenable repaint,
  })  : assert(controller != null),
        assert(color != null),
        _paint = Paint()..color = color,
        assert(circleRadius != null),
        super(
          repaint: Listenable.merge([
            controller.scrollControllers.pageListenable,
            repaint,
          ]),
        );

  final TimetableController<E> controller;
  final Paint _paint;
  final double circleRadius;

  @override
  void paint(Canvas canvas, Size size) {
    final dateWidth = size.width / controller.visibleRange.visibleDays;

    final temporalOffset = DateTime.now().atMidnight().epochDay - controller.scrollControllers.page;
    final left = temporalOffset * dateWidth;
    final right = left + dateWidth;

    if (right < 0 || left > size.width) {
      // The current date isn't visible so we don't have to paint anything.
      return;
    }

    final actualLeft = left < 0 ? 0.0 : left;
    final actualRight = right > size.width ? size.width : right;

    final time = TimeOfDay.now().sinceMidnight.inSeconds;
    final y = (time / Duration.secondsPerDay) * size.height;

    final radius = lerpDouble(circleRadius, 0, dateWidth != 0 ? (actualLeft - left) / dateWidth : 0);
    canvas
      ..drawCircle(Offset(actualLeft, y), radius, _paint)
      ..drawLine(Offset(actualLeft + radius, y), Offset(actualRight, y), _paint);
  }

  @override
  bool shouldRepaint(CurrentTimeIndicatorPainter oldDelegate) => //
      _paint.color != oldDelegate._paint.color || //
      circleRadius != oldDelegate.circleRadius;
}
