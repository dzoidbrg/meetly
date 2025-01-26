import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:appwrite/models.dart';
import 'package:intl/intl.dart';
import 'package:meetlyv2/constants.dart';
import 'package:uuid/uuid.dart';
class EventCollectionDocument {
  String title;
  String creatorUserId;
  EventCollectionDocument(this.title, this.creatorUserId);
}
class AppwriteData extends ChangeNotifier {
   Account account;
  Databases databases;
  User? user;
  bool isLoading = true;
  bool shouldLogin = false;
  AppwriteData( this.account, this.databases) {
    //
    attemptSessionRestore();

  }


  void signOut() async {
    await account.deleteSession(sessionId: "current");
    user = null;
    shouldLogin = true;
    notifyListeners();

  }
  void addEvent(String title, DateTime whenDate) async {

    await databases.createDocument(databaseId: DATABASE_ID, collectionId: EVENTS_COLLECTION_ID, documentId: Uuid().v4(), data: {
      "title": title,
      "creatorUserId": user!.$id,
      "when": new DateFormat("yyyy-MM-dd hh:mm:ss").format(whenDate)
    });
  }
  Future<DocumentList> discover() async {
    return await databases.listDocuments(databaseId: DATABASE_ID, collectionId: EVENTS_COLLECTION_ID);
  }
  /// Null is good as it means no errors
  Future<String?> login(String email, String password) async {
    try {
      await account.createEmailPasswordSession(email: email, password: password);
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
      print ("ooof oink my nig");

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
  void setAccount (Account acc) {
    account = acc;
    notifyListeners();
  }
  void setUser (User? usr) {
    user = usr;
    print(this.user);
    notifyListeners();
  }
  void forceNotify() {
    notifyListeners();
  }

}