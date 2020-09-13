import 'package:flutter/material.dart';

import 'file:///D:/Projetos_OpII/trab3_opii_iagocosta/lib/view/lista_emprestimo.dart';

void main(){
    runApp(MaterialApp(
      theme: ThemeData(
          primaryColor: Colors.deepPurple,
          accentColor: Colors.blueAccent[700],
          buttonTheme: ButtonThemeData(
              buttonColor: Colors.deepPurpleAccent,
              textTheme: ButtonTextTheme.primary
          )
      ),
      home: Home(),
    ));
}