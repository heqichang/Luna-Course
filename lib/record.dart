
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:luna_flutter/add_record.dart';
import 'package:luna_flutter/model/course_record.dart';
import 'package:luna_flutter/util/database.dart';

class RecordPage extends StatefulWidget {

  final int courseId;

  RecordPage({Key key, @required  this.courseId}): super(key: key);

  @override
  State<StatefulWidget> createState() {
    return RecordPageState();
  }
}


class RecordPageState extends State<RecordPage> {

  List<CourseRecord> _records = [];
  bool _courseUpdate = false; // 是否需要刷新首页上课课时

  @override
  void initState() {

    super.initState();
    _loadData();
  }

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop(_courseUpdate);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('详细记录'),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _addRecord(context);
          },
          tooltip: '添加记录',
          child: const Icon(Icons.add),
        ),
        body: ListView.separated(
          itemCount: _records.length,
          separatorBuilder: (BuildContext context, int index) => Divider(),
          itemBuilder: (BuildContext context, int index) {

            return Dismissible(
              child: ListTile(
                title: _recordText(index),
                onTap: () {
                  _updateRecord(index);
                },
              ),
              onDismissed: (_) {
                _delete(index);
              },
              key: Key(_records[index].id.toString()),
            );

          },
        ),
      ),
    );

//    return Scaffold(
//      appBar: AppBar(
//        title: const Text('详细记录'),
//      ),
//      floatingActionButton: FloatingActionButton(
//        onPressed: () {
//          _addRecord(context);
//        },
//        tooltip: '添加记录',
//        child: const Icon(Icons.add),
//      ),
//      body: ListView.separated(
//        itemCount: _records.length,
//        separatorBuilder: (BuildContext context, int index) => Divider(),
//        itemBuilder: (BuildContext context, int index) {
//
//          return Dismissible(
//            child: ListTile(
//              title: _recordText(index),
//              onTap: () {
//                _updateRecord(index);
//              },
//            ),
//            onDismissed: (_) {
//              _delete(index);
//            },
//            key: Key(_records[index].id.toString()),
//          );
//
//        },
//      ),
//    );
  }

  void _addRecord(BuildContext context) async {

    final result = await Navigator.push(context, MaterialPageRoute(
      builder: (context) => AddRecordPage(courseId: widget.courseId,),
    ));

    if (result != null) {

      if (result['status'] == 'add') {
        final record = result['data'] as CourseRecord;
        if (_records.length == 0) {
          // 没有记录时
          _records.add(record);
        } else {
          // 有记录时
          var isInsert = false;
          for (var i = _records.length - 1; i >= 0; i--) {
            if (record.recordTime >= _records[i].recordTime) {
              _records.insert(i + 1, record);
              isInsert = true;
              break;
            }
          }
          // 比所有的日期都小
          if (isInsert == false) {
            _records.insert(0, record);
          }
        }

        _courseUpdate = true;
      }

    }
  }

  void _loadData() async {

    final db = DatabaseUtil();
    final list = await db.get(
      'course_records',
      where: 'course_id = ?',
      whereArgs: [widget.courseId],
      orderBy: 'record_time',
    );

    for (var item in list) {
      var record = CourseRecord.fromMap(item);
      _records.add(record);
    }

    setState(() {

    });
  }

  void _delete(int index) async {
    final db = DatabaseUtil();
    var record = _records[index];
    db.delete(record);
    _records.removeAt(index);
    _courseUpdate = true;

    setState(() {

    });
  }

  void _updateRecord(int index) async {
    final result = await Navigator.push(context, MaterialPageRoute(
      builder: (context) => AddRecordPage(courseId: widget.courseId, record: _records[index],),
    ));

    if (result != null) {

      if (result['status'] == 'update') {
        final record = result['data'] as CourseRecord;
        _records[index] = record;
        _records.sort((a, b) {
          return a.recordTime - b.recordTime;
        });
      }
    }
  }

  Text _recordText(int index) {
    DateTime time = DateTime.fromMillisecondsSinceEpoch(_records[index].recordTime);
    DateFormat format = DateFormat('yyyy-MM-dd');
    return Text(
      format.format(time),
    );
  }

}