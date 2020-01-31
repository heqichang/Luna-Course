
import 'package:flutter/material.dart';

Future showAlert(BuildContext context, String text) async {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('没有填写课程名称'),
        actions: <Widget>[
          FlatButton(
            child: Text('确定'),
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ],
      );
    },
  );
}
