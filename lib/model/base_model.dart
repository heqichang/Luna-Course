

abstract class BaseModel {

  String tableName;
  int id; // 主键

  BaseModel();

  void fromMap(Map<String, dynamic> map);

  Map<String, dynamic> toMap();

}