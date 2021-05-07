import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import 'utils/vertical_zoom.dart';
import 'utils/utils.dart';

@immutable
abstract class InitialTimeRange {
  const InitialTimeRange();

  const factory InitialTimeRange.zoom(double zoom) = _FactorInitialTimeRange;
  factory InitialTimeRange.range({
    TimeOfDay startTime,
    TimeOfDay endTime,
  }) = _RangeInitialTimeRange;

  InitialZoom asInitialZoom();
}

class _FactorInitialTimeRange extends InitialTimeRange {
  const _FactorInitialTimeRange(this.zoom)
      : assert(zoom != null),
        assert(VerticalZoom.zoomMin <= zoom && zoom <= VerticalZoom.zoomMax);

  final double zoom;

  @override
  InitialZoom asInitialZoom() => InitialZoom.zoom(zoom);
}

class _RangeInitialTimeRange extends InitialTimeRange {
  _RangeInitialTimeRange({
    TimeOfDay startTime,
    TimeOfDay endTime,
  })  : startTime = startTime ?? TimeOfDay(hour: 0, minute: 0),
        endTime = endTime ?? TimeOfDay(hour: 23, minute: 59),
        assert(startTime < endTime);

  final TimeOfDay startTime;
  final TimeOfDay endTime;

  static double _timeToFraction(TimeOfDay time) => time.sinceMidnight.inSeconds / Duration.secondsPerDay;

  @override
  InitialZoom asInitialZoom() => InitialZoom.range(
        startFraction: _timeToFraction(startTime),
        endFraction: _timeToFraction(endTime),
      );
}
