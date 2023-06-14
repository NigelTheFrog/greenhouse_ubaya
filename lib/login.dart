import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:greenhouse_ubaya/lupapassword.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'main.dart';

class MyLogin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Login(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Login extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginState();
  }
}

class _LoginState extends State<Login> {
  String _username = "", _password = "", error_login = "", _email = "";
  double height = 101;
  int status = 0, countWrong = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _username = "";
  }

void doLoginUser() async {
  final response = await http.post(
      Uri.parse("https://ubaya.fun/flutter/160419017/images/account/login-account.php"),
      body: {'username': _username});
  if (response.statusCode == 200) {
    Map json = jsonDecode(response.body);
    if (json['result'] == 'success') {
      _username = json['data']['username'];
      _email = json['data']['email'];
      final prefs = await SharedPreferences.getInstance();
      if (json['data']['status'] == 1) {
        setState(() {
          error_login = "";
          height = 150;
          status = 1;
          textInputPassword = TextField(
            onChanged: (value) {
              _password = value;
            },
            obscureText: true,
            decoration: InputDecoration(
                labelText: 'Password', hintText: 'Isikan password'),
            enabled: status == 1 ? true : false,
          );
        });
      } else if (json['data']['status'] == 0) {
        setState(() {
          error_login = "Akun telah diblokir silahkan tekan ganti password";
          status = 2;
        });
      }
    } else {
      setState(() {
        error_login = "Username tidak ditemukan";
      });
    }
  } else {
    setState(() {
      error_login = "Periksa kembali koneksi anda";
    });
  }
}

  void doChangeAccountStatus() async {
    final response = await http.post(
        Uri.parse(
            "https://ubaya.fun/flutter/160419017/images/account/ubahstatusakun.php"),
        body: {'username': _username});
    if (response.statusCode == 200) {
      Map json = jsonDecode(response.body);
      if (json['result'] == 'success') {
        if (!mounted) return;
      }
    }
  }

  void doLoginPassword() async {
    final response = await http.post(
        Uri.parse(
            "https://ubaya.fun/flutter/160419017/images/account/login-password.php"),
        body: {'username': _username, 'password': _password});
    if (response.statusCode == 200) {
      Map json = jsonDecode(response.body);
      if (json['result'] == 'success') {
        final prefs = await SharedPreferences.getInstance();
        prefs.setString("username", json['data']['username']);
        prefs.setString("email", json['data']['email']);
        prefs.setString("nama_depan", json['data']['nama_depan']);
        prefs.setString("nama_belakang", json['data']['nama_belakang']);
        prefs.setString("avatar", json['data']['avatar']);
        prefs.setString("jabatan_id", json['data']['jabatan_id'].toString());
        main();
      } else {
        setState(() {
          countWrong += 1;
          int countChance = 4 - countWrong;
          error_login =
              "Password salah, kesempatan anda $countChance kali lagi";
          if (countWrong == 4) {
            setState(() {
              status = 2;
              error_login = "Akun telah diblokir silahkan ganti password";
              doChangeAccountStatus();
            });
          }
        });
      }
    } else {
      setState(() {
        error_login = "Periksa kembali koneksi anda";
      });
    }
  }

  Widget textInputPassword = Text("");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Login'), 
        ),
        body: Container(
            alignment: Alignment.topCenter,
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
                child: Column(children: [
              Padding(
                  padding: EdgeInsets.all(10),
                  child: Container(
                      height: 300,
                      width: 300,
                      child: Image.asset(
                        "assets/images/logoUbaya200.png",
                      ))),
              Padding(
                  padding: EdgeInsets.all(10),
                  child: const Text("Smart Gardening Application",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 25))),
              Container(
                  width: 340,
                  height: height,
                  padding: EdgeInsets.all(10),
                  child: Column(children: [
                    TextField(
                      onChanged: (value) {
                        setState(() {
                          _username = value;
                        });
                      },
                      decoration: const InputDecoration(
                          labelText: 'Username',
                          hintText: 'Isikan username (sNRP / NPK)'),
                      enabled: status == 0 ? true : false,
                    ),
                    textInputPassword
                  ])),
              if (error_login != "")
                Text(error_login, style: TextStyle(color: Colors.red)),
              Padding(
                  padding: const EdgeInsets.all(10),
                  child: Container(
                    height: 50,
                    width: 320,
                    decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(20)),
                    child: ElevatedButton(
                      onPressed: () {
                        if (status == 0)
                          doLoginUser();
                        else if (status == 1) {
                          doLoginPassword();
                        } else {
                          setState(() {
                            status = 0;
                            error_login = "";
                            height = 100;
                            textInputPassword = Text("");
                          });

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LupaPassword(
                                username: _username,
                                email: _email,
                              ),
                            ),
                          );
                        }
                      },
                      child: status == 0
                          ? Text(
                              'Next',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            )
                          : status == 1
                              ? Text(
                                  'Login',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16),
                                )
                              : Text(
                                  'Ganti Password',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16),
                                ),
                    ),
                  )),
            ]))));
  }
}
