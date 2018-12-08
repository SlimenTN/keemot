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
          height: 400.0,
          padding: EdgeInsets.all(50.0),
          child: DateSelector(
            onDateSelected: (Map month, int selectedDay){
              print('you have selected the $selectedDay th of ${month['name']}');
            },
          ),
        )
      ),
    );
  }
}