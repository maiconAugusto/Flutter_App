import 'package:flutter/material.dart';

void main() => runApp(RemoveCollaborator());

class RemoveCollaborator extends StatefulWidget {
  @override
  _RemoveCollaborator createState() => _RemoveCollaborator();
}

class _RemoveCollaborator extends State<RemoveCollaborator> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red[800],
        ),
        body: Container(),
      ),
    );
  }
}
