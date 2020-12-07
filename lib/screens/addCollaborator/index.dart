part of '../home/index.dart';

class AddCollaborator extends StatefulWidget {
  @override
  _AddCollaborator createState() => _AddCollaborator();
}

class _AddCollaborator extends State<AddCollaborator> {
  String categorie = 'Selecione uma categoria';
  String countrySelected = 'Selecione o estado';
  bool loading = false;
  bool activeCollaborator = true;
  bool observableCollaborator = true;
  List<Map<String, dynamic>> categories = List();

  getCategories() async {
    var prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('@TOKEN');

    http.Response response =
        await http.get(Api.url + 'query-all-category', headers: {
      'Authorization': 'Bearer $token',
    });
    var resp = json.decode(response.body);

    var destruct = resp['data'];

    List<Map<String, dynamic>> list = List();
    list.add({'categories': 'Selecione uma categoria', 'id': ''});

    for (var value in destruct) {
      list.add(value);
    }
    setState(() {
      categories = list;
    });
  }

  sendApi() async {
    var prefs = await SharedPreferences.getInstance();
    var accountId = prefs.getString('@ACCOUNTID');
    var userId = prefs.getString('@ID');
    setState(() {
      loading = true;
    });
    var data = json.encode({
      "name": values.name,
      "lastName": values.lastName,
      "cpf": values.cpf,
      "rg": values.rg,
      "phone": values.phone,
      "whatsApp": values.whatsApp,
      "dateOfBirth": values.dateOfBirth,
      "country": values.country,
      "city": values.city,
      "neighborhood": values.neighborhood,
      "street": values.street,
      "houseNumber": values.houseNumber,
      "idCategorie": values.idCategorie,
      "latitude": values.latitude,
      "longitude": values.longitude,
      "accountId": accountId,
      "userId": userId,
    });
    http.Response response = await http.post(Api.url + 'create-collaborator',
        headers: {"Content-type": "application/json; charset=UTF-8 "},
        body: data);
    if (response.statusCode == 200) {
      cleanData();
      setState(() {
        loading = false;
      });
    }
    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      activeCollaborator = values.active;
      observableCollaborator = values.observableUser;
    });
    this.getCategories();
  }

  void inactiveObservable(value) {
    values.modifyActive(false);
  }

  void inactiveCollaborator(value) {
    values.modifyActive(false);
  }

  @override
  void dispose() {
    super.dispose();
    cleanData();
  }

  cleanData() {
    values.modifyName(null);
    values.modifyLastName(null);
    values.modifyCpf(null);
    values.modifyRg(null);
    values.modifyPhone(null);
    values.modifyWhatsApp(null);
    values.modifyDateOfBirth(null);
    values.modifyCountry(null);
    values.modifyCity(null);
    values.modifyNeighborhood(null);
    values.modifyStreet(null);
    values.modifyHouseNumber(null);
    values.modifyAvatarUrlPath(null);
    values.modifyAvatar(null);
    values.modifyIdCategorie(null);
    values.modifyCategorie(null);
    values.modifyActive(null);
    values.modifyObservableUser(null);
    values.modifyId(null);
    values.modifyLatitude(null);
    values.modifyLongitude(null);
    values.modifyUserId(null);
    values.modifyAccount(null);
    values.modifyActive(null);
    values.modifyObservableUser(null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff537EFF),
        title: Text('Adicionar colaborador',
            style: TextStyle(color: Colors.white, fontSize: 16)),
        centerTitle: true,
      ),
      body: Builder(
        // ignore: missing_return
        builder: (context) {
          if (loading == true) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 5, 0, 0),
                    child: Text('Salvando...'),
                  )
                ],
              ),
            );
          } else {
            return ListView(
              children: [
                Observer(
                  builder: (context) {
                    return Container(
                      margin: EdgeInsets.fromLTRB(15, 40, 15, 10),
                      child: TextFormField(
                        maxLengthEnforced: true,
                        initialValue: values.name,
                        maxLength: 18,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Nome é obrigatório';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            labelText: 'Nome',
                            labelStyle: TextStyle(fontSize: 12)),
                        onChanged: (value) {
                          values.modifyName(value);
                        },
                      ),
                    );
                  },
                ),
                Observer(
                  builder: (context) {
                    return Container(
                      margin: EdgeInsets.fromLTRB(15, 10, 15, 10),
                      child: TextFormField(
                        initialValue: values.lastName,
                        maxLength: 30,
                        maxLengthEnforced: true,
                        decoration: InputDecoration(
                            labelText: 'Sobrenome',
                            labelStyle: TextStyle(fontSize: 12)),
                        onChanged: (value) {
                          values.modifyLastName(value);
                        },
                      ),
                    );
                  },
                ),
                Observer(
                  builder: (context) {
                    return Container(
                      margin: EdgeInsets.fromLTRB(15, 10, 15, 10),
                      child: TextFormField(
                        initialValue: values.dateOfBirth,
                        maxLength: 10,
                        keyboardType: TextInputType.datetime,
                        decoration: InputDecoration(
                            labelText: 'Data de nascimento  (DD/MM/AAAA)',
                            labelStyle: TextStyle(fontSize: 12)),
                        onChanged: (value) {
                          values.modifyDateOfBirth(value);
                        },
                      ),
                    );
                  },
                ),
                Observer(
                  builder: (context) {
                    return Container(
                      margin: EdgeInsets.fromLTRB(15, 10, 15, 10),
                      child: TextFormField(
                        initialValue: values.rg,
                        maxLengthEnforced: true,
                        maxLength: 14,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            labelText: 'RG',
                            labelStyle: TextStyle(fontSize: 12)),
                        onChanged: (value) {
                          values.modifyRg(value);
                        },
                      ),
                    );
                  },
                ),
                Observer(
                  builder: (context) {
                    return Container(
                      margin: EdgeInsets.fromLTRB(15, 10, 15, 10),
                      child: TextFormField(
                        initialValue: values.cpf,
                        maxLength: 14,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            labelText: 'CPF  (000.000.000-00)',
                            labelStyle: TextStyle(fontSize: 12)),
                        onChanged: (value) {
                          values.modifyCpf(value);
                        },
                      ),
                    );
                  },
                ),
                Observer(
                  builder: (context) {
                    return Container(
                      margin: EdgeInsets.fromLTRB(15, 10, 15, 10),
                      child: TextFormField(
                        initialValue: values.phone,
                        maxLength: 15,
                        maxLengthEnforced: true,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                            labelText: 'Telefone  ((DD) 00000-0000)',
                            labelStyle: TextStyle(fontSize: 12)),
                        onChanged: (value) {
                          values.modifyPhone(value);
                        },
                      ),
                    );
                  },
                ),
                Observer(
                  builder: (context) {
                    return Container(
                      margin: EdgeInsets.fromLTRB(15, 10, 15, 10),
                      child: TextFormField(
                        initialValue: values.whatsApp,
                        maxLength: 15,
                        maxLengthEnforced: true,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                            labelText: 'WhatsApp  ((DD) 00000-0000)',
                            labelStyle: TextStyle(fontSize: 12)),
                        onChanged: (value) {
                          values.modifyWhatsApp(value);
                        },
                      ),
                    );
                  },
                ),
                Observer(
                  builder: (context) {
                    return Container(
                      margin: EdgeInsets.fromLTRB(15, 10, 15, 10),
                      child: DropdownButtonFormField(
                        value: values.country,
                        decoration: InputDecoration(
                          hintText: 'Selecione o estado - OBRIGATÓRIO',
                          hintStyle: TextStyle(fontSize: 12),
                          fillColor: Colors.white,
                          errorStyle: TextStyle(color: Colors.red),
                        ),
                        onChanged: (value) {
                          values.modifyCountry(value);
                        },
                        validator: (value) {
                          if (value == 'Selecione o estado') {
                            print('yes');
                            return "Selecione um estado!";
                          }
                        },
                        items: values.countrys.map((map) {
                          return DropdownMenuItem(
                            value: map,
                            child: Text(
                              map,
                              style: TextStyle(fontSize: 12),
                            ),
                          );
                        }).toList(),
                      ),
                    );
                  },
                ),
                Observer(
                  builder: (context) {
                    return Container(
                      margin: EdgeInsets.fromLTRB(15, 10, 15, 10),
                      child: TextFormField(
                        initialValue: values.city,
                        maxLength: 30,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            labelText: 'Cidade',
                            labelStyle: TextStyle(fontSize: 12)),
                        onChanged: (value) {
                          values.modifyCity(value);
                        },
                      ),
                    );
                  },
                ),
                Observer(
                  builder: (context) {
                    return Container(
                      margin: EdgeInsets.fromLTRB(15, 10, 15, 10),
                      child: TextFormField(
                        initialValue: values.neighborhood,
                        maxLength: 20,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            labelText: 'Bairro',
                            labelStyle: TextStyle(fontSize: 12)),
                        onChanged: (value) {
                          values.modifyNeighborhood(value);
                        },
                      ),
                    );
                  },
                ),
                Observer(
                  builder: (context) {
                    return Container(
                      margin: EdgeInsets.fromLTRB(15, 10, 15, 10),
                      child: TextFormField(
                        initialValue: values.street,
                        maxLength: 20,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            labelText: 'Rua',
                            labelStyle: TextStyle(fontSize: 12)),
                        onChanged: (value) {
                          values.modifyStreet(value);
                        },
                      ),
                    );
                  },
                ),
                Observer(
                  builder: (context) {
                    return Container(
                      margin: EdgeInsets.fromLTRB(15, 10, 15, 10),
                      child: TextFormField(
                        initialValue: values.houseNumber,
                        maxLength: 8,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            labelText: 'Numero',
                            labelStyle: TextStyle(fontSize: 12)),
                        onChanged: (value) {
                          values.modifyHouseNumber(value);
                        },
                      ),
                    );
                  },
                ),
                Observer(
                  builder: (context) {
                    return Container(
                      margin: EdgeInsets.fromLTRB(15, 10, 15, 10),
                      child: DropdownButtonFormField(
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          hintStyle: TextStyle(fontSize: 14),
                          hintText: 'Selecione uma categoria - OBRIGATÓRIO',
                          errorStyle: TextStyle(color: Colors.red),
                        ),
                        value: values.categorie,
                        validator: (value) {
                          if (value == 'Selecione uma categoria') {
                            return 'Selecione uma categoria!';
                          }
                        },
                        onChanged: (value) {
                          values.modifyCategorie(value);
                        },
                        items: categories.map((map) {
                          return DropdownMenuItem(
                            onTap: () {
                              values.modifyIdCategorie(map['id']);
                              print('aa $map');
                            },
                            value: map['categories'],
                            child: Text(
                              map['categories'],
                              style: TextStyle(fontSize: 12),
                            ),
                          );
                        }).toList(),
                      ),
                    );
                  },
                ),
                Observer(
                  builder: (context) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          margin: EdgeInsets.fromLTRB(15, 20, 0, 0),
                          child: Text(
                            'Obter localização',
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(0, 20, 15, 10),
                          child: FloatingActionButton(
                            heroTag: 'maps',
                            backgroundColor: values.latitude != null ||
                                    values.longitude != null
                                ? Colors.green
                                : Colors.red,
                            child: Icon(Icons.person_pin_circle),
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => Localization(),
                              ));
                            },
                          ),
                        )
                      ],
                    );
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 200,
                      margin: EdgeInsets.fromLTRB(15, 20, 0, 0),
                      child: Text('Localização por GPS ativo',
                          style: TextStyle(fontSize: 15)),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 20, 15, 10),
                      child: FloatingActionButton(
                        heroTag: 'inactiveGPS',
                        backgroundColor: Colors.green,
                        child: Icon(observableCollaborator == true
                            ? Icons.gps_fixed
                            : Icons.gps_off),
                        onPressed: () {},
                      ),
                    )
                  ],
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(0, 40, 0, 0),
                  child: RaisedButton(
                    padding: EdgeInsets.fromLTRB(130, 20, 130, 20),
                    elevation: 5,
                    color: Colors.green,
                    onPressed: () {
                      return showDialog(
                        context: context,
                        builder: (context) {
                          if (values.name == null) {
                            return AlertDialog(
                              title: Text('Atenção!',
                                  style: TextStyle(color: Colors.red)),
                              content: Text(
                                  'Informe o nome, este campo é obrigatório!'),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text('Ok! eu entendi!'))
                              ],
                            );
                          }
                          if (values.country == null) {
                            return AlertDialog(
                              elevation: 10,
                              title: Text('Atenção!',
                                  style: TextStyle(color: Colors.red)),
                              content: Text(
                                  'Selecione um estado, este campo é obrigatório!'),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text('Ok! eu entendi!'))
                              ],
                            );
                          }
                          if (values.idCategorie == null) {
                            return AlertDialog(
                              title: Text('Atenção!',
                                  style: TextStyle(color: Colors.red)),
                              content: Text(
                                  'Selecione uma categoria, este campo é obrigatório!'),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text('Ok! eu entendi!'))
                              ],
                            );
                          } else {
                            sendApi();
                          }
                        },
                      );
                      // final snackBar = SnackBar(
                      //   backgroundColor: Colors.green,
                      //   padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                      //   content: Text('Edição salva com sucesso',
                      //       style: TextStyle(color: Colors.white)),
                      // );
                      // Scaffold.of(context).showSnackBar(snackBar);
                    },
                    child: Text(
                      'Salvar',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                )
              ],
            );
          }
        },
      ),
    );
  }
}
