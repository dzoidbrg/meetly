import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:meetlyv2/model.dart';
import 'package:provider/provider.dart';

class NotificationsView extends StatefulWidget {
  NotificationsView({super.key});

  @override
  State<NotificationsView> createState() => _NotificationsViewState();
}

class _NotificationsViewState extends State<NotificationsView> {
  DateTime dateTime = DateTime.now();
  String title = "";
  List<DatePickerUser> participants = [];
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Consumer<AppwriteData>(builder: (context, model, _) {
      return FutureBuilder<List<DatePickerUser>>(
        future: model.getAllusers(),
        builder: (context, snapshot) {
          return SafeArea(
            child: Scaffold(
                appBar: AppBar(
                  elevation: 0,
                  backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                  title: Text("Create Event",
                      style: TextStyle(
                          fontWeight: FontWeight.w600, color: Colors.grey)),
                  actions: [
                    IconButton(
                      icon: Icon(Icons.info_outline, color: Colors.grey),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(
                                'Fill in event details and add participants')));
                      },
                    ),
                  ],
                ),
                body: Text("Tello")),
          );
        },
      );
    });
  }
}
