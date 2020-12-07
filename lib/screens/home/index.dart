import 'package:flutter/material.dart';
import 'package:gestaoApp/components/Drawer/index.dart';
import 'package:gestaoApp/screens/collaboratorsMap/index.dart';
import 'package:gestaoApp/store/form.dart';
import 'dart:convert';
import 'package:gestaoApp/services/api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import '../../store/form.dart';

part '../searchCollaborator/index.dart';
part '../../components/form/index.dart';
part '../../components/localization/index.dart';
part '../addCollaborator/index.dart';

final values = FormCollaborator();

void main() => runApp(Home());

class Home extends StatefulWidget {
  @override
  _Home createState() => _Home();
}

class _Home extends State<Home> {
  bool loading = false;
  int totalOfCollaborator;
  int hired;
  int outhers;
  int voluntary;
  int _selectedIndex = 0;

  void getAcountCollaborator() async {
    setState(() {
      loading = true;
    });

    final prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('@TOKEN');
    String accountId = prefs.getString('@ACCOUNTID');
    String hiredId = "e8daeffe-35da-410e-97d7-a02bcc8404c1";
    String outhersId = "66639b19-f283-4dcd-af39-9702d1c89470";
    String voluntaryId = "3ccbad26-ca45-44c3-a7d7-862eef478bd3";

    http.Response response = await http.get(
      Api.url +
          'query-all-collaborator/$accountId?hiredId=$hiredId&outhersId=$outhersId&voluntaryId=$voluntaryId',
      headers: {'Authorization': 'Bearer $token'},
    );

    var data = json.decode(response.body);

    setState(() {
      totalOfCollaborator = data['data']['hired'] +
          data['data']['voluntary'] +
          data['data']['outhers'];
      hired = data['data']['hired'];
      outhers = data['data']['outhers'];
      voluntary = data['data']['voluntary'];
      loading = false;
    });
  }

  void initState() {
    super.initState();
    getAcountCollaborator();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(backgroundColor: Color(0xff537EFF)),
        body: Container(
          margin: EdgeInsets.fromLTRB(0, 40, 0, 0),
          child: ListView(
            children: [
              Card(
                color: Color(0xffEFF3FF),
                elevation: 1,
                child: ListTile(
                  leading: loading == true
                      ? SizedBox(
                          child: CircularProgressIndicator(),
                          width: 30,
                          height: 30,
                        )
                      : Icon(Icons.person, color: Color(0xFF4F4F64)),
                  title: Text(
                    'Total de colaboradores',
                    style: TextStyle(fontSize: 16, color: Color(0xFF4F4F64)),
                  ),
                  subtitle: loading == true
                      ? Text('Carregando..')
                      : Text('$totalOfCollaborator'),
                ),
              ),
              Card(
                elevation: 1,
                color: Color(0xffEFF3FF),
                child: ListTile(
                  leading: loading == true
                      ? SizedBox(
                          child: CircularProgressIndicator(),
                          width: 30,
                          height: 30,
                        )
                      : Icon(Icons.person, color: Color(0xFF4F4F64)),
                  title: Text('Total de contratados',
                      style: TextStyle(fontSize: 16, color: Color(0xFF4F4F64))),
                  subtitle:
                      loading == true ? Text('Carregando..') : Text('$hired'),
                ),
              ),
              Card(
                elevation: 1,
                color: Color(0xffEFF3FF),
                child: ListTile(
                  leading: loading == true
                      ? SizedBox(
                          child: CircularProgressIndicator(),
                          width: 30,
                          height: 30,
                        )
                      : Icon(Icons.person, color: Color(0xFF4F4F64)),
                  title: Text('Total de voluntários',
                      style: TextStyle(fontSize: 16, color: Color(0xFF4F4F64))),
                  subtitle: loading == true
                      ? Text('Carregando..')
                      : Text('$voluntary'),
                ),
              ),
              Card(
                elevation: 1,
                color: Color(0xffEFF3FF),
                child: ListTile(
                  leading: loading == true
                      ? SizedBox(
                          child: CircularProgressIndicator(),
                          width: 30,
                          height: 30,
                        )
                      : Icon(Icons.person, color: Color(0xFF4F4F64)),
                  title: Text('Outros',
                      style: TextStyle(fontSize: 16, color: Color(0xFF4F4F64))),
                  subtitle:
                      loading == true ? Text('Carregando..') : Text('$outhers'),
                ),
              )
            ],
          ),
        ),
        drawer: NavDrawer(),
        bottomNavigationBar: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                  icon: Icon(Icons.location_on), label: 'Mapa'),
            ],
            onTap: (value) {
              if (value == 1) {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => Collaborators(),
                ));
              }
            },
            backgroundColor: Color(0xff537EFF),
            iconSize: 26,
            selectedItemColor: Colors.white,
            selectedFontSize: 14,
            currentIndex: _selectedIndex),
      ),
    );
  }
}
