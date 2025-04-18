import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:appwrite/models.dart';
import 'package:intl/intl.dart';
import 'package:meetlyv2/constants.dart';
import 'package:uuid/uuid.dart';

class DatePickerUser {
  String name;
  String userId;
  DatePickerUser(this.name, this.userId);
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
  User? user;
  bool isLoading = true;
  bool shouldLogin = false;
  AppwriteData(this.account, this.databases) {
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
    return [];
  }

  void addEvent(
      String title, DateTime whenDate, List<String> participants) async {
    await databases.createDocument(
        databaseId: DATABASE_ID,
        collectionId: EVENTS_COLLECTION_ID,
        documentId: Uuid().v4(),
        data: {
          "title": title,
          "creatorUserId": user!.$id,
          "when": DateFormat("yyyy-MM-dd hh:mm:ss").format(whenDate),
          "participants": participants
        });
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
        (doc.data["participants"] as List).map((item) => item.toString()).toList(),
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
