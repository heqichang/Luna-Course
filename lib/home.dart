
import 'package:flutter/material.dart';
import 'package:luna_flutter/add.dart';

class HomePage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return HomePageState();
  }
}


class HomePageState extends State<HomePage> {

  var _courses = [];

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('课程记录'),
      ),

      body: ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Text(_courses[index] + ' $index'),
            onLongPress: () {
              _showDeleteCourseAlert(context, index);
            },
          );
        },
        itemCount: _courses.length,
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addCourse(context);
        },
        tooltip: '添加课程',
        child: const Icon(Icons.add),
      ),
    );
  }

  void _addCourse(BuildContext context) async {
    // 通过更改状态来更新 UI
//    setState(() {
//      _courses.add('test');
//    });
    final result = await Navigator.push(context, MaterialPageRoute(
      builder: (context) => AddPage(),
    ));

    if (result != null) {
      _courses.add(result);
    }

  }

  void _showDeleteCourseAlert(BuildContext context, int index) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('确认删除该课程吗？'),
          actions: <Widget>[
            FlatButton(
              child: Text('取消'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            RaisedButton(
              child: Text('确认'),
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  _courses.removeAt(index);
                });
              },
            ),
          ],

        );
      }
    );
  }

}