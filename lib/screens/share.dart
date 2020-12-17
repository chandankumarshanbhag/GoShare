import 'dart:async';
import 'dart:io';

import 'package:goshare/providers/core_provider.dart';
import 'package:goshare/providers/category_provider.dart';
import 'package:goshare/screens/apps_screen.dart';
import 'package:goshare/screens/category.dart';
import 'package:goshare/screens/downloads.dart';
import 'package:goshare/screens/folder.dart';
import 'package:goshare/screens/images.dart';
import 'package:goshare/screens/search.dart';
import 'package:goshare/screens/send.dart';
import 'package:goshare/screens/whatsapp_status.dart';
import 'package:goshare/util/consts.dart';
import 'package:goshare/util/file_utils.dart';
import 'package:goshare/widgets/file_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:page_transition/page_transition.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:goshare/screens/receive.dart';

class Share extends StatelessWidget {
  refresh(BuildContext context) {
    Provider.of<CoreProvider>(context, listen: false).checkSpace();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CoreProvider>(
      builder: (BuildContext context, CoreProvider coreProvider, Widget child) {
        return Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(150),
            child: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.blueGrey[900]
                        : Colors.blueGrey[100],
                    blurRadius: 8.0,
                  ),
                ],
                color: Theme.of(context).backgroundColor,
              ),
              child: AppBar(
                backgroundColor: Theme.of(context).backgroundColor,
                centerTitle: true,
                title: Text(
                  "${Constants.appName}",
                  style: TextStyle(
                    fontSize: 22,
                  ),
                ),
                bottom: PreferredSize(
                  child: Container(
                    margin: EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        OutlineButton.icon(
                            onPressed: () {
                              
                                  Provider.of<CategoryProvider>(context,
                                          listen: false)
                                      .getDocuments("text");
                               Navigator.push(
                                      context,
                                      PageTransition(
                                        type: PageTransitionType.rightToLeft,
                                        child: Send(title: "Send"),
                                      ),
                                    ).then((v) {});
                            },
                            padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                            
                            icon: Icon(Feather.arrow_up_right),
                            shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(30.0)),
                            label: Text("Send")),
                        SizedBox(
                          width: 30,
                        ),
                        OutlineButton.icon(
                            onPressed: () {
                              Navigator.push(
                                      context,
                                      PageTransition(
                                        type: PageTransitionType.rightToLeft,
                                        child: Receive(),
                                      ),
                                    ).then((v) {});
                            },
                            padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                            icon: Icon(Feather.arrow_down_left),
                            shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(30.0)),
                            label: Text("Receive")),
                      ],
                    ),
                  ),
                  preferredSize: Size.fromHeight(80),
                ),
                actions: <Widget>[
                  IconButton(
                    tooltip: "Search",
                    onPressed: () {
                      showSearch(
                        context: context,
                        delegate: Search(
                          themeData: Theme.of(context),
                        ),
                      );
                    },
                    icon: Icon(
                      Feather.search,
                    ),
                  )
                ],
              ),
            ),
          ),
          body: coreProvider.loading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : RefreshIndicator(
                  onRefresh: () => refresh(context),
                  child: ListView(
                    padding: EdgeInsets.only(left: 20),
                    children: <Widget>[
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Received Files".toUpperCase(),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12.0,
                        ),
                      ),
                      Container(
                        height: 100,
                        child: Center(child: Text("No Files"),),
                      ),
                      FlatButton.icon(onPressed: null, icon: Icon(Icons.arrow_drop_down), label: Text("See all")),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Storage Devices".toUpperCase(),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12.0,
                        ),
                      ),
                      coreProvider.loading
                          ? Container(
                              height: 100,
                              child: Center(
                                child: CircularProgressIndicator(),
                              ),
                            )
                          : ListView.separated(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: coreProvider.availableStorage.length,
                              itemBuilder: (BuildContext context, int index) {
                                FileSystemEntity item =
                                    coreProvider.availableStorage[index];

                                String path = item.path.split("Android")[0];
                                double percent = index == 0
                                    ? double.parse((coreProvider.usedSpace /
                                                coreProvider.totalSpace *
                                                100)
                                            .toStringAsFixed(0)) /
                                        100
                                    : double.parse((coreProvider.usedSDSpace /
                                                coreProvider.totalSDSpace *
                                                100)
                                            .toStringAsFixed(0)) /
                                        100;
                                return ListTile(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      PageTransition(
                                        type: PageTransitionType.rightToLeft,
                                        child: Folder(
                                          title:
                                              index == 0 ? "Device" : "SD Card",
                                          path: path,
                                        ),
                                      ),
                                    ).then((v) {});
                                  },
                                  contentPadding: EdgeInsets.only(right: 20),
                                  leading: Container(
                                    height: 40,
                                    width: 40,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Theme.of(context).dividerColor,
                                        width: 2,
                                      ),
                                    ),
                                    child: Center(
                                      child: Icon(
                                        index == 0
                                            ? Feather.smartphone
                                            : Icons.sd_storage,
                                        color: index == 0
                                            ? Colors.lightBlue
                                            : Colors.orange,
                                      ),
                                    ),
                                  ),
                                  title: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                        index == 0 ? "Device" : "SD Card",
                                      ),
                                      Text(
                                        index == 0
                                            ? "${FileUtils.formatBytes(coreProvider.usedSpace, 2)} "
                                                "used of ${FileUtils.formatBytes(coreProvider.totalSpace, 2)}"
                                            : "${FileUtils.formatBytes(coreProvider.usedSDSpace, 2)} "
                                                "used of ${FileUtils.formatBytes(coreProvider.totalSDSpace, 2)}",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 14.0,
                                          color: Theme.of(context)
                                              .textTheme
                                              .title
                                              .color,
                                        ),
                                      ),
                                    ],
                                  ),
                                  subtitle: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10),
                                      ),
                                    ),
                                    child: LinearPercentIndicator(
                                      padding: EdgeInsets.all(0),
                                      backgroundColor: Colors.grey[300],
                                      percent: percent,
                                      progressColor: index == 0
                                          ? Colors.lightBlue
                                          : Colors.orange,
                                    ),
                                  ),
                                );
                              },
                              separatorBuilder:
                                  (BuildContext context, int index) {
                                return Stack(
                                  children: <Widget>[
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: Container(
                                        height: 1,
                                        color: Theme.of(context).dividerColor,
                                        width:
                                            MediaQuery.of(context).size.width -
                                                70,
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          height: 1,
                          color: Theme.of(context).dividerColor,
                          width: MediaQuery.of(context).size.width - 70,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Categories".toUpperCase(),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12.0,
                        ),
                      ),
                      ListView.separated(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: Constants.categories.length,
                        itemBuilder: (BuildContext context, int index) {
                          Map category = Constants.categories[index];

                          return ListTile(
                            onTap: () {
                              if (index == Constants.categories.length - 1) {
                                if (Directory(FileUtils.waPath).existsSync()) {
                                  Navigator.push(
                                    context,
                                    PageTransition(
                                      type: PageTransitionType.rightToLeft,
                                      child: WhatsappStatus(
                                        title: "${category["title"]}",
                                      ),
                                    ),
                                  );
                                } else {
                                  coreProvider.showToast(
                                      "Please Install Whatsapp to use this feature");
                                }
                              } else if (index == 0) {
                                Navigator.push(
                                  context,
                                  PageTransition(
                                    type: PageTransitionType.rightToLeft,
                                    child: Downloads(
                                      title: "${category["title"]}",
                                    ),
                                  ),
                                );
                                Provider.of<CategoryProvider>(context,
                                        listen: false)
                                    .getDownloads();
                              } else if (index == 5) {
                                Navigator.push(
                                  context,
                                  PageTransition(
                                    type: PageTransitionType.rightToLeft,
                                    child: AppScreen(),
                                  ),
                                );
                              } else {
                                Navigator.push(
                                  context,
                                  PageTransition(
                                    type: PageTransitionType.rightToLeft,
                                    child: index == 1 || index == 2
                                        ? Images(
                                            title: "${category["title"]}",
                                          )
                                        : Category(
                                            title: "${category["title"]}",
                                          ),
                                  ),
                                );
                              }

                              Provider.of<CategoryProvider>(context,
                                      listen: false)
                                  .setLoading(true);
                              Timer(Duration(seconds: 1), () {
                                if (index == 1) {
                                  Provider.of<CategoryProvider>(context,
                                          listen: false)
                                      .getImages("image");
                                } else if (index == 2) {
                                  Provider.of<CategoryProvider>(context,
                                          listen: false)
                                      .getImages("video");
                                } else if (index == 3) {
                                  Provider.of<CategoryProvider>(context,
                                          listen: false)
                                      .getAudios("audio");
                                } else if (index == 4) {
                                  Provider.of<CategoryProvider>(context,
                                          listen: false)
                                      .getAudios("text");
                                }
                              });
                            },
                            contentPadding: EdgeInsets.all(0),
                            leading: Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Theme.of(context).dividerColor,
                                  width: 2,
                                ),
                              ),
                              child: Icon(
                                category["icon"],
                                size: 18,
                                color: category["color"],
                              ),
                            ),
                            title: Text(
                              "${category["title"]}",
                            ),
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
                                  width: MediaQuery.of(context).size.width - 70,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          height: 1,
                          color: Theme.of(context).dividerColor,
                          width: MediaQuery.of(context).size.width - 70,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      // Text(
                      //   "Received Files".toUpperCase(),
                      //   style: TextStyle(
                      //     fontWeight: FontWeight.bold,
                      //     fontSize: 12.0,
                      //   ),
                      // ),
                      // ListView.separated(
                      //   padding: EdgeInsets.only(right: 20),
                      //   shrinkWrap: true,
                      //   physics: NeverScrollableScrollPhysics(),
                      //   itemCount: coreProvider.recentFiles.length > 5
                      //       ? 5
                      //       : coreProvider.recentFiles.length,
                      //   itemBuilder: (BuildContext context, int index) {
                      //     FileSystemEntity file =
                      //         coreProvider.recentFiles[index];
                      //     return file.existsSync()
                      //         ? FileItem(
                      //             file: file,
                      //           )
                      //         : SizedBox();
                      //   },
                      //   separatorBuilder: (BuildContext context, int index) {
                      //     return Container(
                      //       height: 1,
                      //       color: Theme.of(context).dividerColor,
                      //     );
                      //   },
                      // ),
                    ],
                  ),
                ),
        );
      },
    );
  }
}
