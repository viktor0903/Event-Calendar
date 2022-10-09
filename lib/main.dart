
import 'package:calendar2/calendar_widget.dart';
import 'package:calendar2/editing_event_page.dart';
import 'package:calendar2/event_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  static const String title = 'Calendar';

  const MyApp({super.key});


  @override
  Widget build(BuildContext context)=>ChangeNotifierProvider(
    create: (context) =>EventProvider(),
      child:MaterialApp(
    debugShowCheckedModeBanner: false,
    title: title,

    home: MainPage(),

  ),
  );
}

class MainPage extends StatelessWidget {


  const MainPage({super.key});

  @override
  Widget build (context) => Scaffold(
    appBar: AppBar(
      title: const Text(MyApp.title),
      centerTitle: true,
    ),
    body: const CalendarWidget(),
    floatingActionButton: FloatingActionButton(onPressed: () => Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const EventEditingPage())
    ),
      backgroundColor: Colors.green,
      child: const Icon(Icons.add, color: Colors.white,),
      


    )
  );
}
