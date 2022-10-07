import 'package:flutter/material.dart';
import 'package:calendar2/utils.dart';
import 'package:calendar2/event.dart';


class EventEditingPage extends StatefulWidget {
  final Event? event;

  const EventEditingPage({
    Key? key,
    this.event,
  }) : super(key:key);

  @override
  State<EventEditingPage> createState() => _EventEditingPageState();
}

class _EventEditingPageState extends State<EventEditingPage>{
  final _formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  late DateTime fromDate;
  late DateTime toDate;

  @override
  void initState(){
    super.initState();

    if(widget.event == null) {
      fromDate = DateTime.now();
      toDate = DateTime.now().add(const Duration(hours: 2));
    }
  }
  @override
  void dispose() {
    titleController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context)=>Scaffold(
    appBar: AppBar(
      leading: const CloseButton(),
      actions: buildEditingActions(),
    ),
    body: SingleChildScrollView(
      padding: const EdgeInsets.all(12),
      child:Form(
       key: _formKey,
       child:Column(
         mainAxisSize: MainAxisSize.min,
         children: <Widget>[
           buildTitle(),
           const SizedBox(height: 12,),
           buildDateTimePickers(),

         ],
      ),
      ),
    ),
  );

  List<Widget> buildEditingActions() => [
    ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
      ),
        onPressed: () {},
        icon: const Icon(Icons.done),
        label: const Text('SAVE')
    ),
  ];
  // Text controller
  Widget buildTitle() => TextFormField(
    style: const TextStyle(fontSize: 24),
    decoration: const InputDecoration(
      border: UnderlineInputBorder(),
      hintText: 'Add Title',
    ),
    onFieldSubmitted: (_) {},
    //title validator
    validator: (title) =>
       title != null && title.isEmpty ? 'Title cannot be empty' : null,
    controller: titleController,
  );

  Widget buildDateTimePickers() => Column(
    children: [
      buildFrom(),
      buildTo(),
    ],
  );

  Widget buildFrom() => buildHeader(
         header: 'FROM',
         child:Row(
           children: [
             Expanded(
        //Flex more space for (Day:Month:Date:Year) over Time
               flex: 2,
               child: buildDropdownField(
                 text: Utils.toDate(fromDate),
                 onClicked: () => pickFromDateTime(pickDate: true),
               ),
             ),
             Expanded(
               child: buildDropdownField(
                 text: Utils.toTime(fromDate),
                 onClicked: () => pickFromDateTime(pickDate: false),
               ),
             ),
           ],
  ),
  );
  Widget buildTo() => buildHeader(
      header: 'TO',
      child:Row(
        children: [
          Expanded(
          //Flex more space for (Day:Month:Date:Year) over Time
            flex: 2,
            child: buildDropdownField(
              text: Utils.toDate(toDate),
              onClicked: () => pickFromDateTime(pickDate: true),
          ),
        ),
        Expanded(
          child: buildDropdownField(
            text: Utils.toTime(toDate),
            onClicked: () => pickFromDateTime(pickDate: false),
          ),
        ),
      ],
  ),
  );
  Future pickFromDateTime({required bool pickDate}) async{
    var date = await pickDateTime(fromDate, pickDate: pickDate);
    if (date == null) return;

    if(date.isAfter(toDate)) {
      toDate=
          DateTime(date.year,date.month,date.day, toDate.hour, toDate.minute);
    }

    setState(() => fromDate = date);
  }

  Future<DateTime?> pickDateTime(
      DateTime initialDate, {
      required bool pickDate,
      DateTime? firstDate,
      }) async {
    if (pickDate) {
      final date = await showDatePicker(
          context: context,
          initialDate: initialDate,
          firstDate: firstDate ?? DateTime(2022,10),
          lastDate: DateTime(2100),
      );

      if(date == null) return null;

      final time =
          Duration(hours: initialDate.hour, minutes: initialDate.minute);

      return date.add(time);

    } else {
      final timeOfDay = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(initialDate),
    );


    if (timeOfDay == null) return null;

    final date =
        DateTime(initialDate.year,initialDate.month,initialDate.day);
    final time = Duration(hours: timeOfDay.hour, minutes: timeOfDay.minute);

    return date.add(time);
    }
  }

  Widget buildDropdownField({
    required String text,
    required Null Function() onClicked,
  }) =>
      ListTile(
        title: Text(text),
        trailing: const Icon(Icons.arrow_drop_down),
        onTap: onClicked,
      );

  Widget buildHeader({
    required String header,
    required Widget child,
  }) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(header, style: const TextStyle(fontWeight: FontWeight.bold))
        ],
      );
}
