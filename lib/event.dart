import 'dart:html';

import 'package:flutter/material.dart';

class Event{
  final String title;
  final String description;
  final DateTime from;
  final DateTime to;
  final Color backgroundColor = Colors.green;
  final bool isAllDay = false;


  const Event(
      this.from,
      this.to,
      this.title,
      this.description,

  );
}