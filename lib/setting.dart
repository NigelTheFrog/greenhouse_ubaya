import 'dart:convert';
//import 'dart:js';
import 'dart:io';
import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:greenhouse_ubaya/main.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';

import 'login.dart';

File? _image;
File? _imageProses;
String user_id = "",
    user_name = "",
    first_name = "",
    last_name = "",
    avatar = "",
    regis_date = "",
    private = "false";
bool isChecked = false;

class Setting extends StatefulWidget {
  @override
  SettingState createState() {
    return SettingState();
  }
}

class SettingState extends State<Setting> {
  final _formKey = GlobalKey<FormState>();
  void changeAccount() async {
    final response = await http.post(
        Uri.parse("https://ubaya.fun/flutter/160419017/updateaccount.php"),
        body: {
          'user_id': user_id,
          'user_name': user_name,
          'first_name': first_name,
          'last_name': last_name,
          'avatar': avatar,
          'private': private
        });
    if (response.statusCode == 200) {
      Map json = jsonDecode(response.body);
      if (json['result'] == 'success') {
        final prefs = await SharedPreferences.getInstance();
        
        prefs.setString("user_name", user_name);
        prefs.setString("first_name", first_name);
        prefs.setString("last_name", last_name);
        prefs.setString("avatar", avatar);
        prefs.setString("private", private);
      }
    } else {
      throw Exception('Failed to read API');
    }
  }

  void doLogout() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove("user_id");
    prefs.remove("user_name");
    prefs.remove("first_name");
    prefs.remove("last_name");
    prefs.remove("avatar");
    prefs.remove("private");
    main();
  }

  _loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      user_id = (prefs.getString("user_id") ?? '');
      user_name = (prefs.getString("user_name") ?? '');
      first_name = (prefs.getString("first_name") ?? '');
      last_name = (prefs.getString("last_name") ?? '');
      avatar = (prefs.getString("avatar") ?? '');

      private = (prefs.getString("private") ?? '');
      regis_date = (prefs.getString("regis_date") ?? '');

      _user_name.text = user_name;
      _first_name.text = first_name;
      _last_name.text = last_name;

      if (private == "true") {
        isChecked = true;
      } else if (private == "false") {
        isChecked = false;
      }
    });
  }


  submitGambar() async {}

  // void prosesFoto() {
  //   Future<Directory?> extDir = getTemporaryDirectory();
  //   extDir.then((value) {
  //     String _timestamp = DateTime.now().millisecondsSinceEpoch.toString();
  //     final String filePath =
  //         '"https://ubaya.fun/flutter/160419017/images/${user_id}.jpg"';
  //     _imageProses = File(filePath);
  //     img.Image? temp = img.readJpg(_image!.readAsBytesSync());
  //     img.Image temp2 = img.copyResize(temp!, width: 480, height: 640);
  //     img.drawString(temp2, img.arial_24, 4, 4, 'Uas Flutter',
  //         color: img.getColor(250, 100, 100));
  //     setState(() {
  //       _imageProses?.writeAsBytesSync(img.writeJpg(temp2));
  //     });
  //   });
  // }

  TextEditingController _user_name = TextEditingController();
  TextEditingController _first_name = TextEditingController();
  TextEditingController _last_name = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadData();
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              color: Colors.white,
              child: new Wrap(
                children: <Widget>[
                  ListTile(
                      tileColor: Colors.white,
                      leading: Icon(Icons.photo_library),
                      title: Text('Gallery'),
                      onTap: () {

                      }),
                  new ListTile(
                    leading: Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {

                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              doLogout();
            },
            child: const Icon(Icons.logout),
            backgroundColor: Colors.orange),
        appBar: AppBar(
          title: Text('Setting'),
        ),
        body: Form(
            key: _formKey,
            child: SingleChildScrollView(
                child: Container(
                    margin: const EdgeInsets.all(20),
                    padding: const EdgeInsets.all(20),
                    child: Column(children: [
                      Padding(
                          padding: const EdgeInsets.all(10),
                          child: GestureDetector(
                            onTap: () {
                              _showPicker(context);
                            }, // Image tapped
                            child: CircleAvatar(backgroundImage: NetworkImage(avatar), radius: 100)
                          )),
                      Padding(
                          padding: const EdgeInsets.all(10),
                          child: Text(first_name + last_name)),
                      Padding(
                          padding: const EdgeInsets.all(10),
                          child: Text("Active since " + regis_date)),
                      Padding(
                          padding: const EdgeInsets.all(10),
                          child: Text(user_id)),
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: TextFormField(
                          onChanged: (value) {
                              user_name = value;
                          },
                          controller: _user_name,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'username tidak boleh kosong';
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                              labelText: 'user_name',
                              hintText: 'user_name will be shown in public'),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: TextFormField(
                          onChanged: (value) {
                              first_name = value;
                          },
                          controller: _first_name,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Nama depan tidak boleh kosong';
                            }
                            return null;
                          },
                          decoration:
                              const InputDecoration(labelText: 'First Name'),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: TextField(
                          onChanged: (value) {
                              last_name = value;
                          },
                          controller: _last_name,
                          decoration:
                              const InputDecoration(labelText: 'Last Name'),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: Row(children: [
                          Checkbox(
                            checkColor: Colors.white,
                            activeColor: Colors.blue,
                            value: isChecked,
                            onChanged: (bool? value) {
                              setState(() {
                                if (value == true) {
                                  private = "true";
                                  isChecked = true;
                                } else if (value == false) {
                                  private = "false";
                                  isChecked = false;
                                }
                              });
                            },
                          ),
                          Text("Hide my name")
                        ]),
                      ),
                      Padding(
                          padding: const EdgeInsets.all(10),
                          child: Container(
                            height: 50,
                            width: 300,
                            decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(20)),
                            child: ElevatedButton(
                              onPressed: () {
                                  changeAccount();
                              },
                              child: const Text(
                                'Save Changes',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                            ),
                          )),
                    ])))));
  }
}
