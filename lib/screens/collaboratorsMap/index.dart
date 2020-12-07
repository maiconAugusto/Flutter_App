import 'package:flutter/material.dart';
import 'package:gestaoApp/components/maps/index.dart';

void main() => runApp(Collaborators());

class Collaborators extends StatefulWidget {
  _Collaborators createState() => _Collaborators();
}

class _Collaborators extends State<Collaborators> {
  @override
  Widget build(BuildContext context) {
    return Maps();
  }
}
