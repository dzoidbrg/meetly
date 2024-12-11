
import 'package:flutter/material.dart';
import 'package:appwrite/models.dart' as models;
class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  late models.User user;
  
  @override
  void initState() {
      // TODO: implement initState
    
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Text("Hello world my triggas");
  }
}