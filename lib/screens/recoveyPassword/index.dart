import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gestaoApp/services/api.dart';
import 'package:http/http.dart' as http;

void main() => runApp(RecoveyPassword());

class RecoveyPassword extends StatefulWidget {
  @override
  _RecoveyPassword createState() => _RecoveyPassword();
}

class _RecoveyPassword extends State<RecoveyPassword> {
  bool loading = false;
  bool sucess = false;
  bool error = false;

  TextEditingController email = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void senApi(SnackBar snackbar, BuildContext context) async {
    this.setState(() {
      loading = true;
    });
    var data = json.encode({"email": email.text});
    await http
        .put(Api.url + 'update-password-recovey',
            headers: {"Content-type": "application/json; charset=UTF-8 "},
            body: data)
        .then((value) => {
              Scaffold.of(context).showSnackBar(snackbar),
              this.setState(() {
                loading = false;
                email.clear();
              })
            });
    Timer(
        Duration(seconds: 2),
        () => {
              this.setState(() {
                sucess = false;
              })
            });
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Recuperação de senha',
              style: TextStyle(color: Colors.white, fontSize: 18)),
          backgroundColor: Color(0xff537EFF),
        ),
        body: Form(
          key: _formKey,
          child: Container(
            color: Color(0xff537EFF),
            child: Center(
                child: Container(
              height: 350,
              child: Card(
                  elevation: 5,
                  margin: EdgeInsets.all(20),
                  child: Container(
                    margin: EdgeInsets.fromLTRB(15, 10, 15, 15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Enviaremos uma nova senha para seu e-mail',
                          style: TextStyle(fontSize: 16),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(0, 0, 0, 15),
                          child: TextFormField(
                            controller: email,
                            decoration: InputDecoration(
                              labelText: 'E-mail',
                              labelStyle: TextStyle(fontSize: 18),
                            ),
                            validator: (value) {
                              if (value.isEmpty) {
                                return "Informe seu e-mail";
                              }
                              return null;
                            },
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                          child: Builder(
                            builder: (context) {
                              if (loading == true) {
                                return Container(
                                    padding: EdgeInsets.fromLTRB(0, 14, 0, 0),
                                    child: CircularProgressIndicator(
                                        valueColor: AlwaysStoppedAnimation(
                                            Color(0xff537EFF)),
                                        strokeWidth: 3.0));
                              }
                              return Container(
                                child: RaisedButton(
                                  elevation: 2,
                                  padding:
                                      EdgeInsets.fromLTRB(130, 15, 130, 15),
                                  onPressed: () {
                                    if (email.text != "") {
                                      var snackbar = SnackBar(
                                          duration: Duration(seconds: 10),
                                          backgroundColor: Colors.green,
                                          content: Container(
                                            margin: EdgeInsets.fromLTRB(
                                                10, 0, 0, 0),
                                            child: Text(
                                              'Parabéns, acesse seu E-mail para prosseguir com a recuperação de senha',
                                              style: TextStyle(fontSize: 16),
                                            ),
                                          ));
                                      senApi(snackbar, context);
                                    }
                                    _formKey.currentState.validate();
                                  },
                                  child: Text(
                                    'Enviar',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                              );
                            },
                          ),
                        )
                      ],
                    ),
                  )),
            )),
          ),
        ));
  }
}
