// import 'package:flutter/material.dart';
// import 'package:network_info_plus/network_info_plus.dart';
// import 'package:ping_discover_network_forked/ping_discover_network_forked.dart';
// import 'dart:io';
//
// /// Function to scan devices on the current Wi-Fi network.
// Future<List<Map<String, String>>> scanDevices() async {
//
//
//   try {
//     // Step 1: Get the Wi-Fi Gateway IP
//     final info = NetworkInfo();
//    // final info = NetworkInfo();
//     String? gateway = await info.getWifiGatewayIP();
//
//     if (gateway == null || gateway.isEmpty) {
//       throw Exception("Unable to retrieve gateway IP. Ensure you are connected to Wi-Fi.");
//     }
//
//     // Step 2: Calculate subnet (first three octets of the gateway IP)
//     String subnet = gateway.substring(0, gateway.lastIndexOf('.'));
//
//     // Step 3: Discover devices on the network
//     List<Map<String, String>> devices = [];
//
//     // Scan IP range for active devices
//     final stream = NetworkAnalyzer.discover2(
//       subnet,
//       443, // Scan HTTP port first
//       timeout: const Duration(seconds: 5), // Increased timeout for better results
//     );
//
//     // Step 4: Iterate over devices found on the network
//     await for (var device in stream) {
//       if (device.exists) {
//         String? hostName = await getHostName(device.ip);
//         devices.add({
//           "ip": device.ip,
//           "hostName": hostName ?? "Unknown",
//         });
//       }
//     }
//
//     // Optionally, scan additional ports for more devices (e.g., HTTPS port)
//     // final additionalStream = NetworkAnalyzer.discover2(
//     //   subnet,
//     //   443, // Scan HTTPS port
//     //   timeout: const Duration(seconds: 5),
//     // );
//     //
//     // await for (var device in additionalStream) {
//     //   if (device.exists && !devices.any((d) => d['ip'] == device.ip)) {
//     //     String? hostName = await getHostName(device.ip);
//     //     devices.add({
//     //       "ip": device.ip,
//     //       "hostName": hostName ?? "Unknown",
//     //     });
//     //   }
//     // }
//
//     return devices;
//   } catch (e) {
//     print("Error during device scanning: $e");
//     return [];
//   }
// }
//
// /// Helper function to resolve hostname from IP address.
// Future<String?> getHostName(String ip) async {
//   try {
//     final host = await InternetAddress(ip).reverse();
//     return host.host;
//   } catch (e) {
//     return null;
//   }
// }
//
// class DeviceDiscovery extends StatefulWidget {
//   @override
//   _DeviceDiscoveryState createState() => _DeviceDiscoveryState();
// }
//
// class _DeviceDiscoveryState extends State<DeviceDiscovery> {
//   List<Map<String, String>> devices = [];
//   bool isLoading = true;
//
//   @override
//   void initState() {
//     super.initState();
//     _fetchDevices();
//   }
//
//   void _fetchDevices() async {
//     List<Map<String, String>> foundDevices = await scanDevices();
//     setState(() {
//       devices = foundDevices;
//       isLoading = false;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Connected Devices")),
//       body: isLoading
//           ? Center(child: CircularProgressIndicator())
//           : devices.isEmpty
//           ? Center(child: Text("No devices found."))
//           : ListView.builder(
//         itemCount: devices.length,
//         itemBuilder: (context, index) {
//           return ListTile(
//             title: Text(devices[index]["hostName"] ?? "Unknown"),
//             subtitle: Text(devices[index]["ip"] ?? ""),
//           );
//         },
//       ),
//     );
//   }
// }
