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
  List<String> participants = [];
  final List<String> availableParticipants = ["Bob", "Mayella", "Derreck"];
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Consumer<AppwriteData>(builder: (context, model, late) {
      return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            title: Text("Create Event",
                style:
                    TextStyle(fontWeight: FontWeight.w600, color: Colors.grey)),
            actions: [
              IconButton(
                icon: Icon(Icons.info_outline, color: Colors.grey),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content:
                          Text('Fill in event details and add participants')));
                },
              ),
            ],
          ),
          body: Form(
            key: _formKey,
            child: ListView(
              padding: EdgeInsets.all(16),
              children: [
                // Title Section
                Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  color: Colors.white,
                  margin: EdgeInsets.only(bottom: 16),
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.title,
                                size: 20,
                                color: Theme.of(context).primaryColor),
                            SizedBox(width: 8),
                            Text(
                              "Event Details",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: "Title",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8)),
                            prefixIcon: Icon(Icons.event_note),
                            hintText: "Simple short title of your event",
                            filled: true,
                            fillColor: Colors.grey[50],
                          ),
                          validator: (value) => value == null || value.isEmpty
                              ? "Please enter a title"
                              : null,
                          onChanged: (s) {
                            setState(() {
                              title = s;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),

                // Date Section
                Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  color: Colors.white,
                  margin: EdgeInsets.only(bottom: 16),
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.calendar_today,
                                size: 20,
                                color: Theme.of(context).primaryColor),
                            SizedBox(width: 8),
                            Text(
                              "Date",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        InkWell(
                          onTap: () async {
                            var newDateTime = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2050),
                            );
                            setState(() {
                              this.dateTime = newDateTime ?? DateTime.now();
                            });
                          },
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.grey[300]!),
                              color: Colors.grey[50],
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.calendar_month,
                                    color: Theme.of(context).primaryColor),
                                SizedBox(width: 12),
                                Text(
                                  DateFormat.yMMMMd().format(dateTime),
                                  style: TextStyle(fontSize: 16),
                                ),
                                Spacer(),
                                Icon(Icons.arrow_drop_down, color: Colors.grey),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Participants Section
                Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  color: Colors.white,
                  margin: EdgeInsets.only(bottom: 16),
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.people,
                                size: 20,
                                color: Theme.of(context).primaryColor),
                            SizedBox(width: 8),
                            Text(
                              "Participants",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey[300]!),
                            color: Colors.grey[50],
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              isExpanded: true,
                              icon: Icon(Icons.arrow_drop_down,
                                  color: Theme.of(context).primaryColor),
                              hint: Text(
                                participants.isEmpty
                                    ? "Select participants"
                                    : "${participants.length} participant${participants.length > 1 ? 's' : ''} selected",
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor),
                              ),
                              items: availableParticipants
                                  .map((String participant) {
                                return DropdownMenuItem<String>(
                                  value: participant,
                                  child: StatefulBuilder(
                                    builder: (BuildContext context,
                                        StateSetter menuSetState) {
                                      return CheckboxListTile(
                                        title: Text(participant,
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500)),
                                        value:
                                            participants.contains(participant),
                                        activeColor:
                                            Theme.of(context).primaryColor,
                                        onChanged: (bool? selected) {
                                          setState(() {
                                            menuSetState(() {
                                              if (selected == true) {
                                                participants.add(participant);
                                              } else {
                                                participants
                                                    .remove(participant);
                                              }
                                            });
                                          });
                                        },
                                        controlAffinity:
                                            ListTileControlAffinity.leading,
                                      );
                                    },
                                  ),
                                );
                              }).toList(),
                              onChanged: (_) {},
                            ),
                          ),
                        ),
                        if (participants.isNotEmpty)
                          Container(
                            margin: EdgeInsets.only(top: 12),
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .primaryColor
                                  .withOpacity(0.05),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Selected:",
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.grey[600]),
                                ),
                                SizedBox(height: 8),
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: participants
                                      .map((participant) => Chip(
                                            backgroundColor: Theme.of(context)
                                                .primaryColor
                                                .withOpacity(0.1),
                                            side: BorderSide(
                                                color: Theme.of(context)
                                                    .primaryColor
                                                    .withOpacity(0.2)),
                                            avatar: CircleAvatar(
                                              backgroundColor: Theme.of(context)
                                                  .primaryColor,
                                              child: Text(participant[0],
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 12)),
                                            ),
                                            label: Text(participant,
                                                style: TextStyle(fontSize: 14)),
                                            deleteIcon:
                                                Icon(Icons.cancel, size: 18),
                                            deleteIconColor:
                                                Theme.of(context).primaryColor,
                                            onDeleted: () {
                                              setState(() {
                                                participants
                                                    .remove(participant);
                                              });
                                            },
                                          ))
                                      .toList(),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ),

                // Submit Button
                SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    onPressed: () {
                      if (_formKey.currentState?.validate() ?? false) {
                        model.addEvent(title, dateTime, []);
                        Navigator.pop(context);
                        model
                            .forceNotify(); // TODO: FInd out why this is needed and if this has any consequences. This was added to fix the problem that after return to dsicover after add no update.
                      }
                    },
                    child: Text(
                      "Create Event",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
