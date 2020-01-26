

import 'package:luna_flutter/model/base_model.dart';

class Course extends BaseModel {

  @override
  String tableName = 'courses';

  int id;
  String name;
  int sortOrder;
  int createTime;

  Course({this.id, this.name, this.sortOrder, this.createTime});

  // 命名构造函数，dart 没有构造函数重载，用的这种方式
  Course.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'];
    sortOrder = map['sort_order'];
    createTime = map['create_time'];
  }

  @override
  void fromMap(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'];
    sortOrder = map['sort_order'];
    createTime = map['create_time'];
  }

  @override
  Map<String, dynamic> toMap() {

    Map<String, dynamic> map = <String, dynamic>{
      'name': name,
      'sort_order': sortOrder,
      'create_time': createTime,
    };

    if (id != null) {
      map['id'] = id;
    }

    return map;
  }

  @override
  String toString() {
    return 'id: $id\nname: $name\norder: $sortOrder\ncreateTime: $createTime';
  }


}