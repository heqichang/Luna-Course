import 'package:flutter/material.dart';


class AddPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return AddPageState();
  }

}


class AddPageState extends State<AddPage> {

  final _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('添加课程'),
      ),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: 80),
          Container(
            padding: EdgeInsets.only(left: 12, right: 12),
            child: TextField(
              decoration: InputDecoration(
                filled: true,
                labelText: '课程名称',
              ),
              controller: _textController,
            ),
          ),
          SizedBox(height: 12),
          ButtonBar(
            children: <Widget>[
              FlatButton(
                child: Text('取消'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),

              RaisedButton(
                child: Text('确认'),
                onPressed: () {
                  Navigator.pop(context, _textController.text);
                },
              ),

            ],
          ),

        ],
      ),
    );
  }

}