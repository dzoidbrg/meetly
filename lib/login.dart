import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:appwrite/models.dart';
import 'package:meetlyv2/model.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  User? loggedInUser;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  String email = "";
  String password = "";
  String name = "";
  bool loginOrRegister = false;
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




  @override
  Widget build(BuildContext context) {
    // Todo HANDLE ERROS;
    return Scaffold(
        appBar: AppBar(title: Text('Log In')),
        body: Consumer<AppwriteData>(builder: (ctx, model, child) {
          if (!loginOrRegister) {
            return Center(

                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Row(children: [
                          Text(loginOrRegister ? "Login      " : "Register "),
                          Switch(value: loginOrRegister, onChanged: (x) {
                            setState(() {
                              loginOrRegister = x;
                            });
                          })
                        ])),
                    Padding(padding: EdgeInsets.symmetric(
                        horizontal: 20, vertical: 5),
                        child: TextField(onChanged: (s) {
                          name = s;
                        },
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: "Name",
                                hintText: "Name"))),
                    Padding(padding: EdgeInsets.symmetric(
                        horizontal: 20, vertical: 5),
                        child: TextField(onChanged: (s) {
                          setState(() {
                            email = s;
                          });
                        },
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: "E-Mail",
                                hintText: "abcd@gmail.com"))),
                    Padding(padding: EdgeInsets.symmetric(
                        horizontal: 20, vertical: 5),
                        child: TextField(obscureText: true,
                            onChanged: (s) {
                              password = s;
                            },
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: "Password",
                                hintText: "hopefully not 1234"))),
                    ElevatedButton(onPressed: () async {
                      if (loginOrRegister) {
                        String? res = await model.login(email, password);
                        if (res == null) {
                          print("Success");
                          Navigator.pop(ctx);
                        } else {
                          _showMyDialog(res);
                        }
                      } else {
                        String? res = await model.register(email, password,
                            name);
                        if (res == null) {
                          print("Success");
                          Navigator.pop(ctx);
                        } else {
                          _showMyDialog(res);
                        }
                      }
                    }, child: Text(!loginOrRegister ? "Sign up " : "Sign in"))

                  ],
                ));
          } else {
            return Center(

                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(padding: EdgeInsets.symmetric(horizontal: 20),child: Row(children: [Text(loginOrRegister ? "Login      " : "Register "),Switch(value: loginOrRegister, onChanged: (x) {setState(() {
                      loginOrRegister = x;
                    });})])),

                    Padding(padding: EdgeInsets.symmetric(horizontal: 20,vertical: 5), child: TextField(onChanged: (s) {setState(() {
                      email = s;
                    });}, decoration: InputDecoration(border: OutlineInputBorder(), labelText: "E-Mail", hintText: "abcd@gmail.com"))),
                    Padding(padding: EdgeInsets.symmetric(horizontal: 20,vertical: 5), child: TextField(obscureText: true, onChanged: (s) {
                      password = s;
                    },decoration: InputDecoration(border: OutlineInputBorder(), labelText: "Password", hintText: "hopefully not 1234"))),
                    ElevatedButton(onPressed: () async {
                      if (loginOrRegister) {

                        String? res = await model.login(email, password);
                        if (res == null) {
                          print("Success");
                          Navigator.pop(ctx);
                        } else {
                          _showMyDialog(res);
                        }
                      } else {
                        String? res = await model.register(email, password, name);
                        if (res == null) {
                          print("Success");
                          Navigator.pop(ctx);
                        } else {
                          _showMyDialog(res);
                        }
                      }
                    }, child: Text(!loginOrRegister ? "Sign up " : "Sign in"))

                  ],
                ));
          }
        }));
  }
}
