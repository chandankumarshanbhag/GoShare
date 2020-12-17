import 'dart:async';

import 'package:goshare/providers/core_provider.dart';
import 'package:goshare/screens/main_screen.dart';
import 'package:goshare/util/consts.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:page_transition/page_transition.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  startTimeout() {
    return Timer(Duration(seconds: 2), handleTimeout);
  }

  void handleTimeout() {
    changeScreen();
  }

  changeScreen() async {
    PermissionStatus permission = await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.storage);
    if (permission != PermissionStatus.granted) {
      PermissionHandler()
          .requestPermissions([PermissionGroup.storage])
          .then((v) {})
          .then((v) async {
            PermissionStatus permission1 = await PermissionHandler()
                .checkPermissionStatus(PermissionGroup.storage);
            if (permission1 == PermissionStatus.granted) {
              Timer(Duration(seconds: 1), () {
                try {
                  Provider.of<CoreProvider>(context, listen: false)
                      .checkSpace();
                  Navigator.pushReplacement(
                    context,
                    PageTransition(
                      type: PageTransitionType.rightToLeft,
                      child: MainScreen(),
                    ),
                  );
                } catch (e) {
                  print(e);
                }
              });
            }
          });
    } else {
      Navigator.pushReplacement(
        context,
        PageTransition(
          type: PageTransitionType.rightToLeft,
          child: MainScreen(),
        ),
      );
      Provider.of<CoreProvider>(context, listen: false).checkSpace();
    }
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIOverlays([]);
    startTimeout();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
//        mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Feather.folder,
              color: Theme.of(context).accentColor,
              size: 70,
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "${Constants.appName}",
              style: TextStyle(
                color: Theme.of(context).accentColor,
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
