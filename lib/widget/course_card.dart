

import 'package:flutter/material.dart';
import 'package:luna_flutter/model/course.dart';

class CourseCard extends StatelessWidget {

  final Course course;
  final Function onTap;
  final Function onLongPress;

  CourseCard({Key key, @required this.course, this.onTap, this.onLongPress}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return GestureDetector(

      child: Card(
        child: Column(
          children: <Widget>[
            ListTile(
              title: Text(course.name),
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

  Text _timeLabel() {
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

  Text _timeText() {
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


}