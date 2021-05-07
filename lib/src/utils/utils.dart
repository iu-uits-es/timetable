import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

extension DateTimeToday on DateTime {
  static final _startOfEpoch = DateTime(1970);
  static DateTime today() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  bool get isToday {
    final now = DateTime.now();
    return now.year == year && now.month == month && now.day == day;
  }

  static DateTime fromEpochDay(int days) => _startOfEpoch.add(Duration(days: days));
  int get epochDay => difference(_startOfEpoch).inDays;
  DateTime atMidnight() => DateTime(year, month, day);
  // DateTime operator +(Duration duration) => add(duration);

  DateTime at(TimeOfDay time) => DateTime(year, month, day, time.hour, time.minute);

  Duration get timeSinceMidnight => difference(atMidnight());
}

extension DurationExtension on Duration {
  static Duration between(DateTime start, DateTime end) => start.difference(end);
}

extension TimeOfDayExtensions on TimeOfDay {
  Duration get sinceMidnight => Duration(hours: hour, minutes: minute);

  bool operator >(TimeOfDay time) {
    if (time.hour == hour) return minute > time.minute;
    return hour > time.hour;
  }

  bool operator <(TimeOfDay time) {
    if (time.hour == hour) return minute < time.minute;
    return hour < time.hour;
  }
}

final List<int> innerDateHours = List.generate(Duration.hoursPerDay - 1, (i) => i + 1);

typedef Mapper<T, R> = R Function(T data);

extension MapListenable<T> on ValueListenable<T> {
  ValueNotifier<R> map<R>(Mapper<T, R> mapper) => _MapValueListenable(this, mapper);
}

class _MapValueListenable<T, R> extends ValueNotifier<R> {
  _MapValueListenable(this.listenable, this.mapper)
      : assert(listenable != null),
        assert(mapper != null),
        super(mapper(listenable.value)) {
    listenable.addListener(_listener);
  }

  final ValueListenable<T> listenable;
  final Mapper<T, R> mapper;

  @override
  void dispose() {
    listenable.removeListener(_listener);
    super.dispose();
  }

  void _listener() {
    value = mapper(listenable.value);
  }
}
