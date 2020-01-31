import 'package:flutter/material.dart';
import 'package:luna_flutter/model/course.dart';
import 'package:luna_flutter/util/database.dart';
import 'package:luna_flutter/util/util.dart';


class AddPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return AddPageState();
  }

}


class AddPageState extends State<AddPage> {

  final _textController = TextEditingController();
  final _totalTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('添加课程'),
      ),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: 60),
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
          Container(
            padding: EdgeInsets.only(left: 12, right: 12),
            child: TextField(
              decoration: InputDecoration(
                filled: true,
                labelText: '总课时',
              ),
              keyboardType: TextInputType.number,
              controller: _totalTextController,
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
                  _addCourse(context);

                },
              ),

            ],
          ),

        ],
      ),
    );
  }

  void _addCourse(BuildContext context) async {

    final name = _textController.text;

    if (name.trim() == '') {
      await showAlert(context, '没有填写课程名称');
      return;
    }

    final totalText = _totalTextController.text.trim();
    final total = int.tryParse(totalText) ?? 0;

    final course = Course(
      name: name,
      attended: 0,
      total: total,
      sortOrder: 1,
      createTime: DateTime.now().millisecondsSinceEpoch,
    );

    final db = DatabaseUtil();
    final courseId = await db.insert(course);
    course.id = courseId;
    Navigator.pop(context, course);
  }


}