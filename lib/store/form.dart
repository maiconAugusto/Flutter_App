import 'package:mobx/mobx.dart';
part 'form.g.dart';

class FormCollaborator = _FormCollaborator with _$FormCollaborator;

abstract class _FormCollaborator with Store {
  @observable
  String avatar;
  @observable
  String urlPath;
  @observable
  String name;
  @observable
  String lastName;
  @observable
  String dateOfBirth;
  @observable
  String rg;
  @observable
  String cpf;
  @observable
  String phone;
  @observable
  String whatsApp;
  @observable
  String country;
  @observable
  String city;
  @observable
  String neighborhood;
  @observable
  String street;
  @observable
  String houseNumber;
  @observable
  String idCategorie;
  @observable
  String categorie;
  bool active;
  @observable
  String userId;
  @observable
  String accountId;
  String id;
  @observable
  double latitude;
  @observable
  double longitude;
  @observable
  bool observableUser;

  @observable
  List<String> countrys = [
    'Selecione o estado',
    'AC',
    'AL',
    'AP',
    'AM',
    'BA',
    'CE',
    'DF',
    'ES',
    'GO',
    'MA',
    'MT',
    'MS',
    'MG',
    'PA',
    'PB',
    'PR',
    'PE',
    'PI',
    'RJ',
    'RN',
    'RS',
    'RO',
    'RR',
    'SC',
    'SP',
    'SE',
    'TO',
  ];

  @action
  modifyId(String _id) {
    id = _id;
  }

  @action
  modifyObservableUser(bool _observableUser) {
    observableUser = _observableUser;
  }

  @action
  modifyLatitude(double _latitude) {
    latitude = _latitude;
  }

  @action
  modifyLongitude(double _longitude) {
    longitude = _longitude;
  }

  @action
  modifyUserId(String _userId) {
    userId = _userId;
  }

  @action
  modifyAccount(String _accountId) {
    accountId = _accountId;
  }

  @action
  modifyAvatar(String _avatar) {
    avatar = _avatar;
  }

  @action
  modifyAvatarUrlPath(String _urlPath) {
    urlPath = _urlPath;
  }

  @action
  modifyName(String _name) {
    name = _name;
  }

  @action
  modifyLastName(String _lastName) {
    lastName = _lastName;
  }

  @action
  modifyDateOfBirth(String _dateOfBirth) {
    dateOfBirth = _dateOfBirth;
  }

  @action
  modifyRg(String _rg) {
    rg = _rg;
  }

  @action
  modifyCpf(String _cpf) {
    cpf = _cpf;
  }

  @action
  modifyPhone(String _phone) {
    phone = _phone;
  }

  @action
  modifyWhatsApp(String _whatsApp) {
    whatsApp = _whatsApp;
  }

  @action
  modifyCountry(String _country) {
    country = _country;
  }

  @action
  modifyCity(String _city) {
    city = _city;
  }

  @action
  modifyNeighborhood(String _neighborhood) {
    neighborhood = _neighborhood;
  }

  @action
  modifyStreet(String _street) {
    street = _street;
  }

  @action
  modifyHouseNumber(String _houseNumber) {
    houseNumber = _houseNumber;
  }

  @action
  modifyIdCategorie(String _idCategorie) {
    idCategorie = _idCategorie;
  }

  @action
  modifyCategorie(String _categorie) {
    categorie = _categorie;
  }

  @action
  modifyActive(bool _active) {
    active = _active;
  }
}
