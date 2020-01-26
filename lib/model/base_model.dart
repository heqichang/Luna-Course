

abstract class BaseModel {

  String tableName;

  BaseModel();

  void fromMap(Map<String, dynamic> map);

  Map<String, dynamic> toMap();

}