import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter/material.dart';
import 'package:meetlyv2/login.dart';
import 'package:provider/provider.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {



  @override
  Widget build(BuildContext context) {
    return  Consumer<AppwriteData>(builder: (ctx, model, lool) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.account_box, size: 80),
          Text("Welcome " + model.user!.name,style: TextStyle(fontSize: 32)),
          const Spacer(),
          ElevatedButton(onPressed: () { model.signOut();  Navigator.push(context, MaterialPageRoute(builder: (context) => Material(child: LoginPage())));
          ;}, child: const Text("Sign out" )),
          const Spacer()
        ],
      );
    });
  }
}

