// import 'package:android_tv_remote/tv_controls.dart';
// import 'package:flutter/material.dart';
//
// import 'android_tvs_list.dart';
//
// void main() {
//   runApp( const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Android TV Remote',
//       home:  DeviceDiscovery(),
//     );
//   }
// }
//

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DeviceListScreen(),
    );
  }
}

class DeviceListScreen extends StatefulWidget {
  @override
  _DeviceListScreenState createState() => _DeviceListScreenState();
}

class _DeviceListScreenState extends State<DeviceListScreen> {
  static const platform = MethodChannel('com.example.network/devices');
  List<String> devices = [];
  bool isLoading = false;

  Future<void> getDevices() async {
    setState(() => isLoading = true);

    try {
      final List<dynamic> result = await platform.invokeMethod('getDevices');
      setState(() {
        devices = result.map((device) => device.toString()).toList();
      });
    } on PlatformException catch (e) {
      print("Failed to get devices: ${e.message}");
    }

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Devices on Network')),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : devices.isEmpty
          ? Center(
        child: Text('No devices found.'),
      )
          : ListView.builder(
        itemCount: devices.length,
        itemBuilder: (context, index) => ListTile(
          title: Text(devices[index]),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: getDevices,
        child: Icon(Icons.refresh),
      ),
    );
  }
}
