import 'package:dartx/dartx.dart';
import 'package:test/test.dart';
import 'package:timetable/src/visible_range.dart';
import 'package:timetable/src/utils/utils.dart';

void main() {
  VisibleRange visibleRange;

  group('VisibleRange.days', () {
    setUp(() => visibleRange = VisibleRange.days(3));

    test('getTargetPageForFocus', () {
      // Monday of week 2020-01
      final startDate = DateTime(2019, 12, 30);

      expect(
        0.rangeTo(2).map((offset) {
          return visibleRange.getTargetPageForFocusDate(
            startDate + Duration(days: offset),
            DateTime.monday,
          );
        }),
        equals(0.rangeTo(2).map((offset) => startDate.epochDay + offset)),
      );
    });

    test('getTargetPageForCurrent', () {
      // Monday of week 2020-01
      final startPage = DateTime(2019, 12, 30).epochDay.toDouble();

      final values = {
        startPage: startPage,
        startPage - 0.4: startPage,
        startPage + 0.4: startPage,
        startPage + 1: startPage + 1,
      };
      expect(
        values.keys.map((current) => visibleRange.getTargetPageForCurrent(current, DateTime.monday)),
        equals(values.values),
      );
    });
  });

  group('VisibleRange.week', () {
    setUp(() => visibleRange = VisibleRange.week());

    group('getTargetPageForFocus', () {
      DateTime getTargetDate(DateTime focusDate) {
        final targetPage = visibleRange.getTargetPageForFocusDate(focusDate, DateTime.monday);
        return DateTime(1970).add(Duration(days: targetPage.toInt()));
      }

      Iterable<DateTime> getTargetDates(int weekNumber) {
        return [
          DateTime.monday,
          DateTime.tuesday,
          DateTime.wednesday,
          DateTime.thursday,
          DateTime.friday,
          DateTime.saturday,
          DateTime.sunday,
        ].map((d) => DateTime(2020, weekNumber, d)).map(getTargetDate);
      }

      test('week 2020-1', () {
        expect(
          getTargetDates(1),
          everyElement(equals(DateTime(2019, 12, 30))),
        );
      });
      test('week 2020-18', () {
        expect(
          getTargetDates(18),
          everyElement(equals(DateTime(2020, 4, 27))),
        );
      });
    });

    test('getTargetPageForCurrent', () {
      // Monday of week 2020-01
      final startPage = DateTime(2019, 12, 30);

      expect(
        (-3).rangeTo(3).map((offset) {
          return visibleRange.getTargetPageForCurrent(
            startPage.epochDay + offset as double,
            DateTime.monday,
          );
        }),
        everyElement(equals(startPage)),
      );
    });
  });
}
