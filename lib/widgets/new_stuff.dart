import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:numberpicker/numberpicker.dart';
import '../database/model.dart';
import '../database/db_handler.dart';
import './data_selector.dart';
import '../util/months.dart' as mu;

class NewStuffWidget extends StatefulWidget {
  final Task task;
  const NewStuffWidget({Key key, @required this.task}) : super(key: key);
  
  @override
  _NewStuffWidgetState createState() => _NewStuffWidgetState();
}

class _NewStuffWidgetState extends State<NewStuffWidget> {
  final formatDate = DateFormat('dd/MM/yyyy');
  final TextEditingController _controller = TextEditingController();
  final dbh = DatabaseHandler.internal();
  

  DateTime _selectedDate = DateTime.now();
  int _selectedMonth;
  int _selectedDay;
  TimeOfDay _selectedTime;
  String _reiterationGroup;
  String _notificationGroup; 
  num _reiterationCount;
  num _notificationCount;

  @override
  void initState(){
    super.initState();
    _controller.text = widget.task.title;
    _reiterationGroup = widget.task.reiterationTarget;
    _notificationGroup = widget.task.notificationTarget;
    _selectedDate = DateTime.now();
    _selectedTime = widget.task.time;
    _reiterationCount = widget.task.reiteration;
    _notificationCount = widget.task.notification;
    _selectedMonth = widget.task.month;
    _selectedDay = widget.task.day;
  }

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

  _saveData(Task task) async{
    if(formIsValid()){
      int id = task.id;
      task = Task(
        _controller.text, 
        _selectedDate, 
        _selectedTime, 
        _selectedMonth,
        _selectedDay,
        _reiterationCount, 
        _reiterationGroup, 
        _notificationCount, 
        _notificationGroup);
      print('task to save: ${task.toMap().toString()}');
      if(id == null)
        await dbh.create(task);
      else
        await dbh.edit(task, id);

      Navigator.pop(context);
    }
  }

  bool formIsValid(){
    if(_controller.text.isEmpty || _selectedMonth == null || _selectedDay == null || _selectedTime == null){
      displayDialog('Form Invalid!', 'Please make sure to fill all the requested data!');
      return false;
    }

    return true;
  }

  void displayDataSelectorDialog(){
    var alert = AlertDialog(
      // title: Text('Start date'),
      contentPadding: EdgeInsets.only(top: 0.0),
      content: Container(
        width: MediaQuery.of(context).size.width * .9,
        child: DateSelector(
          selectedMonth: _selectedMonth,
          selectedDay: _selectedDay,
          onDateSelected: (Map month, int day){
            print('${month.toString()}, $day');
            setState(() {
              _selectedMonth = month['number'];
              _selectedDay = day;              
            });
            Navigator.pop(context);
          },
        ),
      ),
    );

    showDialog(
      context: context, 
      builder: (BuildContext context) => alert,
      // barrierDismissible: false,
    );
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
        title: Text(
          (widget.task.id == null) ? 'New Stuff' : '${widget.task.title}'
        ),
        actions: <Widget>[
          FlatButton(
            child: Icon(Icons.save, color: Colors.white),
            onPressed: (){
              _saveData(widget.task);
            },
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
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    
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
                    (_selectedMonth == null && _selectedDay == null) ? 'Select a Date' : '${_selectedDay.toString().padLeft(2, '0')}, ${mu.findMonthByNumber(_selectedMonth)['name']}',
                    style: TextStyle(
                      fontSize: 30.0,
                      color: Colors.blueAccent
                    ),
                  ),
                ),
                onPressed: () {
                  // _selectDate();
                  displayDataSelectorDialog();
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
                  'Reiteration every',
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
                      Expanded(
                        child: Text(
                          'Month',
                        ),
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
                  'Remind me before',
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