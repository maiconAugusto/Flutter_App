import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gestaoApp/services/api.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

void main() => runApp(Maps());

class Maps extends StatefulWidget {
  _Maps createState() => _Maps();
}

class _Maps extends State<Maps> {
  Set<Marker> _marker = {};
  bool loading = false;

  getLocationUsers() async {
    Set<Marker> markerLocal = {};
    setState(() {
      loading = true;
    });

    var prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('@TOKEN');
    var accountId = prefs.getString('@ACCOUNTID');

    http.Response response = await http
        .get(Api.url + 'query-localization-collaborators/$accountId', headers: {
      'Authorization': 'Bearer $token',
    });

    var data = json.decode(response.body);

    for (var list in data['data']) {
      Marker markerCollaborator = Marker(
          markerId: MarkerId(list['collaborator']['id']),
          position: LatLng(list['collaborator']['latitude'],
              list['collaborator']['longitude']),
          infoWindow: InfoWindow(title: list['collaborator']['name']));
      markerLocal.add(markerCollaborator);
    }

    setState(() {
      _marker = markerLocal;
      loading = false;
    });
  }

  void initState() {
    super.initState();
    getLocationUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'Localização de colaboradores',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          backgroundColor: Color(0xff537EFF),
        ),
        body: new Stack(
          children: [
            GoogleMap(
              initialCameraPosition: CameraPosition(
                  target: LatLng(-22.531011, -55.731530), zoom: 12.5),
              markers: _marker,
            ),
            new Positioned(
                child: loading == true
                    ? Center(
                        child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation(Color(0xff537EFF)),
                            strokeWidth: 3.0),
                      )
                    : Container()),
          ],
        ));
  }
}
