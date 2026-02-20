import 'package:flutter/material.dart';
import '../../model/tarefa.dart';

class FormTarefa extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return FormTarefaState();
  }
}

class FormTarefaState extends State<FormTarefa> {
  TextEditingController _controllerDescricao = TextEditingController();
  TextEditingController _controllerObservacao = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Formulário de tarefa")),
      floatingActionButton: FloatingActionButton(
          onPressed: (){
            final _tarefa = Tarefa(0, 0, _controllerDescricao.text, _controllerObservacao.text);
            Navigator.pop(context, _tarefa);

            final SnackBar barraSnack = SnackBar(content: Text("Tarefa criada com sucesso"));
            ScaffoldMessenger.of(context).showSnackBar(barraSnack);
          },
          child: Icon(Icons.save)
      ),
      body: Column(children: <Widget>[
        Padding(
            padding: EdgeInsets.all(16.0),
            child: TextField(
              controller: _controllerDescricao,
              style: TextStyle(fontSize: 18.0),
              decoration: InputDecoration(
                  icon: Icon(Icons.chat),
                  labelText: "Tarefa",
                  hintText: "Informe o título da tarefa"
              ),
            )
        ),
        Padding(
          padding: EdgeInsets.all(16.0),
          child: TextField(
            controller: _controllerObservacao,
            style: TextStyle(fontSize: 18.0),
            decoration: InputDecoration(
                icon: Icon(Icons.chat),
                labelText: "Observação",
                hintText: "Informe a observação da tarefa"
            ),
          ),
        ),
      ]),
    );
  }
}