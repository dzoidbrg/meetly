import 'package:flutter/material.dart';
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as models;
import 'package:meetlyv2/login.dart';

void main() {
    WidgetsFlutterBinding.ensureInitialized();

Client client = Client();
client
    .setEndpoint('https://cloud.appwrite.io/v1')
    .setProject('66ff9e55000f6375882c')
    .setSelfSigned(status: true); 
  
Account account = Account(client);
// For self signed certificates, only use for development
  runApp(MyApp(account: account));
}

class MyApp extends StatelessWidget {  
  final Account account;

  const MyApp({super.key, required this.account});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App which is 95% complete',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
        useMaterial3: true,
      ),
      home: Scaffold(
        body:MyHomePage(title: "Meetly", account: account,)
      ),
    );
  }
}






class MyHomePage extends StatefulWidget {

   final Account account;

  const MyHomePage({super.key, required this.title, required this.account});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Future<bool> login;
  models.User? user;
  int _counter = 0;

  Future<bool> isSignedIn() async {
    try {
      // Attempt to retrieve the currently logged-in user
      models.User user = await widget.account.get();
      return true; // User is signed in
    } catch (e) {
      return false; // User is not signed in
    }
  }

@override
  void initState() {
    // TODO: implement initState
    login = isSignedIn();
    
  }

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
   
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return 
    DefaultTabController(length: 3, child: 
   Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
         bottom: const TabBar(
          tabs: [
            Tab(icon: Icon(Icons.explore)),
            Tab(icon: Icon(Icons.bookmark)),
            Tab(icon: Icon(Icons.account_box)),
          ],
        ),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child:  FutureBuilder(
      future: login,
      builder: (context,snapshot) {
        if (snapshot.data != null) {
          if (snapshot.data!) {
            // logged in 
            return TabBarView(children: [
              // Explore
              Text("Explore"),
              Text("My Events"),
              Text("Account")
              // My Events
              // Account 
            ]);
          } else {
            return ElevatedButton(child: Text("Sign in"),onPressed: () => {
              Navigator.push(context, MaterialPageRoute(builder: (context) => Material(child: LoginPage(account: widget.account))))
            });
          }
          
        } else {
          return CircularProgressIndicator();
        }
        }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    ));
    
   
  }
}
