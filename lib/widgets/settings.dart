import 'package:flutter/material.dart';
import '../util/dictionnary.dart' as dictionnary;

class SettingsWidget extends StatefulWidget {
  final Function onDataChanged;
  final String selectedLang;

  SettingsWidget({Key key, @required this.onDataChanged, @required this.selectedLang}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<SettingsWidget> {
  String _selectedLang;

  @override
  void initState() {
    super.initState();
    _selectedLang = widget.selectedLang;
  }

  void _onLanguageChanged(String value){
    setState(() => _selectedLang = value);
    widget.onDataChanged(_selectedLang);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70.0,
      child: Column(
        children: <Widget>[
          Text(dictionnary.translate('select.your.language')),
          Row(
            children: <Widget>[
              Expanded(
                child: Row(
                  children: <Widget>[
                    Radio(
                      value: 'en',
                      groupValue: _selectedLang,
                      onChanged: _onLanguageChanged,
                    ),
                    Expanded(
                      child: Text(
                        dictionnary.translate('english'),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  children: <Widget>[
                    Radio(
                      value: 'fr',
                      groupValue: _selectedLang,
                      onChanged: _onLanguageChanged,
                    ),
                    Text(
                      dictionnary.translate('french'),
                    ),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
