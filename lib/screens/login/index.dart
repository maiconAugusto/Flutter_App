import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gestaoApp/screens/home/index.dart';
import 'package:gestaoApp/services/api.dart';
import 'package:http/http.dart' as http;
import 'package:gestaoApp/screens/recoveyPassword/index.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(Login());

class Login extends StatefulWidget {
  @override
  _Login createState() => _Login();
}

class LoginApi {
  String logger;
  LoginApi(this.logger);
}

class _Login extends State<Login> {
  bool loading = false;
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  login() async {
    final prefs = await SharedPreferences.getInstance();

    var data = json.encode({"email": email.text, "password": password.text});

    http.Response response = await http.post(
      Api.url + 'authentication',
      headers: {"Content-type": "application/json; charset=UTF-8 "},
      body: data,
    );

    if (response.statusCode != 200) {
      setState(() {
        loading = false;
        password.clear();
      });
    } else {
      var dataUser = json.decode(response.body);
      prefs.setString("@ID", dataUser['user']['id']);
      prefs.setString("@ACCOUNTID", dataUser['user']['accountId']);
      prefs.setString("@PLAYERID", dataUser['user']['player_id']);
      prefs.setString("@NAME", dataUser['user']['name']);
      prefs.setString("@AVATAR", dataUser['user']['avatar']);
      prefs.setString("@AVATAR_URL_PATH", dataUser['user']['avatar_url_path']);
      prefs.setString("@TOKEN", dataUser['token']);
      setState(() {
        loading = false;
      });
      email.clear();
      password.clear();
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => Home()));
    }
  }

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    return (Form(
      key: _formKey,
      child: Container(
        color: Color(0xff537EFF),
        child: Center(
          child: Card(
              margin: EdgeInsets.all(20),
              child: Container(
                height: 350,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.fromLTRB(15, 10, 15, 15),
                      child: TextFormField(
                        controller: email,
                        decoration: InputDecoration(
                            labelText: 'E-mail',
                            labelStyle: TextStyle(fontSize: 18)),
                        // ignore: missing_return
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Insira o e-mail';
                          }
                          return null;
                        },
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(15, 10, 15, 15),
                      child: TextFormField(
                        obscureText: true,
                        controller: password,
                        decoration: InputDecoration(
                            labelText: 'Senha',
                            labelStyle: TextStyle(fontSize: 18)),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Insira a senha';
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
                                margin: EdgeInsets.fromLTRB(0, 12, 0, 0),
                                child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation(
                                        Color(0xff537EFF)),
                                    strokeWidth: 3.0),
                              );
                            }
                            return RaisedButton(
                              elevation: 2,
                              onPressed: () => {
                                if (email.text != '' && password.text != '')
                                  {
                                    this.setState(() {
                                      loading = true;
                                      login();
                                    })
                                  }
                                else
                                  {_formKey.currentState.validate()}
                              },
                              padding: EdgeInsets.fromLTRB(130, 15, 130, 15),
                              child: Text(
                                'Entrar',
                                style: TextStyle(fontSize: 16),
                              ),
                            );
                          },
                        )),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => RecoveyPassword()));
                        },
                        child: Text(
                          'Esqueceu sua senha? clique aqui!',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    )
                  ],
                ),
              )),
        ),
      ),
    ));
  }
}
