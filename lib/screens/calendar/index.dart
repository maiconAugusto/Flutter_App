import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gestaoApp/screens/addActivity/index.dart';
import 'package:gestaoApp/services/api.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:http/http.dart' as http;

void main() {
  initializeDateFormatting('pt_BR', null).then((_) => runApp(MyHomePage()));
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  Map<DateTime, List> _events;
  List _selectedEvents;
  bool addColaborator = false;
  AnimationController _animationController;
  CalendarController _calendarController;
  bool loading = false;
  String loadingId;

  @override
  void initState() {
    super.initState();
    getActivity();
    final _selectedDay = DateTime.now();
    loading = true;
    _events = {_selectedDay: []};

    _selectedEvents = _events[_selectedDay] ?? [];
    _calendarController = CalendarController();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _animationController.forward();
  }

  getActivity() async {
    var prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('@TOKEN');
    var accountId = prefs.getString("@ACCOUNTID");

    DateTime _now = new DateTime.now();
    DateTime date = new DateTime(_now.year, _now.month, _now.day);
    var newNow = '${date.year}-${date.month}-${date.day}';

    Map<DateTime, List> mapFetch = {};

    http.Response response =
        await http.get(Api.url + 'query-activity/$accountId', headers: {
      'Authorization': 'Bearer $token',
    });
    var data = json.decode(response.body);

    for (var date in data['data']) {
      var dayAPI = date['day'].split('-');

      DateTime createTime = DateTime(
          int.parse(dayAPI[0]), int.parse(dayAPI[1]), int.parse(dayAPI[2]));
      var original = mapFetch[createTime];
      if (original == null) {
        mapFetch[createTime] = [date];
      } else {
        mapFetch[createTime] = List.from(original)..addAll([date]);
      }
    }
    setState(() {
      _events = mapFetch;
      loading = false;
    });
    List<Map<String, dynamic>> list = List();
    for (var l in data['data']) {
      if (l['day'] == newNow) {
        list.add(l);
      }
    }
    List<dynamic> holidays = List();
    var tody = DateTime.now();
    _onDaySelected(tody, list, holidays);
  }

  @override
  void dispose() {
    _animationController.dispose();
    _calendarController.dispose();
    super.dispose();
  }

  void removeActivity(String id, snackBar, BuildContext context) async {
    this.setState(() {
      loadingId = id;
    });
    await http.delete(Api.url + 'remove-activity/$id');
    this.getActivity();
  }

  void _onDaySelected(DateTime day, List events, List holidays) {
    setState(() {
      _selectedEvents = events;
    });
  }

  void _onVisibleDaysChanged(
      DateTime first, DateTime last, CalendarFormat format) {}

  void _onCalendarCreated(
      DateTime first, DateTime last, CalendarFormat format) {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff537EFF),
        centerTitle: true,
        title: Text('Agenda de atividades',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
            )),
      ),
      body: Builder(
        builder: (context) {
          if (loading == true) {
            return Center(
              child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(Color(0xff537EFF)),
                  strokeWidth: 3.0),
            );
          } else {
            return Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'Criar atividade',
                      style: TextStyle(
                          color: Color(0xff537EFF),
                          fontWeight: FontWeight.bold),
                    ),
                    Padding(
                      padding: EdgeInsets.all(12),
                      child: SizedBox(
                        child: FloatingActionButton(
                          backgroundColor: Color(0xff537EFF),
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => AddActivity()));
                          },
                          child: Icon(Icons.add),
                        ),
                        width: 40,
                        height: 40,
                      ),
                    )
                  ],
                ),
                Card(
                  shadowColor: Color(0xFFC9D6FD),
                  margin: EdgeInsets.all(10),
                  elevation: 2,
                  child: _buildTableCalendar(),
                ),
                Expanded(child: _buildEventList()),
              ],
            );
          }
        },
      ),
    );
  }

  // Simple TableCalendar configuration (using Styles)
  Widget _buildTableCalendar() {
    return TableCalendar(
      calendarController: _calendarController,
      events: _events,
      locale: 'pt_BR',
      startingDayOfWeek: StartingDayOfWeek.monday,
      calendarStyle: CalendarStyle(
        selectedColor: Color(0xffC7DEFF),
        selectedStyle:
            TextStyle(color: Colors.black, fontWeight: FontWeight.w900),
        todayColor: Color(0xff537EFF),
        markersColor: Colors.brown[700],
        outsideDaysVisible: false,
      ),
      headerStyle: HeaderStyle(
        formatButtonTextStyle:
            TextStyle().copyWith(color: Colors.white, fontSize: 15.0),
        formatButtonDecoration: BoxDecoration(
          color: Colors.deepOrange[400],
          borderRadius: BorderRadius.circular(16.0),
        ),
      ),
      onDaySelected: _onDaySelected,
      initialSelectedDay: DateTime.now(),
      headerVisible: true,
      onVisibleDaysChanged: _onVisibleDaysChanged,
      onCalendarCreated: _onCalendarCreated,
    );
  }

  // More advanced TableCalendar configuration (using Builders & Styles)

  Widget _buildEventList() {
    return ListView(
      children: _selectedEvents
          .map((event) => Container(
              margin:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              child: Card(
                elevation: 2,
                color: Color(0xFFF6F8FF),
                child: ListTile(
                  leading: Icon(
                    Icons.calendar_today,
                    color: Colors.green[300],
                  ),
                  title: Text(
                    event['title'],
                    style: TextStyle(
                        color: Color(0xFF4F4F64), fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(event['description']),
                  trailing: Container(
                      alignment: Alignment.center,
                      width: 50,
                      child: Container(
                        margin: EdgeInsets.fromLTRB(0, 0, 20, 0),
                        child: loadingId == event['id']
                            ? SizedBox(
                                child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation(
                                        Color(0xff537EFF)),
                                    strokeWidth: 3.0),
                                height: 30.0,
                                width: 30.0,
                              )
                            : IconButton(
                                icon: Icon(
                                  Icons.delete,
                                  color: Colors.red[400],
                                ),
                                onPressed: () {
                                  return showDialog(
                                      context: context,
                                      // ignore: missing_return
                                      builder: (context) {
                                        return AlertDialog(
                                          title: Text(
                                            'Atenção!',
                                            style: TextStyle(color: Colors.red),
                                          ),
                                          content: Text(
                                              'Tem certeza que deseja remover está atividade?'),
                                          actions: [
                                            TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: Text('Não')),
                                            TextButton(
                                                onPressed: () {
                                                  var snackBar = SnackBar(
                                                      content: Text(
                                                          'Removido com sucesso'));
                                                  Navigator.pop(context);
                                                  removeActivity(event['id'],
                                                      snackBar, context);
                                                },
                                                child: Text('Sim'))
                                          ],
                                        );
                                      });
                                },
                              ),
                      )),
                ),
              )))
          .toList(),
    );
  }
}
