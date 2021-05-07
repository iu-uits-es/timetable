import 'package:black_hole_flutter/black_hole_flutter.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../theme.dart';
import '../utils/utils.dart';

class DateIndicator extends StatelessWidget {
  const DateIndicator(this.date, {Key key}) : super(key: key);

  final DateTime date;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final timetableTheme = context.timetableTheme;

    final states = statesFor(date);
    final pattern = timetableTheme?.dateIndicatorPattern?.resolve(states) ?? DateFormat('d');
    final primaryColor = timetableTheme?.primaryColor ?? theme.primaryColor;
    final decoration = timetableTheme?.dateIndicatorDecoration?.resolve(states) ??
        BoxDecoration(
          shape: BoxShape.circle,
          color: date.isToday ? primaryColor : Colors.transparent,
        );
    final textStyle = timetableTheme?.dateIndicatorTextStyle?.resolve(states) ??
        TextStyle(
          color: date.isToday ? primaryColor.highEmphasisOnColor : theme.highEmphasisOnBackground,
        );

    return DecoratedBox(
      decoration: decoration,
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Text(pattern.format(date), style: textStyle),
      ),
    );
  }

  static Set<MaterialState> statesFor(DateTime date) {
    return {
      if (date.isBefore(DateTime.now().atMidnight())) MaterialState.disabled,
      if (date.isToday) MaterialState.selected,
    };
  }
}
