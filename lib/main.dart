import 'package:flutter/material.dart';
import 'screens/tarefa/lista_tarefa.dart';

void main() {
  runApp(
    MaterialApp(
      home: ListaTarefa(),
      /*Scaffold(
        appBar: AppBar(title: Text("To Do App")),
        floatingActionButton: FloatingActionButton(
            onPressed: (){print("Clicou no botão"); },
            child: Icon(Icons.add)
        ),
        body: Column(children: <Widget>[
           Card(
              child: ListTile(
                  leading: Icon(Icons.add_circle_outline),
                  title: Text("Tarefa 1"),
                  subtitle: Text("Iniciar To Do App.")
              )
          ),
          Card(
              child: ListTile(
                  leading: Icon(Icons.add_circle_outlined),
                  title: Text("Tarefa 2"),
                  subtitle: Text("Concluir To Do App.")
              )
          )
          ]) */
    ),
  );
}

