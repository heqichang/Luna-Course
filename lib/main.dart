import 'package:flutter/material.dart';

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


class HomePage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return HomePageState();
  }
}


class HomePageState extends State<HomePage> {

  var _courses = [];

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('课程记录'),
      ),

      body: ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Text(_courses[index] + ' $index'),
          );
        },
        itemCount: _courses.length,
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: _addCourse,
        tooltip: '添加课程',
        child: const Icon(Icons.add),
      ),
    );
  }

  void _addCourse() {
    // 通过更改状态来更新 UI
//    setState(() {
//      _courses.add('test');
//    });
    Navigator.push(context, MaterialPageRoute(
      builder: (context) => AddPage(),
    ));
  }

}


class AddPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return AddPageState();
  }

}

class AddPageState extends State<AddPage> {

  final _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('添加课程'),
      ),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: 80),
          Container(
            padding: EdgeInsets.only(left: 12, right: 12),
            child: TextField(
              decoration: InputDecoration(
                filled: true,
                labelText: '课程名称',
              ),
              controller: _textController,
            ),
          ),
          SizedBox(height: 12),
          RaisedButton(
            child: Text('添加'),
            onPressed: _addCourse,
          ),
        ],
      ),
    );
  }

  void _addCourse() {
    print('${_textController.text}');
  }
}



