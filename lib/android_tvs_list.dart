// import 'package:flutter/material.dart';
// import 'package:android_flutter_wifi/android_flutter_wifi.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:location/location.dart';
//
// class AndroidTvListScreen extends StatefulWidget {
//   @override
//   _AndroidTvListScreenState createState() => _AndroidTvListScreenState();
// }
//
// class _AndroidTvListScreenState extends State<AndroidTvListScreen> {
//   List<WifiNetwork> _wifiList = [];
//   bool _isLoading = false;
//   ActiveWifiNetwork? _wifiInfo;
//
//   @override
//   void initState() {
//     super.initState();
//     _ensureLocationServiceEnabled();
//   }
//
//   Future<void> _ensureLocationServiceEnabled() async {
//     Location location = Location();
//     bool serviceEnabled = await location.serviceEnabled();
//     if (!serviceEnabled) {
//       serviceEnabled = await location.requestService();
//       if (!serviceEnabled) {
//         print("Location services are disabled.");
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Please enable location services.')),
//         );
//         return;
//       }
//     }
//     // Proceed to fetch data after ensuring location services are enabled
//     await _fetchWifiInfo();
//     await _fetchAndroidTvList();
//   }
//
//   Future<void> _fetchWifiInfo() async {
//     setState(() {
//       _isLoading = true;
//     });
//
//     try {
//       // Request location permission
//       if (await Permission.location.request().isGranted) {
//         print("Initializing Wi-Fi...");
//         bool? isInitialized = await AndroidFlutterWifi.init();
//         if (!isInitialized!) {
//           print("Wi-Fi initialization failed or permission denied.");
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text('Permission denied or initialization failed')),
//           );
//           return;
//         }
//
//         print("Fetching active Wi-Fi info...");
//         ActiveWifiNetwork wifiInfo = await AndroidFlutterWifi.getActiveWifiInfo();
//         print("Active Wi-Fi Info: SSID = ${wifiInfo.ssid}, BSSID = ${wifiInfo.bssid}");
//         setState(() {
//           _wifiInfo = wifiInfo;
//         });
//       } else {
//         print("Location permission denied.");
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Location permission required to fetch Wi-Fi info.')),
//         );
//       }
//     } catch (e) {
//       print("Error fetching Wi-Fi info: $e");
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error fetching Wi-Fi info: $e')),
//       );
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }
//
//   Future<void> _fetchAndroidTvList() async {
//     setState(() {
//       _isLoading = true;
//     });
//
//     try {
//       if (await Permission.location.request().isGranted) {
//         print("Initializing Wi-Fi for scanning...");
//         bool? isInitialized = await AndroidFlutterWifi.init();
//         if (!isInitialized!) {
//           print("Wi-Fi initialization failed or permission denied.");
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text('Permission denied or initialization failed')),
//           );
//           return;
//         }
//
//         print("Scanning for Wi-Fi networks...");
//         List<WifiNetwork> wifiList = await AndroidFlutterWifi.getWifiScanResult();
//
//         print("Found ${wifiList.length} Wi-Fi networks.");
//         // Filter networks by names or identifiers commonly used by Android TVs
//         List<WifiNetwork> tvList = wifiList.where((network) {
//           return network.ssid!.toLowerCase().contains('androidtv') ||
//               network.ssid!.toLowerCase().contains('tv'); // Customize filtering logic
//         }).toList();
//
//         print("Filtered Android TVs: ${tvList.map((e) => e.ssid).toList()}");
//         setState(() {
//           _wifiList = tvList;
//         });
//       } else {
//         print("Location permission denied for Wi-Fi scanning.");
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Location permission required for Wi-Fi scanning.')),
//         );
//       }
//     } catch (e) {
//       print("Error fetching Wi-Fi list: $e");
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error fetching Wi-Fi list: $e')),
//       );
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Android TVs List'),
//       ),
//       body: _isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : _wifiList.isEmpty
//           ?  Center(child: Column(
//             children: [
//               const Text('No Android TVs found\n'),
//               Text('Connected Wifi SSID : ${_wifiInfo!.ssid}'),
//               Text('Connected Wifi IP : ${_wifiInfo!.ip}'),
//               Text('Connected Wifi BSSID : ${_wifiInfo!.bssid}'),
//               Text('Connected Wifi FREQUENCY : ${_wifiInfo!.frequency}'),
//               Text('Connected Wifi NETWORK ID : ${_wifiInfo!.networkId}'),
//               Text('Connected Wifi LINK SPEED : ${_wifiInfo!.linkSpeed}'),
//             ],
//           ))
//           : ListView.builder(
//         itemCount: _wifiList.length,
//         itemBuilder: (context, index) {
//           final wifiNetwork = _wifiList[index];
//           return ListTile(
//             title: Text(wifiNetwork.ssid.toString()),
//             subtitle: Text('Signal Level: ${wifiNetwork.signalLevel}'),
//             trailing: const Icon(Icons.tv, color: Colors.blue),
//             onTap: () {
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(content: Text('Selected TV: ${wifiNetwork.ssid}')),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }
//
//
//
//
// // import 'package:flutter/material.dart';
// // import 'package:android_flutter_wifi/android_flutter_wifi.dart';
// // import 'package:permission_handler/permission_handler.dart';
// // import 'package:location/location.dart';
// // import 'package:ping_discover_network_forked/ping_discover_network_forked.dart';
// //
// // class AndroidTvListScreen extends StatefulWidget {
// //   @override
// //   _AndroidTvListScreenState createState() => _AndroidTvListScreenState();
// // }
// //
// // class _AndroidTvListScreenState extends State<AndroidTvListScreen> {
// //   List<String> _connectedDevices = [];
// //   bool _isLoading = false;
// //   ActiveWifiNetwork? _wifiInfo;
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     _ensureLocationServiceEnabled();
// //   }
// //
// //   Future<void> _ensureLocationServiceEnabled() async {
// //     Location location = Location();
// //     bool serviceEnabled = await location.serviceEnabled();
// //     if (!serviceEnabled) {
// //       serviceEnabled = await location.requestService();
// //       if (!serviceEnabled) {
// //         print("Location services are disabled.");
// //         ScaffoldMessenger.of(context).showSnackBar(
// //           const SnackBar(content: Text('Please enable location services.')),
// //         );
// //         return;
// //       }
// //     }
// //     // Proceed to fetch data after ensuring location services are enabled
// //     await _fetchWifiInfo();
// //     await _fetchConnectedDevices();
// //   }
// //
// //   String convertIntToIp(int ipInt) {
// //     return '${((ipInt >> 24) & 0xFF)}.${((ipInt >> 16) & 0xFF)}.${((ipInt >> 8) & 0xFF)}.${(ipInt & 0xFF)}';
// //   }
// //
// //   Future<void> _fetchWifiInfo() async {
// //     setState(() {
// //       _isLoading = true;
// //     });
// //
// //     try {
// //       final status = await Permission.location.request();
// //       if (status.isGranted) {
// //         bool? isInitialized = await AndroidFlutterWifi.init();
// //         if (isInitialized == true) {
// //           ActiveWifiNetwork wifiInfo = await AndroidFlutterWifi.getActiveWifiInfo();
// //           if (wifiInfo != null && wifiInfo.ip != null) {
// //             String ipAddress = convertIntToIp(int.parse(wifiInfo.ip!)); // Convert the integer IP to a string
// //             setState(() {
// //               wifiInfo.ip = ipAddress;
// //               _wifiInfo = wifiInfo;
// //             });
// //
// //             print("Connected to SSID: ${wifiInfo.ssid}");
// //             print("Converted IP: $ipAddress");
// //           } else {
// //             print("Failed to get active Wi-Fi information.");
// //           }
// //         } else {
// //           print("Wi-Fi initialization failed.");
// //         }
// //       } else {
// //         print("Location permission denied.");
// //         ScaffoldMessenger.of(context).showSnackBar(
// //           const SnackBar(content: Text('Location permission is required.')),
// //         );
// //       }
// //     } catch (e) {
// //       print("Error fetching Wi-Fi info: $e");
// //     } finally {
// //       setState(() {
// //         _isLoading = false;
// //       });
// //     }
// //   }
// //
// //   Future<void> _fetchConnectedDevices() async {
// //     if (_wifiInfo == null || _wifiInfo!.ip == null) return;
// //
// //     final String subnet = _wifiInfo!.ip!.substring(0, _wifiInfo!.ip!.lastIndexOf('.'));
// //     print("Subnet: $subnet");  // Print the subnet to ensure it's being computed correctly
// //
// //     const int port = 80; // Common port for pinging
// //
// //     setState(() {
// //       _isLoading = true;
// //       _connectedDevices.clear();
// //     });
// //
// //     final stream = NetworkAnalyzer.discover(subnet, port);
// //
// //     await for (final device in stream.take(10)) {
// //       print("Discovered device: ${device.ip}"); // Debugging: print discovered devices
// //       if (device.exists) {
// //         setState(() {
// //           _connectedDevices.add(device.ip);
// //         });
// //       }
// //     }
// //
// //     setState(() {
// //       _isLoading = false;
// //     });
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: const Text('Connected Devices'),
// //       ),
// //       body: _isLoading
// //           ? const Center(child: CircularProgressIndicator())
// //           : _wifiInfo == null
// //           ? const Center(child: Text('No Wi-Fi information available'))
// //           : Column(
// //         children: [
// //           const SizedBox(height: 10),
// //           Text('Connected Wi-Fi SSID: ${_wifiInfo!.ssid}'),
// //           Text('Connected Wi-Fi IP: ${_wifiInfo!.ip}'),
// //           const Divider(),
// //           Expanded(
// //             child: _connectedDevices.isEmpty
// //                 ? const Center(child: Text('No devices found on the network.'))
// //                 : ListView.builder(
// //               itemCount: _connectedDevices.length,
// //               itemBuilder: (context, index) {
// //                 return ListTile(
// //                   leading: const Icon(Icons.device_hub),
// //                   title: Text('Device: ${_connectedDevices[index]}'),
// //                 );
// //               },
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }
//
//
//
