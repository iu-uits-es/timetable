import 'package:flutter/physics.dart';
import 'package:meta/meta.dart';
import 'controller.dart';
import 'timetable.dart';
import 'utils/utils.dart';

abstract class VisibleRange {
  const VisibleRange({
    @required this.visibleDays,
  })  : assert(visibleDays != null),
        assert(visibleDays > 0);

  /// Display a fixed number of days.
  ///
  /// While scrolling, this can snap to all dates.
  ///
  /// When animating to a date (see [TimetableController.animateTo]), that day
  /// will be aligned to the left.
  const factory VisibleRange.days(int count) = DaysVisibleRange;

  /// Display seven consecutive days, aligned based on
  /// [TimetableController.firstDayOfWeek].
  ///
  /// While scrolling, this only snaps to week boundaries.
  ///
  /// When animating to a date (see [TimetableController.animateTo]), the week
  /// containing that date will fill the viewport.
  const factory VisibleRange.week() = WeekVisibleRange;

  final int visibleDays;

  /// Convenience method of [getTargetPageForFocus] taking a [DateTime].
  double getTargetPageForFocusDate(DateTime focusDate, int firstDayOfWeek) {
    assert(focusDate != null);
    return getTargetPageForFocus(focusDate.epochDay.toDouble(), firstDayOfWeek);
  }

  /// Gets the page to align to the viewport's left side based on the
  /// [focusPage] to show.
  double getTargetPageForFocus(double focusPage, int firstDayOfWeek);

  /// Gets the page to align to the viewport's left side based on the
  /// [currentPage] in that position.
  double getTargetPageForCurrent(
    double currentPage,
    int firstDayOfWeek, {
    double velocity = 0,
    Tolerance tolerance = Tolerance.defaultTolerance,
  });

  @protected
  double getDefaultVelocityAddition(double velocity, Tolerance tolerance) {
    assert(velocity != null);
    assert(tolerance != null);

    return velocity.abs() > tolerance.velocity ? 0.5 * velocity.sign : 0.0;
  }
}

class DaysVisibleRange extends VisibleRange {
  const DaysVisibleRange(int count) : super(visibleDays: count);

  @override
  double getTargetPageForFocus(double focusPage, int firstDayOfWeek) => getTargetPageForCurrent(focusPage, firstDayOfWeek);

  @override
  double getTargetPageForCurrent(
    double focusPage,
    int firstDayOfWeek, {
    double velocity = 0,
    Tolerance tolerance = Tolerance.defaultTolerance,
  }) {
    assert(focusPage != null);
    assert(firstDayOfWeek != null);
    assert(velocity != null);
    assert(tolerance != null);

    final velocityAddition = getDefaultVelocityAddition(velocity, tolerance);
    return (focusPage + velocityAddition).roundToDouble();
  }
}

/// The [Timetable] will show exactly one week and will snap to week boundaries.
///
/// You can configure the first day of a week via
/// [TimetableController.firstDayOfWeek].
class WeekVisibleRange extends VisibleRange {
  static const daysPerWeek = 7;
  const WeekVisibleRange() : super(visibleDays: daysPerWeek);

  @override
  double getTargetPageForFocus(
    double focusPage,
    int firstDayOfWeek, {
    double velocity = 0,
    Tolerance tolerance = Tolerance.defaultTolerance,
  }) {
    assert(focusPage != null);
    assert(firstDayOfWeek != null);
    assert(velocity != null);
    assert(tolerance != null);

    final epochWeekDayOffset = firstDayOfWeek - DateTime(1970).weekday;
    final focusWeek = (focusPage - epochWeekDayOffset) / daysPerWeek;

    final velocityAddition = getDefaultVelocityAddition(velocity, tolerance);
    final targetWeek = (focusWeek + velocityAddition).floorToDouble();
    return targetWeek * daysPerWeek + epochWeekDayOffset;
  }

  @override
  double getTargetPageForCurrent(
    double focusPage,
    int firstDayOfWeek, {
    double velocity = 0,
    Tolerance tolerance = Tolerance.defaultTolerance,
  }) {
    return getTargetPageForFocus(
      focusPage + daysPerWeek / 2,
      firstDayOfWeek,
      velocity: velocity,
      tolerance: tolerance,
    );
  }
}
