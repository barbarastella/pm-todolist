import 'package:flutter/material.dart';
import '../../model/tarefa.dart';
import 'form_tarefa.dart';

// class ListaTarefa extends StatelessWidget {
class ListaTarefa extends StatefulWidget {  // necessário para atualização do componente ao criar nova tarefa
  @override
  State<StatefulWidget> createState() {
   return ListaTarefaState();
  }
}

class ListaTarefaState extends State<ListaTarefa> {
  List<Tarefa> _tarefas = [];

  @override
  Widget build(BuildContext context) {

    /* _tarefas.add(Tarefa(1, 0, "Título X", "Observação X"));
    _tarefas.add(Tarefa(1, 0, "Título Y", "Observação Y"));
    _tarefas.add(Tarefa(1, 0, "Título Z", "Observação Z")); */

    return Scaffold(
      appBar: AppBar(title: Text("To Do App"), backgroundColor: Colors.green[100]),
      floatingActionButton: FloatingActionButton(
          onPressed: (){
            final Future valorFuturo = Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) { return FormTarefa(); }
                ));

            valorFuturo.then((novaTarefa) {
              print("retornou a tarefa");
              print(novaTarefa);
              setState(() {
                _tarefas.add(novaTarefa);
              });
            });
          },
          child: Icon(Icons.add)
      ),
      body: ListView.builder( // colocar pelos objetos da lista
          itemCount: _tarefas.length,
          itemBuilder: (context, indice) {
            final tarefa = _tarefas[indice];
            return ItemTarefa(tarefa);
          }
      ),
      /* Column(children: <Widget>[ // colocar de forma estática
         ItemTarefa(Tarefa(1, 0, "Título da tarefa 1", "Subtítulo da tarefa 1")),
         ItemTarefa(Tarefa(2, 0, "Título da tarefa 2", "Subtítulo da tarefa 2"))
       ]) */
    );
  }
}

class ItemTarefa extends StatelessWidget {
  final Tarefa _tarefa; // _ indica que o atributo é privado
  ItemTarefa(this._tarefa);

  @override
  Widget build(BuildContext context) {
    return Card(
        child: ListTile(
            leading: Icon(Icons.add_circle_outline),
            title: Text(this._tarefa.descricao),
            subtitle: Text(this._tarefa.obs)
        )
    );
  }
}
