import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:meetlyv2/model.dart';
import 'package:provider/provider.dart';

class AddEventPage extends StatefulWidget {
  AddEventPage({super.key});

  @override
  State<AddEventPage> createState() => _AddEventPageState();
}

class _AddEventPageState extends State<AddEventPage> {
  DateTime dateTime = DateTime.now();
  String title = "";
  @override
  Widget build(BuildContext context) {
    return Consumer<AppwriteData>(builder: (context, model, late) {
      return Scaffold(
          appBar: AppBar(title: Text("Add event")),
          body: Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Spacer(),
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  child: TextField(
                      onChanged: (s) {
                        setState(() {
                          title = s;
                        });
                      },
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Title",
                          hintText: "Simple short title of your event"))),
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  child: Row(
                    spacing: 2,
                    children: [
                      Text("When: ",
                          style: Theme.of(context).textTheme.titleMedium),
                      Icon(Icons.calendar_month),
                      Text(
                        DateFormat.yMMMd().format(dateTime),
                        style: Theme.of(context).textTheme.titleMedium,
                      )
                    ],
                  )),
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  child: ElevatedButton(
                      onPressed: () async {
                        var dateTime = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(20230), //TODO FIX!!!
                        );
                        setState(() {
                          this.dateTime = dateTime ?? DateTime.now();
                        });
                      },
                      child: Text("Change Date"))),
              Spacer(),
              ElevatedButton(
                  onPressed: () {
                    model.addEvent(title,dateTime);
                    Navigator.pop(context);
                  },
                  child: Text("Submit"))
            ],
          )));
    });
  }
}
