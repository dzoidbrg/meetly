import 'package:flutter/material.dart';
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as models;
import 'package:meetlyv2/AddPage.dart';
import 'package:meetlyv2/account.dart';
import 'package:meetlyv2/discover.dart';
import 'package:meetlyv2/login.dart';
import 'package:meetlyv2/model.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  Client client = Client();
  client
      .setEndpoint('https://appwrite.bialy.ch/v1')
      .setProject('6756be660027fc17afa9')
      .setSelfSigned(status: true);
  Account account = Account(client);
  var databases = Databases(client);
// For self signed certificates, only use for development
  runApp(ChangeNotifierProvider(
      create: (context) => AppwriteData(account, databases), child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        cardTheme: CardTheme(
          elevation: 0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.grey[50],
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 0,
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
        appBarTheme: AppBarTheme(
          elevation: 0,
          centerTitle: false,
          backgroundColor:
              Colors.green[700], // Darker green for better contrast
          foregroundColor: Colors.white, // White text on dark green background
          titleTextStyle: TextStyle(
              fontWeight: FontWeight.w600, fontSize: 20, color: Colors.grey),
        ),
        useMaterial3: true,
      ),
      home: Scaffold(body: MyHomePage(title: "Meetly")),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

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
  models.User? user;
  int _counter = 0;

  @override
  void initState() {
    // TODO: implement initState
  }

  void triggerAddEvent() {
    Navigator.of(context).push(
        MaterialPageRoute(builder: (ctx) => Material(child: AddEventPage())));
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            // TRY THIS: Try changing the color here to a specific color (to
            // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
            // change color while the other colors stay the same.
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            // Here we take the value from the MyHomePage object that was created by
            // the App.build method, and use it to set our appbar title.
            title: Text(widget.title,
                style: TextStyle(fontWeight: FontWeight.w500)),
            elevation: 0,
            bottom: TabBar(
              indicatorSize: TabBarIndicatorSize.label,
              labelColor: Theme.of(context).primaryColor,
              unselectedLabelColor: Colors.grey[600],
              tabs: [
                Tab(icon: Icon(Icons.explore), text: "Explore"),
                Tab(icon: Icon(Icons.bookmark), text: "My Events"),
                Tab(icon: Icon(Icons.account_box), text: "Account"),
              ],
            ),
          ),
          body: Center(
              // Center is a layout widget. It takes a single child and positions it
              // in the middle of the parent.
              child: Consumer<AppwriteData>(builder: (ctx, model, ju) {
            if (model.isLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (model.shouldLogin) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.login,
                        size: 64,
                        color: Theme.of(context).primaryColor.withOpacity(0.7)),
                    SizedBox(height: 24),
                    Text("Welcome to Meetly",
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold)),
                    SizedBox(height: 8),
                    Text("Sign in to get started",
                        style:
                            TextStyle(fontSize: 16, color: Colors.grey[600])),
                    SizedBox(height: 32),
                    ElevatedButton.icon(
                      icon: Icon(Icons.login),
                      label: Text("Sign in", style: TextStyle(fontSize: 16)),
                      style: ElevatedButton.styleFrom(
                        padding:
                            EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                      ),
                      onPressed: () => {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    Material(child: LoginPage())))
                      },
                    ),
                  ],
                ),
              );
            } else {
              return TabBarView(children: [
                // Explore
                DiscoverPage(),
                Center(
                    child: Text("My Events", style: TextStyle(fontSize: 18))),
                AccountPage()
                // My Events
                // Account
              ]);
            }
          })),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: triggerAddEvent,
            tooltip: 'Add Event',
            icon: Icon(Icons.add),
            label: Text("Event"),
            elevation: 2,
          ), // This trailing comma makes auto-formatting nicer for build methods.
        ));
  }
}
