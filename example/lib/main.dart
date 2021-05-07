import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:timetable/timetable.dart';

// ignore: unused_import
import 'positioning_demo.dart';
import 'utils.dart';

void main() async {
  setTargetPlatformForDesktop();
  WidgetsFlutterBinding.ensureInitialized();
  runApp(ExampleApp(child: TimetableExample()));
}

class TimetableExample extends StatefulWidget {
  @override
  _TimetableExampleState createState() => _TimetableExampleState();
}

class _TimetableExampleState extends State<TimetableExample> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  TimetableController<BasicEvent> _controller;

  @override
  void initState() {
    super.initState();

    _controller = TimetableController(
      // A basic EventProvider containing a single event:
      eventProvider: EventProvider.list([
        BasicEvent(
          id: 0,
          title: 'My Event',
          color: Colors.blue,
          start: DateTime.now().at(TimeOfDay(hour:13, minute:0)),
          end: DateTime.now().at(TimeOfDay(hour:15, minute:0)),
        ),
      ]),

      // For a demo of overlapping events, use this one instead:
      // eventProvider: positioningDemoEventProvider,

      // Or even this short example using a Stream:
      // eventProvider: EventProvider.stream(
      //   eventGetter: (range) => Stream.Durationic(
      //     Duration(milliseconds: 16),
      //     (i) {
      //       final start =
      //           DateTime.now().atMidnight().atMidnight() + Duration(minutes: i * 2);
      //       return [
      //         BasicEvent(
      //           id: 0,
      //           title: 'Event',
      //           color: Colors.blue,
      //           start: start,
      //           end: start + Duration(hours: 5),
      //         ),
      //       ];
      //     },
      //   ),
      // ),

      // Other (optional) parameters:
      initialTimeRange: InitialTimeRange.range(
        startTime: TimeOfDay(hour:8, minute:0),
        endTime: TimeOfDay(hour:20, minute:0),
      ),
      initialDate: DateTime.now().atMidnight(),
      visibleRange: VisibleRange.days(3),
      firstDayOfWeek: DateTime.monday,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Timetable example'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.today),
            onPressed: () => _controller.animateToToday(),
            tooltip: 'Jump to today',
          ),
        ],
      ),
      body: Timetable<BasicEvent>(
        controller: _controller,
        onEventBackgroundTap: (start, isAllDay) {
          _showSnackBar('Background tapped $start is all day event $isAllDay');
        },
        eventBuilder: (event) {
          return BasicEventWidget(
            event,
            onTap: () => _showSnackBar('Part-day event $event tapped'),
          );
        },
        allDayEventBuilder: (context, event, info) => BasicAllDayEventWidget(
          event,
          info: info,
          onTap: () => _showSnackBar('All-day event $event tapped'),
        ),
      ),
    );
  }

  void _showSnackBar(String content) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(content),
    ));
  }
}
