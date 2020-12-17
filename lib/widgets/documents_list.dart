import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:goshare/providers/category_provider.dart';
import 'package:provider/provider.dart';

class DocumentsList extends StatefulWidget {
  @override
  _AppsState createState() => _AppsState();
}

class _AppsState extends State<DocumentsList>
    with AutomaticKeepAliveClientMixin<DocumentsList> {
  @override
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    return Consumer(builder:
        (BuildContext context, CategoryProvider provider, Widget child) {
      return provider.documentLoading
          ? Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : ListView.separated(
              itemBuilder: (builder, index) {
                return CheckboxListTile(
                  secondary: Icon(Feather.file),
                  title: Text(provider.documents[index].path.toString().split("/").last),
                  value: true,
                  onChanged: (value){},);
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
              itemCount: provider.documents.length);
    });
  }
}
