import 'dart:developer';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as models;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:meetlyv2/EventDetailsPage.dart';
import 'package:meetlyv2/constants.dart';
import 'package:meetlyv2/login.dart';
import 'package:meetlyv2/model.dart';
import 'package:provider/provider.dart';

class DiscoverPage extends StatefulWidget {
  const DiscoverPage({super.key});

  @override
  State<DiscoverPage> createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<AppwriteData>(builder: (ctx, model, late) {
      return FutureBuilder(
          future: model.discover(),
          builder: (ctx, snapshot) {
            if (snapshot.hasData) {
              final data = snapshot.data!;
              return RefreshIndicator(
                color: Theme.of(context).primaryColor,
                child: data.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.event_busy,
                                size: 64, color: Colors.grey[400]),
                            SizedBox(height: 16),
                            Text(
                              "No events yet",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w500),
                            ),
                            SizedBox(height: 8),
                            Text(
                              "Create your first event by tapping +",
                              style: TextStyle(
                                  fontSize: 14, color: Colors.grey[600]),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: EdgeInsets.all(16),
                        itemBuilder: (ctx, index) {
                          var widgetTitle = data[index].title;
                          var widgetDateTime = data[index].when;

                          log('Date time ${widgetDateTime.toString()}');

                          if (widgetDateTime == null) {
                            return InkWell(
                                child: Card(
                              margin: EdgeInsets.only(bottom: 12),
                              child: ListTile(
                                contentPadding: EdgeInsets.all(16),
                                title: Text(
                                  widgetTitle,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16),
                                ),
                              ),
                            ));
                          } else {
                            var parsedDateTime = DateTime.parse(widgetDateTime);

                            return InkWell(
                                onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (ctx) => EventDetailsPage(
                                              eventId: data[index].documentId,
                                            ))),
                                child: Card(
                                  margin: EdgeInsets.only(bottom: 12),
                                  child: Padding(
                                    padding: EdgeInsets.all(16),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          widgetTitle,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 18),
                                        ),
                                        SizedBox(height: 12),
                                        Row(
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                color: Theme.of(context)
                                                    .primaryColor
                                                    .withOpacity(0.1),
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 10, vertical: 6),
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    Icons.calendar_month,
                                                    size: 16,
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                  ),
                                                  SizedBox(width: 6),
                                                  // TODO: Add handling for year bounding dates e.g. 2026 so u show date but if same year you don't show. For now its ok...
                                                  Text(
                                                    DateFormat.yMMMd()
                                                        .format(parsedDateTime),
                                                    style: TextStyle(
                                                      color: Theme.of(context)
                                                          .primaryColor,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ));
                          }
                        },
                        itemCount: data.length,
                      ),
                onRefresh: () {
                  model.forceNotify();
                  // This is ugly....
                  // In an ideal world we would put everything in a magic state thing
                  // but honestly its just simpler and it works
                  // Performance changes can be added later
                  // I just added this comment to remind myself that eventually we want to remove this FutureBuilder and do everything from the state
                  // ++ the state should probably be split in seperate structs...
                  return Future.value();
                },
              );
            } else {
              if (snapshot.hasError) {
                print(snapshot!.error.toString());
              }
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                        color: Theme.of(context).primaryColor),
                    SizedBox(height: 16),
                    Text(
                      "Loading events...",
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              );
            }
          });
    });
  }
}
