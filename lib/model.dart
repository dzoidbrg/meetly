import 'dart:convert';

import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:appwrite/models.dart';
import 'package:intl/intl.dart';
import 'package:meetlyv2/constants.dart';
import 'package:meetlyv2/main.dart';
import 'package:uuid/uuid.dart';

class Notification {
  String? invitedEventId;
  String userID;
  /* 
  TYPES
  EVENT_INVITATION_HAS_BEEN_ADDED 
  */
  String type;
  Notification(this.userID, this.type, this.invitedEventId);
}

class NotificationToDisplay {
  String title;
  String desc;
  NotificationToDisplay(this.title, this.desc);
}

class DatePickerUser {
  String name;
  String userId;
  DatePickerUser(this.name, this.userId);
  @override
  // TODO: implement hashCode
  int get hashCode => this.userId.hashCode;
}

class EventCollectionDocument {
  String title;
  String creatorUserId;
  String documentId;
  String when;
  List<String> participants;
  String location;
  EventCollectionDocument(this.title, this.creatorUserId, this.documentId,
      this.when, this.participants, this.location);
}

class AppwriteData extends ChangeNotifier {
  Account account;
  Databases databases;
  Teams teams;
  Functions functions;
  Messaging messaging;
  User? user;
  bool isLoading = true;
  bool shouldLogin = false;
  AppwriteData(this.account, this.databases, this.teams, this.functions,
      this.messaging) {
    //
    attemptSessionRestore();
  }

  void signOut() async {
    await account.deleteSession(sessionId: "current");
    user = null;
    shouldLogin = true;
    notifyListeners();
  }

// TODO: Use appwrite TEAMS Feature. For now we are just going to use cloud func
// 1. Much simpler
// 2. We want MVP
  Future<List<DatePickerUser>> getAllusers() async {
    var response =
        await functions.createExecution(functionId: "680547ee00322e0ecc7a");
    print(response.responseBody);
    var data = jsonDecode(response.responseBody) as Map<String, dynamic>;
    var usersArray = data["users"] as List<dynamic>;
    var dataPickerUsers = <DatePickerUser>[];
    for (var user in usersArray) {
      dataPickerUsers.add(DatePickerUser(user["name"], user["id"]));
    }
    return dataPickerUsers;
  }

  void addEvent(
      String title, DateTime whenDate, List<String> participants) async {
    var eventId = Uuid().v4();
    await databases.createDocument(
        databaseId: DATABASE_ID,
        collectionId: EVENTS_COLLECTION_ID,
        documentId: eventId,
        data: {
          "title": title,
          "creatorUserId": user!.$id,
          "when": DateFormat("yyyy-MM-dd hh:mm:ss").format(whenDate),
          "participants": participants
        });
    // Send notfications to all!!!
    // for (var participant in participants) {
    //   await databases.createDocument(
    //       databaseId: DATABASE_ID,
    //       collectionId: NOTIFICATIONS_COLLECTION_ID,
    //       documentId: Uuid().v4(),
    //       data: {
    //         "userID": participant,
    //         "type": "EVENT_INVITATION_HAS_BEEN_ADDED",
    //         "invitedEventId": eventId
    //       });
    //   messaging.client
    // }
    // Call cloud funcition

    notifyListeners();
  }

  Future<EventCollectionDocument> getEvent(String eventID) async {
    var doc = await databases.getDocument(
        databaseId: DATABASE_ID,
        collectionId: EVENTS_COLLECTION_ID,
        documentId: eventID);
    EventCollectionDocument event = EventCollectionDocument(
        doc.data["title"],
        doc.data["creatorUserId"],
        doc.$id,
        doc.data["when"],
        (doc.data["participants"] as List)
            .map((item) => item.toString())
            .toList(),
        doc.data["location"]);
    return event;
  }

  Future<List<EventCollectionDocument>> discover() async {
    DocumentList ksut = await databases.listDocuments(
        databaseId: DATABASE_ID, collectionId: EVENTS_COLLECTION_ID);
    return ksut.documents
        .map((elem) => EventCollectionDocument(
            elem.data["title"],
            elem.data["creatorUserId"],
            elem.$id,
            elem.data["when"],
            [],
            elem.data["location"]))
        .toList();
  }

  /// Null is good as it means no errors
  Future<String?> login(String email, String password) async {
    try {
      await account.createEmailPasswordSession(
          email: email, password: password);
    } on AppwriteException catch (e) {
      return e.toString();
    }
    try {
      user = await account.get();
      shouldLogin = false;
      isLoading = false;
    } catch (e) {
      return e.toString();
    } finally {
      print(user);

      notifyListeners();
    }
  }

  Future<List<NotificationToDisplay>> getAllNotifications() async {
    var rawNotifs = await databases.listDocuments(
        databaseId: DATABASE_ID,
        collectionId: NOTIFICATIONS_COLLECTION_ID,
        queries: [Query.equal("userID", user!.$id)]);
    ;
    var parsedNotifs = rawNotifs.documents
        .map((elem) => Notification(elem.data["userID"], elem.data["type"],
            elem.data["invitedEventId"]))
        .toList();
    var notifsToDisplay = <NotificationToDisplay>[];
    for (var notif in parsedNotifs) {
      switch (notif.type) {
        case "EVENT_INVITATION_HAS_BEEN_ADDED":
          var correspondingEvent = await getEvent(notif
              .invitedEventId!); //We can use ! cuz type demands this. Error is wanted here
          notifsToDisplay.add(NotificationToDisplay(
              "Invitation to ${correspondingEvent.title}",
              "You have been invited to ${correspondingEvent.title}. Look at My Events to check the corresponding details."));
          break;
        default:
          break;
      }
    }
    return notifsToDisplay;
  }

  Future<String?> register(String email, String password, String name) async {
    try {
      await account.create(
          userId: ID.unique(), email: email, password: password, name: name);
    } on AppwriteException catch (e) {
      return e.toString();
    }

    return await login(email, password);
  }

  Future<void> attemptSessionRestore() async {
    try {
      user = await account.get();
      isLoading = false;
    } catch (e) {
      // Maybe try displaying error?
      print(e);
      isLoading = false;
      shouldLogin = true;
    } finally {
      print("Horray!");

      notifyListeners();
    }
    if (!shouldLogin) {
      print("DDd");
      var result = await MyApp.platform.invokeMethod<String?>('getFCMToken');
      if (result != null) {
        try {
          await account.createPushTarget(
              targetId: Uuid().v4(), identifier: result);
          print("Created Push Target");
        } catch (e) {
          print("Target already made := no problem");
        }
      }
    }
    print("ass");
  }

  void setAccount(Account acc) {
    account = acc;
    notifyListeners();
  }

  void setUser(User? usr) {
    user = usr;
    print(this.user);
    notifyListeners();
  }

  void forceNotify() {
    notifyListeners();
  }
}
