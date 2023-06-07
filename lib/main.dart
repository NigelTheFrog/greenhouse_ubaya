import 'package:flutter/material.dart';
import 'package:greenhouse_ubaya/accountlist.dart';
import 'package:greenhouse_ubaya/addraspi.dart';
import 'package:greenhouse_ubaya/createaccount.dart';
import 'package:greenhouse_ubaya/drawer.dart';
import 'package:greenhouse_ubaya/home.dart';
import 'package:greenhouse_ubaya/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'setting.dart';

String active_user = "",
    email = "",
    nama_depan = "",
    nama_belakang = "",
    avatar = "",
    id_jabatan = "";

Future<String> checkUser() async {
  final prefs = await SharedPreferences.getInstance();
  String _username = prefs.getString("username") ?? '';
  return _username;
}

Future<String> getEmail() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString("email") ?? '';
}

Future<String> getNamaDepan() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString("nama_depan") ?? '';
}

Future<String> getNamaBelakang() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString("nama_belakang") ?? '';
}

Future<String> getAvatar() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString("avatar") ?? '';
}

Future<String> getIdJabatan() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString("jabatan_id") ?? '';
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
  checkUser().then((String result) {
    if (result == '')
      runApp(MyLogin());
    else {
      active_user = result;
    }
  });
  getEmail().then((String result) {
    email = result;
  });
  getNamaDepan().then((String result) {
    nama_depan = result;
  });
  getNamaBelakang().then((String result) {
    nama_belakang = result;
  });
  getAvatar().then((String result) {
    avatar = result;
  });
  getIdJabatan().then((String result) {
    id_jabatan = result;
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
      debugShowCheckedModeBanner: false,
      routes: {
        "home": (context) => MyApp(),
        // "mycreation": (context) => MyCreation(),
        "setting": (context) => Setting(),
        "/addraspi": (context) => AddRaspi(),
        "/account": (context) => AccountList(status: 1),
        "/createaccount": (context) => CreateAccount()
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;

  final List<Widget> _screens = [Home(), AccountList(status: 0)];
  final List<String> _title = [
    'Daftar Raspberry',
    'Daftar Akun',
  ];

  void doLogout() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove("username");
    main();
  }

  Widget myBottomNavBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: _currentIndex,
      fixedColor: Colors.teal,
      items: <BottomNavigationBarItem>[
        const BottomNavigationBarItem(
          label: "Home",
          icon: Icon(Icons.home),
        ),
        const BottomNavigationBarItem(
          label: "Account",
          icon: Icon(Icons.person),
        ),
      ],
      onTap: (int index) {
        setState(() {
          _currentIndex = index;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (id_jabatan == "1") {
      if (MediaQuery.of(context).size.width >= 600) {
        return Scaffold(
            appBar: AppBar(
              title: Text(_title[_currentIndex]),
            ),
            body: _screens[_currentIndex],
            bottomNavigationBar: myBottomNavBar(),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.startFloat,
            floatingActionButton: FloatingActionButton.extended(
              onPressed: () {
                doLogout();
              },
              label: Text("Logout", style: TextStyle(color: Colors.white)),
              icon: const Icon(Icons.logout),
            ));
      } else {
        return Scaffold(
            appBar: AppBar(
              title: Text(_title[_currentIndex]),
            ),
            body: _screens[_currentIndex],
            drawer: MyDrawer());
      }
    } else {
      return Scaffold(
          appBar: AppBar(
            title: Text(_title[_currentIndex]),
          ),
          body: _screens[_currentIndex],
          floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              doLogout();
            },
            label: Text("Logout", style: TextStyle(color: Colors.white)),
            icon: const Icon(Icons.logout),
          ));
    }
  }
}
