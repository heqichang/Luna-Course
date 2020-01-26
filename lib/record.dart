
import 'package:flutter/material.dart';

class RecordPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return RecordPageState();
  }
}


class RecordPageState extends State<RecordPage> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('详细记录'),
      ),
    );
  }
}