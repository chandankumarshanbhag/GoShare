import 'dart:io';

import 'package:goshare/util/consts.dart';
import 'package:goshare/util/file_utils.dart';
import 'package:goshare/widgets/video_thumbnail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mime_type/mime_type.dart';
import 'package:open_file/open_file.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:goshare/providers/category_provider.dart';
import 'package:goshare/widgets/apps_list.dart';
import 'package:goshare/widgets/documents_list.dart';

class Send extends StatelessWidget {
  final String title;

  Send({
    Key key,
    @required this.title,
  }) : super(key: key);
  List<FileSystemEntity> files = Directory(FileUtils.waPath).listSync()
    ..removeWhere((f) => basename(f.path).split("")[0] == ".");

  @override
  Widget build(BuildContext context) {
    return Consumer(builder:
        (BuildContext context, CategoryProvider provider, Widget child) {
      return DefaultTabController(
          length: 6,
          child: Scaffold(
              appBar: AppBar(
                title: Text(
                  "$title",
                ),
                bottom: TabBar(
                  isScrollable: true,
                    indicatorColor: Theme.of(context).accentColor,
                    labelColor: Theme.of(context).accentColor,
                    unselectedLabelColor:
                        Theme.of(context).textTheme.caption.color,
                    tabs: [
                      Tab(text: "Apps"),
                      Tab(text: "Documents"),
                      Tab(text: "Video"),
                      Tab(text: "Image"),
                      Tab(text: "Audio"),
                      Tab(text: "Files"),
                    ]),
              ),
              body: TabBarView(
                children: <Widget>[
                  AppsList(),
                  DocumentsList(),
                  Container(),
                  Container(),
                  Container(),
                  Container()
                ],
              )));
    });
  }
}






