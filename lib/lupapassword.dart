import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sendgrid_mailer/sendgrid_mailer.dart';

import 'main.dart';

class LupaPassword extends StatefulWidget {
  String username, email;
  LupaPassword({super.key, required this.username, required this.email});
  @override
  State<StatefulWidget> createState() {
    return _LupaPasswordState();
  }
}

class _LupaPasswordState extends State<LupaPassword> {
  String _password = "", error_verif = "", _nomorTelepon = "";
  double height = 56;
  int status = 0, randomNumber = 0, kodeverif = 0, hitung = 30;
  bool isrunning = false;
  late Timer _timer;

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  void submit() async {
    if (kodeverif == randomNumber) {
      final response = await http.post(
          Uri.parse(
              "https://ubaya.fun/flutter/160419017/images/account/ubahpassword.php"),
          body: {'username': widget.username, 'password': _password});
      if (response.statusCode == 200) {
        Map json = jsonDecode(response.body);
        if (json['result'] == 'success') {
          _timer.cancel();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content:
                  Text("Password telah diubah, silahkan lakukan login kembali"),
            ),
          );
          Navigator.pop(context);
        }
      }
    } else {
      showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Kode Verifikasi tidak sesuai'),
            content: const SingleChildScrollView(
                child: Text(
                    "Pastikan Kode Verifikasi Anda sesuai dengan yang dikirim melalui email")),
            actions: <Widget>[
              TextButton(
                child: const Text('Ok'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  void generateTimer() async {
    hitung = 60;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        hitung--;
        textCountDown = Text(
          "Kode verifikasi berlaku hingga $hitung detik lagi",
          style: TextStyle(color: Colors.red),
        );
        if (hitung == 0) {
          _timer.cancel();
          status = 0;
          textCountDown = Text(
            "Waktu kode verifikasi anda telah habis, silahkan tekan generate ulang",
            style: TextStyle(color: Colors.red),
            textAlign: TextAlign.center,
          );
        }
      });
    });
  }

  void doGenerateKode() async {
    randomNumber = 10000000 + Random().nextInt(99999999 - 10000000);
    final mailer = Mailer(
        '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');
    final toAddress = Address(widget.email);
    final fromAddress = Address('greenhouse.ubaya.017@gmail.com');
    final content = Content('text/plain',
        'Berikut kami kirimkan kode verifikasi untuk perubahan password \n\n$randomNumber \n\nBila Anda tidak melakukan permintaan perubahan password, harap segera menghubungi admin \nRegards,\n\nNigel Kislew William\n160419017');
    final subject = 'Kode Verifikasi Perubahan Password';
    final personalization = Personalization([toAddress]);

    final email =
        Email([personalization], fromAddress, subject, content: [content]);

    mailer.send(email).then((result) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              "Email telah dikirimkan menuju ${widget.email}, harap cek email anda"),
        ),
      );
    });

    generateTimer();

    setState(() {
      status = 1;
      height = 150;
      textInputKodeVerifikasi = TextField(
        keyboardType: TextInputType.number,
        onChanged: (value) {
          setState(() {
            kodeverif = int.parse(value);
          });
        },
        decoration: const InputDecoration(
            labelText: 'Kode Verifikasi',
            hintText: 'Kode Verifikasi ada pada email anda'),
        enabled: status == 1 ? true : false,
      );
      textInputPassword = TextField(
          obscureText: true,
          onChanged: (value) {
            setState(() {
              _password = value;
            });
          },
          decoration: const InputDecoration(
              labelText: 'Password', hintText: 'Isikan password baru anda'),
          enabled: true);
    });
  }

  Widget textInputKodeVerifikasi = Text("");
  Widget textInputPassword = Text("");
  Widget textCountDown = Text("");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Ubah Password'),
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
                    textInputKodeVerifikasi,
                    // TextField(
                    //   onChanged: (value) {
                    //     setState(() {
                    //       _nomorTelepon = "";
                    //     });
                    //   },
                    //   decoration: const InputDecoration(
                    //       labelText: 'Nomor Telepon',
                    //       hintText: 'Isikan Nomor Telepon'),
                    //   enabled: status == 0 ? true : false,
                    // ),
                    textInputPassword
                  ])),
              if (error_verif != "")
                Text(error_verif, style: TextStyle(color: Colors.red)),
              textCountDown,
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
                          if (status == 0) {
                            doGenerateKode();
                          } else if (status == 1) {
                            submit();
                          } else {}
                        },
                        child: status == 0
                            ? Text(
                                'Generate Kode',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              )
                            : Text(
                                'Ganti Password',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              )),
                  )),
            ]))));
  }
}
