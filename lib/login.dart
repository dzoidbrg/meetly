import 'package:appwrite/appwrite.dart';
import 'package:flutter/foundation.dart';
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
  Future<void> _showMyDialog( message) async {
    // TODO: handle errors properly with nice error messages
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Error while logging in / registering'),
        content:  SingleChildScrollView(
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
      await widget.account.createEmailPasswordSession(email: email, password: password);
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
    // Todo HANDLE ERROS
    return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(loggedInUser != null
                ? 'Logged in as ${loggedInUser!.name}'
                : 'Not logged in'),
          const  SizedBox(height: 16.0),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
        const    SizedBox(height: 16.0),
            TextField(
              controller: passwordController,
              decoration:const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
           const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () async {
                    await login(emailController.text, passwordController.text);
                                              print(loggedInUser);

                    if (loggedInUser != null) {
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('Login'),
                ),
                const SizedBox(width: 16.0),
                ElevatedButton(
                  onPressed: () {
                    register(emailController.text, passwordController.text,
                        nameController.text);
                         if (loggedInUser != null) {
                          print(loggedInUser);
                      Navigator.pop(context);
                    }
                  },
                  child: const  Text('Register'),
                ),
               const SizedBox(width: 16.0),
                ElevatedButton(
                  onPressed: () {
                    logout();
                  },
                  child: const Text('Logout'),
                ),
              ],
            ),
          ],
        );
  }
}