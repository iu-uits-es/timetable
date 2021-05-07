import 'dart:ui';

import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'basic.dart';

/// The base class of all events.
///
/// See also:
/// - [BasicEvent], which provides a basic implementation to get you started.
abstract class Event {
  const Event({
    @required this.id,
    @required this.start,
    @required this.end,
  })  : assert(id != null),
        assert(start != null),
        assert(end != null),
        assert(start <= end);

  /// A unique ID, used e.g. for animating events.
  final Object id;

  /// Start of the event.
  final DateTime start;

  // End of the event; exclusive.
  final DateTime end;

  bool get isAllDay => start.difference(end).inDays >= 1;
  bool get isPartDay => !isAllDay;

  @override
  bool operator ==(dynamic other) {
    return runtimeType == other.runtimeType && id == other.id && start == other.start && end == other.end;
  }

  @override
  int get hashCode => hashList([runtimeType, id, start, end]);

  @override
  String toString() => id.toString();
}

extension TimetableEvent on Event {
  bool intersectsDate(DateTime date) => date.between(start, end);

  bool intersectsInterval(DateTimeRange interval) {
    return start <= interval.end && endDateInclusive >= interval.start;
  }

  DateTime get endDateInclusive {
    if (start == end) {
      return end;
    }

    return end - Duration(microseconds: 1);
  }

  DateTimeRange get intersectingDates => DateTimeRange(start: start, end: endDateInclusive);
}

extension TimetableEventIterable<E extends Event> on Iterable<E> {
  Iterable<E> get allDayEvents => where((e) => e.isAllDay);
  Iterable<E> get partDayEvents => where((e) => e.isPartDay);

  Iterable<E> intersectingInterval(DateTimeRange interval) => where((e) => e.intersectsInterval(interval));
  Iterable<E> intersectingDate(DateTime date) => where((e) => e.intersectsDate(date));

  List<E> sortedByStartLength() => sortedBy((e) => e.start).thenByDescending((e) => e.end);
}
