import 'package:flutter/material.dart';
import 'package:greenhouse_ubaya/logchart.dart';
import 'package:greenhouse_ubaya/loglist.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DetailSensor extends StatefulWidget {
  String sensor_id,
      nama_sensor,
      port_sensor,
      nama_aktuator,
      port_aktuator,
      satuan,
      toleransi;
  DetailSensor(
      {super.key,
      required this.sensor_id,
      required this.nama_sensor,
      required this.port_sensor,
      required this.nama_aktuator,
      required this.satuan,
      required this.toleransi,
      required this.port_aktuator});
  @override
  State<StatefulWidget> createState() {
    return _DetailSensorState();
  }
}

class _DetailSensorState extends State<DetailSensor> {
  int _currentIndex = 0;
  

  List<Widget> _screens = [];
  List<String> _title = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _screens = [
      LogList(
        sensor_id: widget.sensor_id,
        nama_sensor: widget.nama_sensor,
        port_sensor: widget.port_sensor,
        nama_aktuator: widget.nama_aktuator,
        port_aktuator: widget.port_aktuator,
        satuan: widget.satuan,
        toleransi: widget.toleransi,
      ),
      LogChart(
        sensor_id: widget.sensor_id,
        nama_sensor: widget.nama_sensor,
        port_sensor: widget.port_sensor,
        nama_aktuator: widget.nama_aktuator,
        port_aktuator: widget.port_aktuator,
        satuan: widget.satuan,
        toleransi: widget.toleransi,
      )
    ];
    _title = ['Daftar Log', 'Log Chart'];
  }

  Widget myBottomNavBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: _currentIndex,
      fixedColor: Colors.teal,
      items: <BottomNavigationBarItem>[
        const BottomNavigationBarItem(
          label: "Daftar Log",
          icon: Icon(Icons.table_rows),
        ),
        const BottomNavigationBarItem(
          label: "Log Chart",
          icon: Icon(Icons.show_chart),
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
        ),
        body: _screens[_currentIndex],
        bottomNavigationBar: myBottomNavBar());
  }
}
