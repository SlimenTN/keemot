import 'dart:async';

import 'package:flutter/material.dart';
import 'package:speech_recognition/speech_recognition.dart';
import 'package:permission/permission.dart';
import '../util/dictionnary.dart' as dictionnary;
import '../util/colors.dart' as colors;

class VoiceRecognition extends StatefulWidget {
  final Function onSave;
  final Function onCancel;

  VoiceRecognition({Key key, @required this.onSave, this.onCancel}): super(key: key);

  @override
  _VoiceRecognitionState createState() => _VoiceRecognitionState();
}

class _VoiceRecognitionState extends State<VoiceRecognition> {
  SpeechRecognition _speech;
  String _currentLocale;
  String _text = '';

  @override
  void initState() {
    super.initState();
    _initSpeechRecognition();
    Timer(const Duration(milliseconds: 400), () {
      _startRecording();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _speech.stop();
  }

  void _initSpeechRecognition() async {
    await Permission.requestPermissions([PermissionName.Microphone]);
    _speech = SpeechRecognition();
    // handle device current locale detection
    _speech.setCurrentLocaleHandler((String locale) {
      _currentLocale = locale;
      print('current locale: $locale');
    });

    _speech
        .activate()
        .then((res) => setState(() => print('speech res: ${res.toString()}')));
  }

  void _startRecording(){
    _speech.listen(locale: 'en_US')
        .then((result){
          _speech.setRecognitionResultHandler(
              (String text) => setState(() => _text = text)
          );
        })
        .catchError((err){
          print('error: ${err.toString()}');
        });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200.0,
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(dictionnary.translate('say.something')),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
                _text,
              textAlign: TextAlign.center,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: FloatingActionButton(
                  backgroundColor: colors.primary,
                  child: Icon(Icons.refresh),
                  onPressed: (){
                    _startRecording();
                    setState(() {
                      _text = '';
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: FloatingActionButton(
                  backgroundColor: colors.primary,
                  child: Icon(Icons.check),
                  onPressed: (){
                    _speech.stop();
                    widget.onSave(_text);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: FloatingActionButton(
                  backgroundColor: colors.red,
                  child: Icon(Icons.cancel),
                  onPressed: (){
                    _speech.stop();
                    widget.onCancel();
                  },
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
