import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:appwrite/models.dart';

class LoginPage extends StatefulWidget {
  final Account account;
  const LoginPage({super.key, required this.account});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  User? loggedInUser;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  Future<void> _showMyDialog(message) async {
    // TODO: handle errors properly with nice error messages
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error while logging in / registering'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text("$message"),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> login(String email, String password) async {
    try {
      await widget.account
          .createEmailPasswordSession(email: email, password: password);
    } on AppwriteException catch (e) {
      await _showMyDialog(e.message);
      return;
    }
    final user = await widget.account.get();
    setState(() {
      loggedInUser = user;
    });
  }

  Future<void> register(String email, String password, String name) async {
    try {
      await widget.account.create(
          userId: ID.unique(), email: email, password: password, name: name);
    } on AppwriteException catch (e) {
      await _showMyDialog(e.message);
      return;
    }

    await login(email, password);
  }

  Future<void> logout() async {
    await widget.account.deleteSession(sessionId: 'current');
    setState(() {
      loggedInUser = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Todo HANDLE ERROS;
    return Scaffold(
        appBar: AppBar(title: Text('Log In')),
        body: Center(
        
                child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(padding: EdgeInsets.symmetric(horizontal: 20,vertical: 5), child: TextField(decoration: InputDecoration(border: OutlineInputBorder(), labelText: "Name", hintText: "Name"))),
            Padding(padding: EdgeInsets.symmetric(horizontal: 20,vertical: 5), child: TextField(decoration: InputDecoration(border: OutlineInputBorder(), labelText: "E-Mail", hintText: "abcd@gmail.com"))),
            Padding(padding: EdgeInsets.symmetric(horizontal: 20,vertical: 5), child: TextField(decoration: InputDecoration(border: OutlineInputBorder(), labelText: "Password", hintText: "hopefully not 1234"))),

          ],
        )));
  }
}
