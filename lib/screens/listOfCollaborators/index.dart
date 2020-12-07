import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gestaoApp/services/api.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(Listing());

class Listing extends StatefulWidget {
  @override
  _Listing createState() => _Listing();
}

class _Listing extends State<Listing> {
  List<Map<String, dynamic>> collaborators = List();
  int page = 0;
  bool loading = false;

  void getCollaborator() async {
    final prefs = await SharedPreferences.getInstance();
    String accountId = prefs.getString('@ACCOUNTID');
    String token = prefs.getString('@TOKEN');

    http.Response response = await http.get(
        Api.url + 'query-all-collaborator-filter/$accountId/$page',
        headers: {
          'Authorization': 'Bearer $token',
        });
    var data = json.decode(response.body);
    List<Map<String, dynamic>> list = List();

    for (var info in data['data']) {
      list.add(info);
    }
    setState(() {
      loading = false;
      collaborators = list;
    });
  }

  void initState() {
    super.initState();
    getCollaborator();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color(0xff537EFF),
        title: Text(
          'Listagem',
          style: TextStyle(fontSize: 18),
        ),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification scrollInfo) {
                if (!loading &&
                    scrollInfo.metrics.pixels ==
                        scrollInfo.metrics.maxScrollExtent) {
                  setState(() {
                    page = 1;
                    loading = true;
                  });
                  getCollaborator();
                }
              },
              child: ListView.builder(
                itemCount: collaborators.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      leading: collaborators[index]['collaborator']['avatar'] ==
                              null
                          ? Icon(Icons.person)
                          : CircleAvatar(
                              backgroundColor: Colors.white,
                              backgroundImage: NetworkImage(collaborators[index]
                                  ['collaborator']['avatar']),
                            ),
                      title: Text(collaborators[index]['collaborator']['name']),
                      subtitle: Text(collaborators[index]['categories']),
                    ),
                  );
                },
              ),
            ),
          ),
          Container(
            height: loading ? 50.0 : 0,
            color: Colors.transparent,
            child: Center(
              child: new CircularProgressIndicator(),
            ),
          ),
        ],
      ),
    );
  }
}
