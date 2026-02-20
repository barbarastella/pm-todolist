import 'package:flutter/material.dart';
import 'screens/tarefa/lista_tarefa.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(
    MaterialApp(
      home: ListaTarefa(),
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.blue[50],
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.purple,
          brightness: Brightness.light,
        ),
        textTheme: TextTheme(
          displayLarge: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
          titleLarge: TextStyle(
            fontSize: 30,
            fontFamily: GoogleFonts.lato().fontFamily,
            fontStyle: FontStyle.italic,
          ),
        ),
      ),
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

