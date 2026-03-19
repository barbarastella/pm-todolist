import 'package:flutter/material.dart';
import '../screens/tarefa/lista_tarefa.dart';
import '../screens/gif/gifs.dart';

class Sidebar extends StatelessWidget {
  const Sidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
        Container(
        height: 85.0,
        width: double.infinity,
        alignment: Alignment.bottomLeft,
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(color: Colors.purple[50]),
      ),
          ListTile(
            leading: Icon(Icons.sticky_note_2_outlined),
            title: Text('Tarefas'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) => ListaTarefa()));
            },
          ),
          ListTile(
            leading: Icon(Icons.gif_box_outlined),
            title: Text('Gifs'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) => GifsPage()));
            },
          ),
        ],
      ),
    );
  }
}