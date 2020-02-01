
import 'package:luna_flutter/model/base_model.dart';

class CourseRecord extends BaseModel {

  @override
  String tableName = 'course_records';

  @override
  int id;

  int courseId;
  int recordTime;
  int status; // 上课状态 0 未上，1 正常，2 补课
  String remark;
  int createTime;

  CourseRecord({this.id, this.courseId, this.recordTime, this.status, this.remark, this.createTime});

  // 命名构造函数，dart 没有构造函数重载，用的这种方式
  CourseRecord.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    courseId = map['course_id'];
    recordTime = map['record_time'];
    status = map['status'];
    remark = map['remark'];
    createTime = map['create_time'];
  }

  @override
  void fromMap(Map<String, dynamic> map) {
    id = map['id'];
    courseId = map['course_id'];
    recordTime = map['record_time'];
    status = map['status'];
    remark = map['remark'];
    createTime = map['create_time'];
  }

  @override
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'course_id': courseId,
      'record_time': recordTime,
      'status': status,
      'remark': remark,
      'create_time': createTime,
    };

    if (id != null) {
      map['id'] = id;
    }

    return map;

  }

}