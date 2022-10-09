import 'dart:html';
import 'package:calendar2/event.dart';

import 'package:calendar2/utils.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'editing_event_page.dart';
import 'event_provider.dart';

class EventViewingPage extends StatelessWidget {
  final Event event;

  const EventViewingPage({
    Key? key,
    required this.event,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      leading: const CloseButton(),
      actions: buildViewingActions(context, event),
    ),
    body: ListView(
      padding: const EdgeInsets.all(32),
      children: <Widget>[
        buildDateTime(event),
        SizedBox(height: 32),
        Text(
          event.title,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 24),
        Text(
          event.description,
          style: const TextStyle(color: Colors.white, fontSize: 18),
        ),
      ],
    ),
  );

  Widget buildDateTime(Event event) {
    return Column(
      children: [
        buildDate(event.isAllDay ? 'All-day' : 'From', event.from),
        if (!event.isAllDay) buildDate('To', event.to),
      ],
    );
  }

  Widget buildDate(String title, DateTime date) {
    final styleTitle = const TextStyle(fontSize: 20, fontWeight: FontWeight.bold);
    final styleDate = const TextStyle(fontSize: 18);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(child: Text(title, style: styleTitle)),
          Text(Utils.toDateTime(date), style: styleDate),
        ],
      ),
    );
  }

  List<Widget> buildViewingActions(BuildContext context, Event event) => [
    IconButton(
      icon: const Icon(Icons.edit),
      onPressed: () => Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => EventEditingPage(event: event),
        ),
      ),
    ),
    IconButton(
      icon: const Icon(Icons.delete),
      onPressed: () {
        final provider = Provider.of<EventProvider>(context, listen: false);

        provider.deleteEvent(event);
        Navigator.of(context).pop();
      },
    ),
  ];
}