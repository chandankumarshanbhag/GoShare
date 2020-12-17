import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:device_apps/device_apps.dart';

class AppsList extends StatefulWidget {
  @override
  _AppsState createState() => _AppsState();
}

class _AppsState extends State<AppsList>
    with AutomaticKeepAliveClientMixin<AppsList> {
  @override
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Application>>(
          future: DeviceApps.getInstalledApplications(
            onlyAppsWithLaunchIntent: true,
            includeSystemApps: true,
            includeAppIcons: true,
          ),
          builder: (context, snapshot) {
            return snapshot == null
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : snapshot.hasData
                    ? ListView.separated(
                        padding: EdgeInsets.only(left: 10),
                        itemCount: snapshot.data.length,
                        itemBuilder: (BuildContext context, int index) {
                          Application app = snapshot.data[index];
                          return CheckboxListTile(
                            secondary: app is ApplicationWithIcon
                                ? Image.memory(
                                    app.icon,
                                    height: 40,
                                    width: 40,
                                  )
                                : null,
                            title: Text(
                              app.appName,
                            ),
                            subtitle: Text("${app.packageName}"),
                            value: true,
                            onChanged: (value){},
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return Stack(
                            children: <Widget>[
                              Align(
                                alignment: Alignment.centerRight,
                                child: Container(
                                  height: 1,
                                  color: Theme.of(context).dividerColor,
                                  width: MediaQuery.of(context).size.width - 80,
                                ),
                              ),
                            ],
                          );
                        },
                      )
                    : Center(
                        child: CircularProgressIndicator(),
                      );
          });
  }
}