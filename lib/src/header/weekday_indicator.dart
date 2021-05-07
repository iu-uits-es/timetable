import 'package:black_hole_flutter/black_hole_flutter.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../theme.dart';
import '../utils/utils.dart';
import 'date_indicator.dart';

class WeekdayIndicator extends StatelessWidget {
  const WeekdayIndicator(this.date, {Key key}) : super(key: key);

  final DateTime date;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final timetableTheme = context.timetableTheme;

    final states = DateIndicator.statesFor(date);
    final DateFormat pattern = timetableTheme?.weekDayIndicatorPattern?.resolve(states) ?? DateFormat('EEE');
    final decoration = timetableTheme?.weekDayIndicatorDecoration?.resolve(states) ?? BoxDecoration();
    final textStyle = timetableTheme?.weekDayIndicatorTextStyle?.resolve(states) ??
        TextStyle(
          color: date.isToday ? timetableTheme?.primaryColor ?? theme.primaryColor : theme.highEmphasisOnBackground,
        );

    return DecoratedBox(
      decoration: decoration,
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Text(pattern.format(date), style: textStyle),
      ),
    );
  }
}
