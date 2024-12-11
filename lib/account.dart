import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter/material.dart';
import 'package:meetlyv2/login.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key, required this.user, required this.account});
  final User user;
  final Account account;
  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  Widget buildWidget(BuildContext context, AsyncSnapshot<User> snapshot) {
    if (snapshot.hasError) {
      return Text(snapshot.error.toString());
    }
     if (!snapshot.hasData) {
          return const CircularProgressIndicator();
    }
   return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
       const Icon(Icons.account_box, size: 80),
         Text("Welcome " + snapshot.data!.name,style: TextStyle(fontSize: 32)),
        const Spacer(),
        ElevatedButton(onPressed: signOut, child: const Text("Sign out" )),
        const Spacer()
      ],
    );
  }
  void signOut() {
    widget.account.deleteSession(sessionId: "current");
    Navigator.push(context, MaterialPageRoute(builder: (context) => Material(child: LoginPage(account: widget.account))));

  }

  @override
  Widget build(BuildContext context) {
    return  Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
       const Icon(Icons.account_box, size: 80),
         Text("Welcome " + widget.user.name,style: TextStyle(fontSize: 32)),
        const Spacer(),
        ElevatedButton(onPressed: signOut, child: const Text("Sign out" )),
        const Spacer()
      ],
    );
  }
}
