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
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Row(
            children: [
              Icon(Icons.error_outline, color: Colors.red[400]),
              SizedBox(width: 8),
              Text('Error while logging in / registering', style: TextStyle(fontSize: 18)),
            ],
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text("$message", style: TextStyle(color: Colors.grey[800])),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
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
        appBar: AppBar(
          title: Text('Log In', style: TextStyle(fontWeight: FontWeight.w500)),
          elevation: 0,
        ),
        body: Consumer<AppwriteData>(builder: (ctx, model, child) {
          return Padding(
            padding: EdgeInsets.all(20),
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 0,
              child: Padding(
                padding: EdgeInsets.all(24),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Logo and title
                      Icon(
                        loginOrRegister ? Icons.login : Icons.app_registration,
                        size: 72,
                        color: Theme.of(context).primaryColor,
                      ),
                      SizedBox(height: 16),
                      Text(
                        loginOrRegister ? "Welcome Back" : "Create Account",
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 8),
                      Text(
                        loginOrRegister ? "Sign in to continue" : "Sign up to get started",
                        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 32),
                      
                      // Toggle switch between login/register
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(32),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              loginOrRegister ? "Login" : "Register",
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                            SizedBox(width: 8),
                            Switch(
                              value: loginOrRegister,
                              activeColor: Theme.of(context).primaryColor,
                              onChanged: (x) {
                                setState(() {
                                  loginOrRegister = x;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 24),
                      
                      // Form fields
                      if (!loginOrRegister) ... [
                        TextField(
                          onChanged: (s) {
                            name = s;
                          },
                          decoration: InputDecoration(
                            labelText: "Name",
                            hintText: "Your full name",
                            prefixIcon: Icon(Icons.person_outline),
                          ),
                        ),
                        SizedBox(height: 16),
                      ],
                      
                      TextField(
                        onChanged: (s) {
                          setState(() {
                            email = s;
                          });
                        },
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: "E-Mail",
                          hintText: "abcd@gmail.com",
                          prefixIcon: Icon(Icons.email_outlined),
                        ),
                      ),
                      SizedBox(height: 16),
                      
                      TextField(
                        obscureText: true,
                        onChanged: (s) {
                          password = s;
                        },
                        decoration: InputDecoration(
                          labelText: "Password",
                          hintText: "hopefully not 1234",
                          prefixIcon: Icon(Icons.lock_outline),
                        ),
                      ),
                      SizedBox(height: 32),
                      
                      // Submit button
                      Container(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).primaryColor,
                            foregroundColor: Colors.white,
                          ),
                          onPressed: () async {
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
                          },
                          child: Text(
                            !loginOrRegister ? "Sign up" : "Sign in",
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }));
  }
}
