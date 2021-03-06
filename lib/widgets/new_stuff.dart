import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:numberpicker/numberpicker.dart';
import '../database/model.dart';
import '../database/db_handler.dart';
import './data_selector.dart';
import '../util/months.dart' as mu;
import '../util/colors.dart' as color;
import '../util/dictionnary.dart' as dictionnary;
import 'voice_recognition.dart';

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
      displayDialog(
          dictionnary.translate('form.invalid.title'),
          dictionnary.translate('form.invalid.description')
      );
      return false;
    }

    return true;
  }

  void displayDataSelectorDialog(){
    var alert = AlertDialog(
      // title: Text('Start date'),
      contentPadding: EdgeInsets.all(5.0),
      content: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20.0))
        ),
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
  void _showRecordVoiceDialog(){
    var alert = AlertDialog(
      content: VoiceRecognition(
        onSave: (text){
          setState(() {_controller.text = text;});
          Navigator.pop(context);
        },
        onCancel: () => Navigator.pop(context),
      ),
    );

    showDialog(context: context, builder: (BuildContext context) => alert, barrierDismissible: false);
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
      backgroundColor: color.secondary,
      appBar: AppBar(
        backgroundColor: color.primary,
        title: Text(
          (widget.task.id == null) ? dictionnary.translate('new.stuff') : '${widget.task.title}'
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
            // color: Colors.teal,
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Center(
                child: Text(
                  dictionnary.translate('what.should.I.remind.you.with'),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: color.text,
                    
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
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: dictionnary.translate('ex.pay.some.bills'),
                      ),
                    ),
                  ),
                ),
                FloatingActionButton(
                  child: Icon(Icons.mic),
                  backgroundColor: color.primary,
                  onPressed: (){
                    _showRecordVoiceDialog();
                  },
                )
              ],
            ),
          ),

          Padding(
            padding: EdgeInsets.all(10.0),
            child: Center(
              child: OutlineButton(                
                borderSide: BorderSide(
                  color: color.primary,
                ),
                color: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50.0)
                ),
                child: Padding(
                  padding: EdgeInsets.all(15.0),
                  child: Text(
                    (_selectedMonth == null && _selectedDay == null) ? dictionnary.translate('select.date') : '${_selectedDay.toString().padLeft(2, '0')}, ${mu.findMonthByNumber(_selectedMonth)['name']}',
                    style: TextStyle(
                      fontSize: 20.0,
                      color: color.primary
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
            // color: Colors.teal,
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Center(
                child: Text(
                  dictionnary.translate('reiteration.every'),
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: color.text
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
                          dictionnary.translate('MONTH'),
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
                        dictionnary.translate('YEAR'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Container(
            // color: Colors.teal,
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Center(
                child: Text(
                  dictionnary.translate('remind.me.before'),
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: color.text
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
                        dictionnary.translate('DAY'),
                        
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
                        dictionnary.translate('WEEK'),
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
                color: color.primary,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50.0)
              ),
              child: Padding(
                padding: EdgeInsets.all(15.0),
                child: Text(
                  (_selectedTime == null) ? dictionnary.translate('select.time') : '${_selectedTime.hour.toString().padLeft(2, '0')}:${_selectedTime.minute.toString().padLeft(2, '0')}',
                  style: TextStyle(
                    fontSize: 20.0,
                    color: color.primary
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