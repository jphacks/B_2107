import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:jphacks/main_functions/create/create.dart';

import 'package:jphacks/setting/setting.dart';
import 'login/auth_model.dart';
import 'login/login_form.dart';
import 'main_functions/home.dart';
import 'package:provider/provider.dart';

import 'main_functions/join/join.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => AuthModel(),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primaryTextTheme:
                TextTheme(headline1: TextStyle(color: Colors.red)),
            primaryIconTheme: IconThemeData(color: Colors.red),
          ),
          home: _LoginCheck(),
          routes: <String, WidgetBuilder>{
            '/login': (_) => new Login(),
            '/create':(_) => CreateRoom(),
            '/join':(_) => Join(),
          },
        ));
  }
}

class _LoginCheck extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // ログイン状態に応じて、画面を切り替える
    final bool _loggedIn = context.watch<AuthModel>().loggedIn;
    return _loggedIn ? MyHomePage() : Login();
  }
}

const MaterialColor white = const MaterialColor(
  0xFFFFFFFF,
  const <int, Color>{
    50: const Color(0xFFFFFFFF),
    100: const Color(0xFFFFFFFF),
    200: const Color(0xFFFFFFFF),
    300: const Color(0xFFFFFFFF),
    400: const Color(0xFFFFFFFF),
    500: const Color(0xFFFFFFFF),
    600: const Color(0xFFFFFFFF),
    700: const Color(0xFFFFFFFF),
    800: const Color(0xFFFFFFFF),
    900: const Color(0xFFFFFFFF),
  },
);

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final auth = FirebaseAuth.instance;
  Widget build(BuildContext context) {
    var routes = [Home(), Setting()];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        actions: <Widget>[],
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(),
            ),
            ListTile(
              title: Text('ログアウトtest'),
              onTap: () async {
                Navigator.pop(context);
                auth.signOut();
                Navigator.of(context).pushNamed("/login");
              },
            ),
            ListTile(
              title: Text('roomを作成する'),
              onTap: () {
                Navigator.of(context).pushNamed("/create");
              },
            ),
            ListTile(
              title: Text('roomに参加する'),
              onTap: () {
               Navigator.of(context).pushNamed("/join");
              },
            ),
            ListTile(
              title: Text('test4'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: routes[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        //下のボタン
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.article),
            label: '会議',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: '設定',
          ),
        ],
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,
        onTap: _onItemTapped,
      ),
    );
  }
}
