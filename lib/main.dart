import 'package:flutter/material.dart';
import 'package:luna_flutter/home.dart';

// 入口
void main() => runApp(App());

class App extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: '课程盒子', // 安卓开任务列表才看得到的值，iOS 看不到这个
      home: HomePage(),
    );
  }

}









