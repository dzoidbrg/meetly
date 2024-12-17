import 'package:flutter/material.dart';
class AddEventPage extends StatefulWidget {
  const AddEventPage({super.key});

  @override
  State<AddEventPage> createState() => _AddEventPageState();
}

class _AddEventPageState extends State<AddEventPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text("Add event")),body:  Center(

    child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
      children: [

        Padding(padding: EdgeInsets.symmetric(
            horizontal: 20, vertical: 5),
            child: TextField(onChanged: (s) {
              //name = s;
            },
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Name",
                    hintText: "Name"))),
        Padding(padding: EdgeInsets.symmetric(
            horizontal: 20, vertical: 5),
            child: TextField(onChanged: (s) {
              setState(() {
              //  email = s;
              });
            },
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "E-Mail",
                    hintText: "abcd@gmail.com"))),
        Padding(padding: EdgeInsets.symmetric(
            horizontal: 20, vertical: 5),
            child: TextField(obscureText: true,
                onChanged: (s) {
               //   password = s;
                },
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Password",
                    hintText: "hopefully not 1234"))),
        Padding(padding: EdgeInsets.symmetric(
            horizontal: 20, vertical: 5),child: Row(children: [
        Icon(Icons.calendar_month),
        Text("23 of december 1929",style: Theme.of(context).textTheme.titleMedium,)
      ],))
      ],
    )));
  }
}

