import 'package:flutter/material.dart';
import '../utils/utils.dart';

class DateHoursPainter extends CustomPainter {
  DateHoursPainter({
    @required this.textStyle,
    @required this.textDirection,
  })  : assert(textStyle != null),
        assert(textDirection != null),
        _painters = [
          for (final h in innerDateHours)
            TextPainter(
              text: TextSpan(
                text: '$h:00',
                style: textStyle,
              ),
              textDirection: textDirection,
              textAlign: TextAlign.right,
            ),
        ];

  final TextStyle textStyle;
  final TextDirection textDirection;
  final List<TextPainter> _painters;

  double _lastWidth;

  @override
  void paint(Canvas canvas, Size size) {
    if (size.width != _lastWidth) {
      for (final painter in _painters) {
        painter.layout(minWidth: size.width, maxWidth: size.width);
      }
      _lastWidth = size.width;
    }

    final hourHeight = size.height / 24;
    for (final h in innerDateHours) {
      final painter = _painters[h - 1];
      final y = h * hourHeight - painter.height / 2;
      painter.paint(canvas, Offset(0, y));
    }
  }

  @override
  bool shouldRepaint(DateHoursPainter oldDelegate) => textStyle != oldDelegate.textStyle || textDirection != oldDelegate.textDirection;
}
