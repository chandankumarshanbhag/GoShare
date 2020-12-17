import 'dart:io';

import 'package:flutter/material.dart';
// import 'package:flutter_p2p/flutter_p2p.dart';
import 'package:get_ip/get_ip.dart';

class Receive extends StatefulWidget {
  @override
  _ReceiveState createState() => _ReceiveState();
}

class _ReceiveState extends State<Receive> {
  Future<bool> _checkPermission() async {
  // if (!await FlutterP2p.isLocationPermissionGranted()) {
  //   // await FlutterP2p.requestLocationPermission();
  //   // return false;
  // }
  return true;
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
      children: <Widget>[
        RaisedButton(
          child: Text("Hello"),
          onPressed: () async {
            // String ipAddress = await GetIp.ipAddress;
            // print(ipAddress);
            // var server =
            //     await HttpServer.bind(InternetAddress.anyIPv4, 8080);
            //     await for (HttpRequest request in server) {

            //   request.response.write('Hello, world!');
            //   await request.response.close();
            // }
          },
        ),
        RaisedButton(
          child: Text("Hello"),
          onPressed: () async {
            String ipAddress = await GetIp.ipAddress;
            print("My IP"+ipAddress);
            // var server =
            //     await HttpServer.bind(InternetAddress.anyIPv4, 8080);
            //     await for (HttpRequest request in server) {

            //   request.response.write('Hello, world!');
            //   await request.response.close();
            // }
          },
        ),
        RaisedButton(
          child: Text("Hello"),
          onPressed: () async {
            String ipAddress = await GetIp.ipAddress;
            _checkPermission();
          },
        )
      ],
    ));
  }
}
