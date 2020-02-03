
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:luna_flutter/model/course_record.dart';
import 'package:luna_flutter/util/database.dart';

// 对于没有交互 UI 变化的可以用 StatelessWidget 更有效率
class AddRecordPage extends StatefulWidget {

  final int courseId;
  final CourseRecord record;

  AddRecordPage({Key key, @required this.courseId, this.record}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return AddRecordPageState();
  }

}

class AddRecordPageState extends State<AddRecordPage> {

  int _recordTime;
  int _recordStatus;
  final _textController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // 初始化
    _recordStatus = 1; // 大部分时间是已上
    _recordTime = DateTime.now().millisecondsSinceEpoch;

    if (widget.record != null) {
      _recordTime = widget.record.recordTime;
      _recordStatus = widget.record.status;
      _textController.text = widget.record.remark ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('添加记录'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: 60,),
          GestureDetector(
            onTap: () {
              _showCalendar(context);
            },
            child: Container(
              color: Colors.grey,
              padding: const EdgeInsets.all(8),
              child: _timeText(),
            ),
          ),
          SizedBox(height: 12,),
          Container(
            padding: EdgeInsets.only(left: 12, right: 12),
            child: TextField(
              decoration: InputDecoration(
                filled: true,
                labelText: '备注',
              ),
              controller: _textController,
              maxLines: 3,
            ),
          ),
          SizedBox(height: 12),
          _statusButtons(),
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
                  _submit(context);
                },
              ),

            ],
          ),
        ],
      ),
    );
  }

  Text _timeText() {

    DateTime time = DateTime.fromMillisecondsSinceEpoch(_recordTime);
    DateFormat format = DateFormat('yyyy-MM-dd');
    String text = format.format(time);

    return Text(
      text,
      style: TextStyle(
        color: Colors.black,
        fontSize: 18.0,
      ),
    );

  }

  Widget _statusButtons() {

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[

        OutlineButton.icon(
          onPressed: () {
            setState(() {
              _recordStatus = 1;
            });
          },
          icon: _recordStatus == 1 ? Icon(Icons.check_box) : Icon(Icons.check_box_outline_blank),
          label: Text('已上'),
        ),
        OutlineButton.icon(
          onPressed: () {
            setState(() {
              _recordStatus = 2;
            });
          },
          icon: _recordStatus == 2 ? Icon(Icons.check_box) : Icon(Icons.check_box_outline_blank),
          label: Text('补课'),
        ),
        OutlineButton.icon(
          onPressed: () {
            setState(() {
              _recordStatus = 0;
            });
          },
          icon: _recordStatus == 0 ? Icon(Icons.check_box) : Icon(Icons.check_box_outline_blank),
          label: Text('未上'),
        ),
      ],

    );

  }


  void _showCalendar(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2018),
        lastDate: DateTime(2030));

    if (picked != null && picked.millisecondsSinceEpoch != _recordTime) {
      setState(() {
        _recordTime = picked.millisecondsSinceEpoch;
      });
    }
  }

  void _submit(BuildContext context) async {

    if (widget.record != null) {
      // 更新
      final record = widget.record;
      record.recordTime = _recordTime;
      record.remark = _textController.text;

      final db = DatabaseUtil();
      await db.update(record);

      Navigator.pop(context, {'status': 'update', 'data': record});

    } else {
      // 新增
      if (_recordTime == null) {
        await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('没有选择时间'),
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
      } else {

        var record = CourseRecord(
          courseId: widget.courseId,
          recordTime: _recordTime,
          status: _recordStatus,
          remark: _textController.text,
          createTime: DateTime.now().millisecondsSinceEpoch,
        );

        final db = DatabaseUtil();
        final recordId = await db.insert(record);
        record.id = recordId;


        Navigator.pop(context, {'status': 'add', 'data': record});
      }
    }

  }


}



