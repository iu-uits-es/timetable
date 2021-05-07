import 'package:flutter/material.dart';
import 'package:test/test.dart';
// import 'package:time_machine/time_machine.dart';
import 'package:dartx/dartx.dart';
import 'package:timetable/src/event.dart';
import 'package:timetable/src/utils/utils.dart';

void main() {
  group('TimetableEvent', () {
    final startDate = DateTime(2020, 1, 1);
    final start = startDate.atMidnight();
    final day = Duration(days: 1);

    final events = [
      _TestEvent(start, start),
      _TestEvent(start, start + day),
      _TestEvent(start, start + Duration(days: 2)),
      _TestEvent(start.add(Duration(hours: 10)), start.add(Duration(hours: 12))),
      _TestEvent(
        start + Duration(hours: 10),
        start + Duration(days: 1, hours: 12),
      ),
      _TestEvent(
        start + Duration(hours: 10),
        start + Duration(days: 2, hours: 12),
      ),
    ];

    test('intersectsInterval', () {
      final intervals = [
        {
          DateTimeRange(start: (startDate - day), end: (startDate - day)): false,
          DateTimeRange(start: startDate, end: (startDate)): true,
          DateTimeRange(start: startDate, end: (startDate + day)): true,
          DateTimeRange(start: (startDate + day), end: (startDate + day)): false,
        },
        {
          DateTimeRange(start: (startDate - day), end: (startDate - day)): false,
          DateTimeRange(start: startDate, end: (startDate)): true,
          DateTimeRange(start: startDate, end: (startDate + day)): true,
          DateTimeRange(start: (startDate + day), end: (startDate + day)): false,
        },
        {
          DateTimeRange(start: (startDate - day), end: (startDate - day)): false,
          DateTimeRange(start: startDate, end: (startDate)): true,
          DateTimeRange(start: startDate, end: (startDate + day)): true,
          DateTimeRange(start: (startDate + day), end: (startDate + day)): true,
        },
        {
          DateTimeRange(start: (startDate - day), end: (startDate - day)): false,
          DateTimeRange(start: startDate, end: (startDate)): true,
          DateTimeRange(start: startDate, end: (startDate + day)): true,
          DateTimeRange(start: (startDate + day), end: (startDate + day)): false,
        },
        {
          DateTimeRange(start: (startDate - day), end: (startDate - day)): false,
          DateTimeRange(start: startDate, end: (startDate)): true,
          DateTimeRange(start: startDate, end: (startDate + day)): true,
          DateTimeRange(start: (startDate + day), end: (startDate + day)): true,
        },
        {
          DateTimeRange(start: (startDate - day), end: (startDate - day)): false,
          DateTimeRange(start: startDate, end: (startDate)): true,
          DateTimeRange(start: startDate, end: (startDate + day)): true,
          DateTimeRange(start: (startDate + day), end: (startDate + day)): true,
        },
      ];

      for (final index in events.indices) {
        final event = events[index];
        final ints = intervals[index];
        expect(
          ints.keys.map(event.intersectsInterval),
          ints.values,
          reason: 'index: $index',
        );
      }
    });

    test('endDateInclusive', () {
      expect(events.map((e) => e.endDateInclusive), [
        startDate,
        startDate,
        startDate + day,
        startDate,
        startDate + day,
        startDate + Duration(days: 2),
      ]);
    });

    test('intersectingDates', () {
      expect(events.map((e) => e.intersectingDates), [
        startDate.difference(startDate),
        startDate.difference(startDate),
        startDate.difference(startDate + day),
        startDate.difference(startDate),
        startDate.difference(startDate + day),
        startDate.difference(startDate + Duration(days: 2)),
      ]);
    });
  });
}

class _TestEvent extends Event {
  const _TestEvent(
    DateTime start,
    DateTime end,
  ) : super(id: '', start: start, end: end);
}
