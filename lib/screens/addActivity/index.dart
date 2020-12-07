import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gestaoApp/services/api.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(AddActivity());

class AddActivity extends StatefulWidget {
  @override
  _AddActivity createState() => _AddActivity();
}

class _AddActivity extends State<AddActivity> {
  DateTime _dateTime = DateTime.now();
  TimeOfDay _hour = TimeOfDay.now();
  TextEditingController _title = TextEditingController();
  TextEditingController _description = TextEditingController();
  bool loading = false;

  void sendApi(snackBar, BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      loading = true;
    });

    var data = json.encode({
      "title": _title.text,
      "description": _description.text,
      "day": '${_dateTime.year}-${_dateTime.month}-${_dateTime.day}',
      "hour": '${_hour.hour}:${_hour.minute}',
      "done": false,
      "accountId": prefs.getString('@ACCOUNTID'),
      "active": true,
    });

    await http
        .post(Api.url + 'create-activity',
            headers: {"Content-type": "application/json; charset=UTF-8 "},
            body: data)
        .then((value) => Scaffold.of(context).showSnackBar(snackBar));

    setState(() {
      loading = false;
      _title.clear();
      _description.clear();
      _dateTime = DateTime.now();
      _hour = TimeOfDay.now();
    });
  }

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xff537EFF),
          centerTitle: true,
          title: Text('Adicionar atividade',
              style: TextStyle(color: Colors.white, fontSize: 18)),
        ),
        body: SingleChildScrollView(
            child: Form(
          key: _formKey,
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(0, 40, 0, 20),
                child: Text(
                  'Selecione a data e hora da atividade',
                  style: TextStyle(
                      color: Color(0xff537EFF),
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(12, 10, 12, 10),
                height: 70,
                color: Colors.amber,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Icon(Icons.calendar_today, color: Colors.white),
                    Container(
                      child: RaisedButton(
                        color: Colors.amber[100],
                        padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                        child: Text(
                            '${_dateTime.day}/${_dateTime.month}/${_dateTime.year}',
                            style: TextStyle(
                                color: Color(0xff537EFF), fontSize: 18)),
                        onPressed: () {
                          return showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(2001),
                                  lastDate: DateTime(2022))
                              .then((value) => {
                                    if (value != null)
                                      {
                                        this.setState(() {
                                          _dateTime = value;
                                        })
                                      }
                                  });
                        },
                      ),
                    ),
                    Icon(Icons.schedule, color: Colors.white),
                    RaisedButton(
                      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                      color: Colors.amber[100],
                      onPressed: () {
                        return showTimePicker(
                                context: context, initialTime: TimeOfDay.now())
                            .then((value) => {
                                  if (value != null)
                                    {
                                      this.setState(() {
                                        _hour = value;
                                      })
                                    }
                                });
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('${_hour.hour}:${_hour.minute}',
                              style: TextStyle(
                                  color: Color(0xff537EFF), fontSize: 18)),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(10, 50, 10, 10),
                child: TextFormField(
                  controller: _title,
                  maxLength: 20,
                  maxLengthEnforced: true,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Titulo é obrigatório!';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xff537EFF))),
                      labelText: 'Titulo da atividade',
                      labelStyle:
                          TextStyle(fontSize: 14, color: Color(0xff537EFF))),
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(10, 20, 10, 10),
                child: TextFormField(
                  maxLines: 5,
                  controller: _description,
                  keyboardType: TextInputType.text,
                  maxLength: 200,
                  maxLengthEnforced: true,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Descrição é obrigatório!';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                      hintText: 'Descrição da atividade',
                      hintStyle:
                          TextStyle(fontSize: 14, color: Color(0xff537EFF)),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(2.0))),
                ),
              ),
              Container(
                  margin: EdgeInsets.fromLTRB(0, 40, 0, 0),
                  height: 70,
                  child: Builder(
                    builder: (context) {
                      if (loading == true) {
                        return Center(
                          child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation(Color(0xff537EFF)),
                          ),
                        );
                      } else {
                        return RaisedButton(
                          elevation: 1,
                          padding: EdgeInsets.fromLTRB(90, 0, 90, 0),
                          child: Text('Adicionar atividade',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18)),
                          onPressed: () {
                            var snackBar = SnackBar(
                                backgroundColor: Colors.green[400],
                                content: Container(
                                  margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                  child:
                                      Text('Atividade adicionada com sucesso!'),
                                ));

                            if (_title.text != '' && _description.text != '') {
                              sendApi(snackBar, context);
                            } else {
                              _formKey.currentState.validate();
                            }
                          },
                          color: Color(0xff537EFF),
                        );
                      }
                    },
                  ))
            ],
          ),
        )));
  }
}
