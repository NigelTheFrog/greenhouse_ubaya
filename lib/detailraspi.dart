import 'package:flutter/material.dart';
import 'package:greenhouse_ubaya/home.dart';
import 'package:greenhouse_ubaya/sensorlist.dart';
import 'package:greenhouse_ubaya/troubleshootlist.dart';

class DetailRaspi extends StatefulWidget {
  String raspberry_id;

  DetailRaspi({super.key, required this.raspberry_id});
  @override
  State<StatefulWidget> createState() {
    return _DetailRaspiState();
  }
}

class _DetailRaspiState extends State<DetailRaspi> {
  int _currentIndex = 0;

  List<Widget> _screens = [];
  List<String> _title = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    raspberry_id = widget.raspberry_id;
    _screens = [
      SensorList(raspberry_id: raspberry_id),
      TroubleShootList(raspberry_id: raspberry_id)
    ];
    _title = ['Daftar Sensor', 'Troubleshoot'];
  }

  Widget myBottomNavBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: _currentIndex,
      fixedColor: Colors.teal,
      items: <BottomNavigationBarItem>[
        const BottomNavigationBarItem(
          label: "Daftar Sensor",
          icon: Icon(Icons.sensors),
        ),
        const BottomNavigationBarItem(
          label: "Troubleshoot",
          icon: Icon(Icons.warning),
        )
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
    return Scaffold(
      appBar: AppBar(
        title: Text(_title[_currentIndex]),
        leading: BackButton(
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: myBottomNavBar(),
    );
  }
}
