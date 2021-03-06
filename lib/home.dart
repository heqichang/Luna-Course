
import 'package:flutter/material.dart';
import 'package:luna_flutter/add.dart';
import 'package:luna_flutter/model/course.dart';
import 'package:luna_flutter/record.dart';
import 'package:luna_flutter/util/database.dart';
import 'package:luna_flutter/widget/course_card.dart';

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

      body: ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          return CourseCard(
            course: _courses[index],
            onTap: () {
              _showRecord(context, index);
            },
            onLongPress: () {
//              _showDeleteCourseAlert(context, index);
            },
            editAction: () {
              _editCourse(context, index);
            },
            deleteAction: () {
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

    final result = await Navigator.push(context, MaterialPageRoute(
      builder: (context) => AddPage(),
    ));

    if (result != null) {
      if (result is Course) {
        //TODO: 这里可以不用 setState 也可以更改 UI （疑问：可能页面回退，会自动调用更改状态！？)
        _courses.add(result);
      }
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
                _deleteCourse(index);
              },
            ),
          ],

        );
      }
    );
  }

  void _showRecord(BuildContext context, int index) async {

    final db = DatabaseUtil();
    final course = _courses[index];

    final update = await Navigator.push(context, MaterialPageRoute(
      builder: (context) => RecordPage(courseId: course.id,),
    ));

    print('-----');
    print(update);
    if (update == true) {
      // 最新获取已上课课时
      final attendedCount = await db.getCount('course_records', where: 'course_id = ? and status in (?, ?)', whereArgs: [course.id, 1, 2]);
      print(attendedCount);
      course.attended = attendedCount;
      db.update(course);
      _courses[index] = course;
    }

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

  void _deleteCourse(int index) async {

    final db = DatabaseUtil();
    final course = _courses[index];

    // 异步不用等待
    db.deleteByName('course_records', where: 'course_id = ?', whereArgs: [course.id]);
    db.delete(course);

    _courses.removeAt(index);
    setState(() {

    });
  }

  void _editCourse(BuildContext context, int index) async {

    final course = _courses[index];

    final result = await Navigator.push(context, MaterialPageRoute(
      builder: (context) => AddPage(course: course),
    ));

    if (result != null) {
      _courses[index] = result;
    }
  }

}