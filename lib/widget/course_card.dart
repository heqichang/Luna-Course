

import 'package:flutter/material.dart';
import 'package:luna_flutter/model/course.dart';

enum CourseItemAction { edit, delete }

class CourseCard extends StatelessWidget {

  final Course course;
  final Function onTap;
  final Function onLongPress;
  final Function editAction;
  final Function deleteAction;

  CourseCard({Key key, @required this.course, this.onTap, this.onLongPress, this.editAction, this.deleteAction}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return GestureDetector(

      child: Card(
        child: Column(
          children: <Widget>[
            ListTile(
              title: Text(course.name),
              trailing: _popupMenuButton(),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                _timeLabel(),
                SizedBox(width: 12,)
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                _timeText(),
                SizedBox(width: 12,)
              ],
            ),
            SizedBox(height: 12,)
          ],

        ),
      ),
      onTap: () {
        if (onTap != null) {
          onTap();
        }
      },
      onLongPress: () {
        if (onLongPress != null) {
          onLongPress();
        }
      },
    );

  }

  Widget _timeLabel() {
    String label;
    if (course.total == 0) {
      label = '已上课时';
    } else {
      label = '已上课时/总课时';
    }

    return Text(
      label,
    );
  }

  Widget _timeText() {
    String text;
    if (course.total == 0) {
      text = course.attended.toString();
    } else {
      text = '${course.attended}/${course.total}';
    }

    return Text(
      text,
    );
  }

  Widget _popupMenuButton() {

    return PopupMenuButton<CourseItemAction> (
      onSelected: (CourseItemAction action) {
        switch (action) {
          case CourseItemAction.edit:
            editAction();
            break;
          case CourseItemAction.delete:
            deleteAction();
            break;
          default:
            break;
        }
      },
      icon: Icon(Icons.more_vert),
      itemBuilder: (BuildContext context) => <PopupMenuEntry<CourseItemAction>> [
        const PopupMenuItem<CourseItemAction>(
          value: CourseItemAction.edit,
          child: Text('编辑'),
        ),
        const PopupMenuItem<CourseItemAction>(
          value: CourseItemAction.delete,
          child: Text('删除'),
        ),
      ],
    );

  }



}