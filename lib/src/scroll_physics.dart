// Inspired by [PageScrollPhysics]
import 'package:flutter/widgets.dart';

import 'controller.dart';

class TimetableScrollPhysics extends ScrollPhysics {
  const TimetableScrollPhysics(this.controller, {ScrollPhysics parent})
      : assert(controller != null),
        super(parent: parent);

  final TimetableController controller;

  @override
  TimetableScrollPhysics applyTo(ScrollPhysics ancestor) {
    return TimetableScrollPhysics(controller, parent: buildParent(ancestor));
  }

  double _getTargetPixels(
    ScrollPosition position,
    Tolerance tolerance,
    double velocity,
  ) {
    final pixels = position.hasPixels ? position.pixels : 0;
    final pixelsToPage = position.hasViewportDimension ? controller.visibleRange.visibleDays / position.viewportDimension : 0;
    final currentPage = pixels * pixelsToPage;

    final targetPage = controller.visibleRange.getTargetPageForCurrent(
      currentPage,
      controller.firstDayOfWeek,
      velocity: velocity,
      tolerance: tolerance,
    );
    return targetPage / pixelsToPage;
  }

  @override
  Simulation createBallisticSimulation(ScrollMetrics position, double velocity) {
    // If we're out of range and not headed back in range, defer to the parent
    // ballistics, which should put us back in range at a page boundary.
    final pixels = position.hasPixels ? position.pixels : 0;
    if ((velocity <= 0.0 && pixels <= position.minScrollExtent) || (velocity >= 0.0 && pixels >= position.maxScrollExtent)) {
      return super.createBallisticSimulation(position, velocity);
    }
    final tolerance = this.tolerance;
    final target = _getTargetPixels(position, tolerance, velocity);
    if (target != pixels) {
      return ScrollSpringSimulation(
        spring,
        pixels,
        target,
        velocity,
        tolerance: tolerance,
      );
    }
    return null;
  }

  @override
  bool get allowImplicitScrolling => false;
}
