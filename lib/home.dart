
import 'package:flutter/material.dart';
import 'package:luna_flutter/add.dart';
import 'package:luna_flutter/model/course.dart';
import 'package:luna_flutter/record.dart';
import 'package:luna_flutter/util/database.dart';

class HomePage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return HomePageState();
  }
}


class HomePageState extends State<HomePage> {

  List<Course> _courses = [];

  @override
  void initState() {
    super.initState();
    // 官方推荐在这里获取数据，生命周期只运行一次
    _loadData();
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('课程记录'),
      ),

      body: ListView.separated(
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Text(_courses[index].name),
            onLongPress: () {
              _showDeleteCourseAlert(context, index);
            },
            onTap: () {
              _showRecord(context, index);
            },
          );
        },
        separatorBuilder: (BuildContext context, int index) => Divider(),
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
      final c = Course(name: result, sortOrder: 1, createTime: DateTime.now().millisecondsSinceEpoch);
      var db = DatabaseUtil();
      db.insert(c);
      //TODO: 这里可以不用 setState 也可以更改 UI （疑问：可能页面回退，会自动调用更改状态！？）
      _courses.add(c);
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

  void _showRecord(BuildContext context, int index) {

    final course = _courses[index];

    Navigator.push(context, MaterialPageRoute(
      builder: (context) => RecordPage(courseId: course.id,),
    ));
  }

  void _loadData() async {

    final db = DatabaseUtil();
    final resultList = await db.getAll('courses');
    for(var item in resultList) {
      final course = Course.fromMap(item);
      _courses.add(course);
    }

    // 可以不用在 callback 里更改数据，只需调用就可以更改 UI 了
    setState(() {

    });

  }

}