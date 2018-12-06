import 'package:flutter/material.dart';
import './data_selector.dart';

class TestScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Test Screen'),
      ),

      body: Center(
        child: Container(
          padding: EdgeInsets.all(50.0),
          child: DateSelector(),
        )
      ),
    );
  }
}