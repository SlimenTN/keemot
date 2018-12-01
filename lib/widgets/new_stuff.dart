import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:numberpicker/numberpicker.dart';
import '../database/model.dart';
import '../database/db_handler.dart';

class NewStuffWidget extends StatefulWidget {
  @override
  _NewStuffWidgetState createState() => _NewStuffWidgetState();
}

class _NewStuffWidgetState extends State<NewStuffWidget> {
  final formatDate = DateFormat('dd/MM/yyyy');
  final TextEditingController _controller = TextEditingController();
  final dbh = DatabaseHandler.internal();

  DateTime _selectedDate;
  TimeOfDay _selectedTime;
  String _reiterationGroup = 'MONTH';
  String _notificationGroup = 'DAY'; 
  num _reiterationCount = 1;
  num _notificationCount = 1;

  _onReiterationRadioChanged(String value){
    setState(() {
      _reiterationGroup = value;
    });
  }

  _onNotificationRadioChanged(String value){
    setState(() {
      _notificationGroup = value;    
    });
  }

  void _selectDate(BuildContext context) async{
    final DateTime dt = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2016),
      lastDate: DateTime(2020)
    );

    if(dt != null){
      setState(() {
        _selectedDate = dt;      
      });
    }
  }

  void _selectTime(BuildContext context) async{
    final TimeOfDay tod = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if(tod != null){
      setState(() {
        _selectedTime = tod;      
      });
    }
  }

  _handleReiterationChange(num value) {
    setState(() {
      _reiterationCount = value;
    });
    debugPrint('selected value: $value');
  }

  _handleNotificationChange(num value){
    setState(() {
      _notificationCount = value; 
    });
  }

  _saveData() async{
    if(formIsValid()){
      Task task = Task(
        _controller.text, 
        _selectedDate, 
        _selectedTime, 
        _reiterationCount, 
        _reiterationGroup, 
        _notificationCount, 
        _notificationGroup);
      await dbh.create(task);

      Navigator.pop(context);
    }
  }

  bool formIsValid(){
    if(_controller.text.isEmpty || _selectedDate == null || _selectedTime == null){
      displayDialog('Form Invalid!', 'Please make sure to fill all the requested data!');
      return false;
    }

    return true;
  }

  void displayDialog(title, String message){
    var alert = AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: <Widget>[
        FlatButton(
          child: Text('OK'),
          onPressed: () => Navigator.pop(context),
        )
      ],
    );

    showDialog(context: context, builder: (BuildContext context) => alert);
  }

  @override
  Widget build(BuildContext context) {

    NumberPicker _reiterationNumberPicker = new NumberPicker.integer(
        initialValue: _reiterationCount,
        minValue: 1,
        maxValue: 11,
        step: 1,
        onChanged: _handleReiterationChange,
    );

    NumberPicker _notificationNumberPicker = new NumberPicker.integer(
        initialValue: _notificationCount,
        minValue: 0,
        maxValue: 11,
        step: 1,
        onChanged: _handleNotificationChange,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('New Stuff'),
        actions: <Widget>[
          FlatButton(
            child: Icon(Icons.save, color: Colors.white),
            onPressed: _saveData,
          ),
        ],
      ),

      body: ListView(
        children: <Widget>[
          Container(
            color: Colors.teal,
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Center(
                child: Text(
                  'What should I remind you with ?',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white
                  ),
                ),
              ),
            ),
          ),

          Padding(
            padding: EdgeInsets.all(20.0),
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'ex: Pay some bills', 
              ),
            ),
          ),

          Padding(
            padding: EdgeInsets.all(10.0),
            child: Center(
              child: OutlineButton(                
                borderSide: BorderSide(
                  color: Colors.blueAccent,
                ),
                color: Colors.blueAccent,
                child: Padding(
                  padding: EdgeInsets.all(15.0),
                  child: Text(
                    (_selectedDate == null) ? 'Select a Date' : this.formatDate.format(_selectedDate),
                    style: TextStyle(
                      fontSize: 30.0,
                      color: Colors.blueAccent
                    ),
                  ),
                ),
                onPressed: () {
                  _selectDate(context);
                },
              ),
            )
          ),

          Container(
            color: Colors.teal,
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Center(
                child: Text(
                  'Reiteration',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white
                  ),
                ),
              ),
            ),
          ),

          Padding(
            padding: EdgeInsets.all(20.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Text('Every'),
                ),
                Expanded(
                  child: _reiterationNumberPicker
                ),
                Expanded(
                  child: Row(
                    children: <Widget>[
                      Radio(
                        value: 'MONTH',
                        groupValue: _reiterationGroup,
                        onChanged: _onReiterationRadioChanged,
                      ),
                      Text(
                        'Month',
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    children: <Widget>[
                      Radio(
                        value: 'YEAR',
                        groupValue: _reiterationGroup,
                        onChanged: _onReiterationRadioChanged,
                      ),
                      Text(
                        'Year',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Container(
            color: Colors.teal,
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Center(
                child: Text(
                  'When should I remind you ?',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white
                  ),
                ),
              ),
            ),
          ),

          Padding(
            padding: EdgeInsets.all(20.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Text('Before'),
                ),
                Expanded(
                  child: _notificationNumberPicker
                ),
                Expanded(
                  child: Row(
                    children: <Widget>[
                      Radio(
                        value: 'DAY',
                        groupValue: _notificationGroup,
                        onChanged: _onNotificationRadioChanged,
                      ),
                      Text(
                        'Day',
                        
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    children: <Widget>[
                      Radio(
                        value: 'WEEK',
                        groupValue: _notificationGroup,
                        onChanged: _onNotificationRadioChanged,
                      ),
                      Text(
                        'Week',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Center(
            child: OutlineButton(
              borderSide: BorderSide(
                color: Colors.blueAccent,
              ),
              child: Padding(
                padding: EdgeInsets.all(15.0),
                child: Text(
                  (_selectedTime == null) ? 'Select a Time' : '${_selectedTime.hour.toString().padLeft(2, '0')}:${_selectedTime.minute.toString().padLeft(2, '0')}',
                  style: TextStyle(
                    fontSize: 30.0,
                    color: Colors.blueAccent
                  ),
                ),
              ),
              onPressed: (){
                _selectTime(context);
              },
            ),
          ),

          Padding(padding: EdgeInsets.only(bottom: 20.0))
        ],
      ),
    );
  }
}