
import 'package:flutter/material.dart';

class AddRecordPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return AddRecordPageState();
  }
}


class AddRecordPageState extends State<AddRecordPage> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('添加记录'),
      ),
    );
  }
}