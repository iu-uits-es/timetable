import 'package:flutter/material.dart';

import '../controller.dart';
import '../event.dart';
import '../theme.dart';
import '../timetable.dart';
import 'all_day_events.dart';
import 'multi_date_header.dart';

class TimetableHeader<E extends Event> extends StatelessWidget {
  const TimetableHeader({
    Key key,
    @required this.controller,
    @required this.allDayEventBuilder,
    this.onEventBackgroundTap,
    this.leadingHeaderBuilder,
    this.dateHeaderBuilder,
  })  : assert(controller != null),
        assert(allDayEventBuilder != null),
        super(key: key);

  final TimetableController<E> controller;
  final AllDayEventBuilder<E> allDayEventBuilder;
  final OnEventBackgroundTapCallback onEventBackgroundTap;
  final HeaderWidgetBuilder leadingHeaderBuilder;
  final HeaderWidgetBuilder dateHeaderBuilder;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        SizedBox(
          width: hourColumnWidth,
          child: ValueListenableBuilder<DateTime>(
            valueListenable: controller.dateListenable,
            builder: (context, date, _) {
              final customHeader = leadingHeaderBuilder?.call(context, date);
              return customHeader ?? Container();
            },
          ),
        ),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(
                height: context.timetableTheme?.totalDateIndicatorHeight ?? 72,
                child: MultiDateHeader(
                  controller: controller,
                  builder: dateHeaderBuilder,
                ),
              ),
              AllDayEvents<E>(
                controller: controller,
                onEventBackgroundTap: onEventBackgroundTap,
                allDayEventBuilder: allDayEventBuilder,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
