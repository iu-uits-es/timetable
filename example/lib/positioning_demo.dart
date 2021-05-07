import 'dart:math';

import 'package:flutter/material.dart';
import 'package:timetable/timetable.dart';
import 'package:black_hole_flutter/black_hole_flutter.dart';

final EventProvider<BasicEvent> positioningDemoEventProvider =
    EventProvider.list(_events);

final _events = <BasicEvent>[
  _DemoEvent(0, 0, TimeOfDay(hour:10, minute:0), TimeOfDay(hour:11, minute:0)),
  _DemoEvent(0, 1, TimeOfDay(hour:11, minute:0), TimeOfDay(hour:12, minute:0)),
  _DemoEvent(0, 2, TimeOfDay(hour:12, minute:0), TimeOfDay(hour:13, minute:0)),
  _DemoEvent(1, 0, TimeOfDay(hour:10, minute:0), TimeOfDay(hour:12, minute:0)),
  _DemoEvent(1, 1, TimeOfDay(hour:10, minute:0), TimeOfDay(hour:12, minute:0)),
  _DemoEvent(1, 2, TimeOfDay(hour:14, minute:0), TimeOfDay(hour:16, minute:0)),
  _DemoEvent(1, 3, TimeOfDay(hour:14, minute:15), TimeOfDay(hour:16, minute:0)),
  _DemoEvent(2, 0, TimeOfDay(hour:10, minute:0), TimeOfDay(hour:20, minute:0)),
  _DemoEvent(2, 1, TimeOfDay(hour:10, minute:0), TimeOfDay(hour:12, minute:0)),
  _DemoEvent(2, 2, TimeOfDay(hour:13, minute:0), TimeOfDay(hour:15, minute:0)),
  _DemoEvent(3, 0, TimeOfDay(hour:10, minute:0), TimeOfDay(hour:20, minute:0)),
  _DemoEvent(3, 1, TimeOfDay(hour:12, minute:0), TimeOfDay(hour:14, minute:0)),
  _DemoEvent(3, 2, TimeOfDay(hour:12, minute:0), TimeOfDay(hour:15, minute:0)),
  _DemoEvent(4, 0, TimeOfDay(hour:10, minute:0), TimeOfDay(hour:13, minute:0)),
  _DemoEvent(4, 1, TimeOfDay(hour:10, minute:15), TimeOfDay(hour:13, minute:0)),
  _DemoEvent(4, 2, TimeOfDay(hour:10, minute:30), TimeOfDay(hour:13, minute:0)),
  _DemoEvent(4, 3, TimeOfDay(hour:10, minute:45), TimeOfDay(hour:13, minute:0)),
  _DemoEvent(4, 4, TimeOfDay(hour:11, minute:0), TimeOfDay(hour:13, minute:0)),
  _DemoEvent(5, 0, TimeOfDay(hour:10, minute:30), TimeOfDay(hour:13, minute:30)),
  _DemoEvent(5, 1, TimeOfDay(hour:10, minute:30), TimeOfDay(hour:13, minute:30)),
  _DemoEvent(5, 2, TimeOfDay(hour:10, minute:30), TimeOfDay(hour:12, minute:30)),
  _DemoEvent(5, 3, TimeOfDay(hour:8, minute:30), TimeOfDay(hour:18, minute:0)),
  _DemoEvent(5, 4, TimeOfDay(hour:15, minute:30), TimeOfDay(hour:16, minute:0)),
  _DemoEvent(5, 5, TimeOfDay(hour:11, minute:0), TimeOfDay(hour:12, minute:0)),
  _DemoEvent(5, 6, TimeOfDay(hour:1, minute:0), TimeOfDay(hour:2, minute:0)),
  _DemoEvent(6, 0, TimeOfDay(hour:9, minute:30), TimeOfDay(hour:15, minute:30)),
  _DemoEvent(6, 1, TimeOfDay(hour:11, minute:0), TimeOfDay(hour:13, minute:0)),
  _DemoEvent(6, 2, TimeOfDay(hour:9, minute:30), TimeOfDay(hour:11, minute:30)),
  _DemoEvent(6, 3, TimeOfDay(hour:9, minute:30), TimeOfDay(hour:10, minute:30)),
  _DemoEvent(6, 4, TimeOfDay(hour:10, minute:0), TimeOfDay(hour:11, minute:0)),
  _DemoEvent(6, 5, TimeOfDay(hour:10, minute:0), TimeOfDay(hour:11, minute:0)),
  _DemoEvent(6, 6, TimeOfDay(hour:9, minute:30), TimeOfDay(hour:10, minute:30)),
  _DemoEvent(6, 7, TimeOfDay(hour:9, minute:30), TimeOfDay(hour:10, minute:30)),
  _DemoEvent(6, 8, TimeOfDay(hour:9, minute:30), TimeOfDay(hour:10, minute:30)),
  _DemoEvent(6, 9, TimeOfDay(hour:10, minute:30), TimeOfDay(hour:12, minute:30)),
  _DemoEvent(6, 10, TimeOfDay(hour:12, minute:0), TimeOfDay(hour:13, minute:0)),
  _DemoEvent(6, 11, TimeOfDay(hour:12, minute:0), TimeOfDay(hour:13, minute:0)),
  _DemoEvent(6, 12, TimeOfDay(hour:12, minute:0), TimeOfDay(hour:13, minute:0)),
  _DemoEvent(6, 13, TimeOfDay(hour:12, minute:0), TimeOfDay(hour:13, minute:0)),
  _DemoEvent(6, 14, TimeOfDay(hour:6, minute:30), TimeOfDay(hour:8, minute:0)),
  _DemoEvent(7, 0, TimeOfDay(hour:2, minute:30), TimeOfDay(hour:4, minute:30)),
  _DemoEvent(7, 1, TimeOfDay(hour:2, minute:30), TimeOfDay(hour:3, minute:30)),
  _DemoEvent(7, 2, TimeOfDay(hour:3, minute:0), TimeOfDay(hour:4, minute:0)),
  _DemoEvent(8, 0, TimeOfDay(hour:20, minute:0), TimeOfDay(hour:4, minute:0), endDateOffset: 1),
  _DemoEvent(9, 1, TimeOfDay(hour:12, minute:0), TimeOfDay(hour:16, minute:0)),
  _DemoEvent(9, 2, TimeOfDay(hour:12, minute:0), TimeOfDay(hour:13, minute:0)),
  _DemoEvent(9, 3, TimeOfDay(hour:12, minute:0), TimeOfDay(hour:13, minute:0)),
  _DemoEvent(9, 4, TimeOfDay(hour:12, minute:0), TimeOfDay(hour:13, minute:0)),
  _DemoEvent(9, 5, TimeOfDay(hour:15, minute:0), TimeOfDay(hour:16, minute:0)),
  _DemoEvent.allDay(0, 0, 1),
  _DemoEvent.allDay(1, 1, 1),
  _DemoEvent.allDay(2, 0, 2),
  _DemoEvent.allDay(3, 2, 2),
  _DemoEvent.allDay(4, 2, 2),
  _DemoEvent.allDay(5, 1, 2),
  _DemoEvent.allDay(6, 3, 2),
  _DemoEvent.allDay(7, 4, 4),
  _DemoEvent.allDay(8, -1, 2),
  _DemoEvent.allDay(9, -2, 2),
  _DemoEvent.allDay(10, -3, 2),
];

class _DemoEvent extends BasicEvent {
  _DemoEvent(
    int demoId,
    int eventId,
    TimeOfDay start,
    TimeOfDay end, {
    int endDateOffset = 0,
  }) : super(
          id: '$demoId-$eventId',
          title: '$demoId-$eventId',
          color: _getColor('$demoId-$eventId'),
          start: DateTime.now().atMidnight().add(Duration(days:demoId)).at(start),
          end: DateTime.now().atMidnight().add(Duration(days:demoId + endDateOffset)).at(end),
        );

  _DemoEvent.allDay(int id, int startOffset, int length)
      : super(
          id: 'a-$id',
          title: 'a-$id',
          color: _getColor('a-$id'),
          start: DateTime.now().atMidnight().add(Duration(days:startOffset)).atMidnight(),
          end: DateTime.now().atMidnight().add(Duration(days:startOffset + length)).atMidnight(),
        );

  static Color _getColor(String id) {
    return Random(id.hashCode)
        .nextColorHsv(
          saturation: 0.7,
          value: 0.8,
          alpha: 1,
        )
        .toColor();
  }
}
