import 'package:flutter/material.dart';
import 'package:gestaoApp/screens/calendar/index.dart';
import 'package:gestaoApp/screens/home/index.dart';
import 'package:gestaoApp/screens/listOfCollaborators/index.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(NavDrawer());

class NavDrawer extends StatelessWidget {
  exitApp(context) async {
    var prefs = await SharedPreferences.getInstance();
    prefs.remove("@ID");
    prefs.remove("@ACCOUNTID");
    prefs.remove("@PLAYERID");
    prefs.remove("@NAME");
    prefs.remove("@AVATAR");
    prefs.remove("@AVATAR_URL_PATH");
    prefs.remove("@TOKEN");
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return (Drawer(
      child: Container(
        color: Color(0xff454555),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(20, 50, 0, 5),
              child: CircleAvatar(
                radius: 55,
                backgroundColor: Color(0xff537EFF),
                child: CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(
                        'https://firebasestorage.googleapis.com/v0/b/teste-294604.appspot.com/o/a84f059773501b3de85c499b8349d571.png?alt=media&token=a84f059773501b3de85c499b8349d571.png')),
              ),
            ),
            Text('Maicon Augusto',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                )),
            Container(
                margin: EdgeInsets.fromLTRB(0, 40, 0, 0),
                child: FlatButton(
                  height: 50,
                  onPressed: () => {Navigator.pop(context)},
                  child: Row(
                    children: [
                      Container(
                        child: Icon(Icons.home, color: Color(0xff537EFF)),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(20, 0, 0, 0),
                        child: Text(
                          'Home',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      )
                    ],
                  ),
                )),
            Divider(
              height: 10,
              color: Colors.white,
            ),
            FlatButton(
              onPressed: () => {
                Navigator.pop(context),
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => MyHomePage(),
                ))
              },
              child: Row(
                children: [
                  Container(
                    child: Icon(Icons.calendar_today, color: Color(0xff537EFF)),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(20, 0, 0, 0),
                    child: Text(
                      'Atividades',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  )
                ],
              ),
            ),
            Divider(
              height: 10,
              color: Colors.white,
            ),
            FlatButton(
              height: 50,
              onPressed: () => {
                Navigator.pop(context),
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => AddCollaborator()))
              },
              child: Row(
                children: [
                  Container(
                    child: Icon(Icons.person_add, color: Color(0xff537EFF)),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(20, 0, 0, 0),
                    child: Text(
                      'Adicionar colaborador',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  )
                ],
              ),
            ),
            Divider(
              height: 10,
              color: Colors.white,
            ),
            FlatButton(
              height: 50,
              onPressed: () => {
                Navigator.pop(context),
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => SearchCollaborator(),
                ))
              },
              child: Row(
                children: [
                  Container(
                    child: Icon(Icons.person_search, color: Color(0xff537EFF)),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(20, 0, 0, 0),
                    child: Text(
                      'Procurar colaborador',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  )
                ],
              ),
            ),
            Divider(
              color: Colors.white,
            ),
            FlatButton(
              height: 50,
              onPressed: () => {
                Navigator.pop(context),
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => Listing(),
                ))
              },
              child: Row(
                children: [
                  Container(
                    child: Icon(Icons.list, color: Color(0xff537EFF)),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(20, 0, 0, 0),
                    child: Text(
                      'Listagem',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  )
                ],
              ),
            ),
            Divider(
              height: 10,
              color: Colors.white,
            ),
            Container(
              margin: EdgeInsets.fromLTRB(0, 40, 0, 0),
              child: FlatButton(
                height: 50,
                onPressed: () => {},
                child: Row(
                  children: [
                    Container(
                      child: Icon(Icons.settings, color: Color(0xff537EFF)),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(20, 0, 0, 0),
                      child: Text(
                        'Configurações',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    )
                  ],
                ),
              ),
            ),
            FlatButton(
              height: 50,
              onPressed: () => {exitApp(context)},
              child: Row(
                children: [
                  Container(
                    child: Icon(Icons.exit_to_app, color: Color(0xff537EFF)),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(20, 0, 0, 0),
                    child: Text(
                      'Sair',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
