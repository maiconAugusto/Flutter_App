part of '../home/index.dart';

class SearchCollaborator extends StatefulWidget {
  @override
  _SearchCollaborator createState() => _SearchCollaborator();
}

class _SearchCollaborator extends State<SearchCollaborator> {
  bool removing = false;
  String idRemoving;
  TextEditingController name = TextEditingController();
  bool loading = false;
  bool verifyIcon = true;
  List<Map<String, dynamic>> collaborators = List();

  getCollaborators() async {
    var prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('@TOKEN');
    var accountId = prefs.getString('@ACCOUNTID');

    this.setState(() {
      verifyIcon = false;
      loading = true;
    });

    http.Response response = await http.get(
        Api.url + 'query-collaborator?name=${name.text}&id=$accountId',
        headers: {
          'Authorization': 'Bearer $token',
        });

    if (response.statusCode != 200) {
      setState(() {
        loading = false;
      });
    }

    List<Map<String, dynamic>> data = List();

    var destruct = json.decode(response.body);
    var resp = destruct['data'];

    for (var list in resp) {
      data.add(list);
    }
    setState(() {
      collaborators = data;
      loading = false;
    });
  }

  inactivateCollaborator(index, id) async {
    setState(() {
      removing = true;
    });
    var data = json.encode({"active": false});

    http.Response response = await http.put(
      Api.url + 'update-collaborator/$id',
      headers: {"Content-type": "application/json; charset=UTF-8 "},
      body: data,
    );

    if (response.statusCode == 200) {
      collaborators.removeAt(index);
      List<Map<String, dynamic>> inactiveCollaborator = collaborators;
      setState(() {
        collaborators = inactiveCollaborator;
        removing = false;
        idRemoving = null;
      });
    }
  }

  editCollaborator(collaborator) {
    values.modifyName(collaborator['collaborator']['name']);
    values.modifyLastName(collaborator['collaborator']['lastName']);
    values.modifyCpf(collaborator['collaborator']['cpf']);
    values.modifyRg(collaborator['collaborator']['rg']);
    values.modifyPhone(collaborator['collaborator']['phone']);
    values.modifyWhatsApp(collaborator['collaborator']['whatsApp']);
    values.modifyDateOfBirth(collaborator['collaborator']['dateOfBirth']);
    values.modifyCountry(collaborator['collaborator']['country']);
    values.modifyCity(collaborator['collaborator']['city']);
    values.modifyNeighborhood(collaborator['collaborator']['neighborhood']);
    values.modifyStreet(collaborator['collaborator']['street']);
    values.modifyHouseNumber(collaborator['collaborator']['houseNumber']);
    values.modifyAvatarUrlPath(collaborator['collaborator']['avatar_url_path']);
    values.modifyAvatar(collaborator['collaborator']['avatar']);
    values.modifyIdCategorie(collaborator['collaborator']['idCategorie']);
    values.modifyCategorie(collaborator['categories']);
    values.modifyActive(collaborator['collaborator']['active']);
    values.modifyObservableUser(collaborator['collaborator']['observable']);
    values.modifyId(collaborator['collaborator']['id']);
    values.modifyLatitude(collaborator['collaborator']['latitude']);
    values.modifyLongitude(collaborator['collaborator']['longitude']);
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => Forms()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xff537EFF),
          centerTitle: true,
          title: Text('Procurar colaborador',
              style: TextStyle(color: Colors.white, fontSize: 18)),
        ),
        body: ListView(
          children: [
            Column(
              children: [
                Container(
                  height: 100,
                  margin: EdgeInsets.fromLTRB(40, 30, 40, 20),
                  child: TextField(
                    autofocus: false,
                    controller: name,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xff537EFF))),
                        suffixIcon: verifyIcon == true
                            ? Icon(Icons.search)
                            : IconButton(
                                icon: Icon(Icons.clear),
                                onPressed: () {
                                  this.setState(() {
                                    name.clear();
                                    collaborators = [];
                                    verifyIcon = true;
                                  });
                                }),
                        labelStyle: TextStyle(fontSize: 14),
                        labelText: 'Colaborador'),
                    onChanged: (value) {
                      getCollaborators();
                    },
                  ),
                ),
                Container(
                  height: 500,
                  child: Builder(
                    builder: (context) {
                      if (loading == true) {
                        return Center(
                          child: CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation(Color(0xff537EFF)),
                              strokeWidth: 3.0),
                        );
                      } else {
                        return ListView.builder(
                          itemCount: collaborators.length,
                          itemBuilder: (context, index) {
                            return (Card(
                              color: Color(0xffEFF3FF),
                              elevation: 1,
                              child: ListTile(
                                  leading: collaborators[index]['collaborator']
                                              ['avatar'] ==
                                          null
                                      ? Icon(Icons.person)
                                      : CircleAvatar(
                                          backgroundColor: Colors.white,
                                          backgroundImage: NetworkImage(
                                              collaborators[index]
                                                  ['collaborator']['avatar']),
                                        ),
                                  title: Text(
                                    collaborators[index]['collaborator']
                                        ['name'],
                                    style: TextStyle(color: Color(0xFF4F4F64)),
                                  ),
                                  subtitle:
                                      Text(collaborators[index]['categories']),
                                  trailing: Container(
                                    width: 100,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        IconButton(
                                            icon: Icon(Icons.edit,
                                                color: Colors.amber),
                                            onPressed: () {
                                              editCollaborator(
                                                  collaborators[index]);
                                            }),
                                        Builder(
                                          builder: (context) {
                                            if (removing == true &&
                                                idRemoving ==
                                                    collaborators[index]
                                                            ['collaborator']
                                                        ['id']) {
                                              return CircularProgressIndicator();
                                            } else {
                                              return IconButton(
                                                  icon: Icon(
                                                    Icons.delete,
                                                    color: Colors.red,
                                                  ),
                                                  onPressed: () {
                                                    this.setState(() {
                                                      idRemoving = collaborators[
                                                                  index]
                                                              ['collaborator']
                                                          ['id'];
                                                    });
                                                    inactivateCollaborator(
                                                        index,
                                                        collaborators[index]
                                                                ['collaborator']
                                                            ['id']);
                                                  });
                                            }
                                          },
                                        )
                                      ],
                                    ),
                                  )),
                            ));
                          },
                        );
                      }
                    },
                  ),
                )
              ],
            ),
          ],
        ));
  }
}
