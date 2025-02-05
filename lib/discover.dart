import 'dart:developer';

import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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

      return FutureBuilder(future: model.discover(), builder: (ctx,snapshot) {
        if (snapshot.hasData) {
         return RefreshIndicator(child: ListView.builder(itemBuilder: (ctx,index) {
           var widgetTitle = snapshot.data!.documents[index].data["title"];
           var widgetDateTime = snapshot.data!.documents[index].data["when"];

           log('Date time ${widgetDateTime.toString()}');
           if (widgetDateTime == null ) {
             return Card(child: ListTile(title: Text(widgetTitle)));

           } else {
             var parsedDateTime = DateTime.parse(widgetDateTime);

             return Card(child: ListTile(title: Text(widgetTitle),subtitle: Row(
               children: [

                 Padding(padding: EdgeInsets.symmetric(horizontal: 3),child: Icon(Icons.calendar_month)), // icon
                 // TODO: Add handling for year bounding dates e.g. 2026 so u show date but if same year you don't show. For now its ok...
                 Text(DateFormat(DateFormat.ABBR_MONTH_DAY,"en_US").format(parsedDateTime))               ],
             ),));

           }
         }, itemCount: snapshot.data!.total),onRefresh: () {
           model.forceNotify();
           // This is ugly....
           // In an ideal world we would put everything in a magic state thing
           // but honestly its just simpler and it works
           // Performance changes can be added later
           // I just added this comment to remind myself that eventually we want to remove this FutureBuilder and do everything from the state
           // ++ the state should probably be split in seperate structs...
           return Future.value();
         },);
        } else {
          if (snapshot.hasError) {
            print(snapshot!.error.toString());
          }
          return Center(child:CircularProgressIndicator());
        }
      });
    });
  }
}
