import 'package:YOURDRS_FlutterAPP/network/models/dictation_status.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:searchable_dropdown/searchable_dropdown.dart';

class DictationSearch extends StatefulWidget {
  final onTapOfDictation;

  DictationSearch({@required this.onTapOfDictation});

  @override
  _DictationSearchState createState() => _DictationSearchState();
}


class _DictationSearchState extends State<DictationSearch> {
  bool searching = false;
  DictationStatus _currentSelectedValue;
  final String url = "https://jsonplaceholder.typicode.com/users";

  List<DictationStatus> data = List(); //edited line


  Future<String> getjsondata() async {
    String jsonData = await DefaultAssetBundle.of(context)
        .loadString("assets/json/appointment.json");
    final jsonResult = json.decode(jsonData);

    data = List<DictationStatus>.from(jsonResult.map((x) => DictationStatus.fromJson(x) ) );

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    this.getjsondata();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(10),
      width: 320,
      child: SearchableDropdown.single(
        hint: Text('Select Dictation'),
        label: Text(
          ' Dictation',
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        items: data.map((item) {
          print('item $item');
          return DropdownMenuItem<DictationStatus>(
            child: new Text(item.dictationstatus),
            value: item,

          );
        }).toList(),
        value: _currentSelectedValue,
        isExpanded: true,
        searchHint: new Text('Select ', style: new TextStyle(fontSize: 20)),
        onChanged: (value) {
          print('value $value');
          setState(
            () {
              _currentSelectedValue = value;
            },
          );
          widget.onTapOfDictation(value);
        },
      ),
    );
  }
}
