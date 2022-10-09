import 'package:calendar2/event_provider.dart';
import 'package:calendar2/task_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import 'event_data_source.dart';


class CalendarWidget extends StatelessWidget {
  const CalendarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final events = Provider.of<EventProvider>(context).events;

    return SfCalendar(
      view: CalendarView.month,
      dataSource: EventDataSource(events),
      initialSelectedDate: DateTime.now(),
      cellBorderColor: Colors.transparent,
      onSelectionChanged: (details) {
        final provider = Provider.of<EventProvider>(context, listen: false);

        provider.setDate(details.date!);
      },
      onTap: (details) {
        final provider = Provider.of<EventProvider>(context, listen: false);

        if (provider.selectedDate == details.date) {
          showModalBottomSheet(
            context: context,
            builder: (context) => const TaskWidget(),
          );
        }
      },
      onLongPress: (details) {
        final provider = Provider.of<EventProvider>(context, listen: false);

        provider.setDate(details.date!);
        showModalBottomSheet(
          context: context,
          builder: (context) => const TaskWidget(),
        );
      },
    );
  }
}