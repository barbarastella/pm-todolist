import 'package:flutter/material.dart';
import '../../database/tarefaDao.dart';
import '../../model/tarefa.dart';
import 'form_tarefa.dart';

// class ListaTarefa extends StatelessWidget {
class ListaTarefa extends StatefulWidget {
  // necessário para atualização do componente ao criar nova tarefa
  @override
  State<StatefulWidget> createState() {
    /* TarefaDao db = TarefaDao();

      db.add(Tarefa(0, 0, 'Tarefinha 1', 'observação da tarefinha 1')).then((id){print("ID: " + id.toString());});
      db.findAll().then((tarefa) => print(tarefa.toString())); */

    return ListaTarefaState();
  }
}

class ListaTarefaState extends State<ListaTarefa> {

  TarefaDao db = TarefaDao();

  @override
  Widget build(BuildContext context) {
    /* _tarefas.add(Tarefa(1, 0, "Título X", "Observação X"));
    _tarefas.add(Tarefa(1, 0, "Título Y", "Observação Y"));
    _tarefas.add(Tarefa(1, 0, "Título Z", "Observação Z")); */

    return Scaffold(
      appBar: AppBar(
        title: Text("To Do App"),
        backgroundColor: Colors.green[100],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final Future valorFuturo = Navigator.push(
            context,
            MaterialPageRoute( builder: (context) { return FormTarefa(); } ),
          );
          valorFuturo.then((x) {
            setState((){});
          });
        },
        child: Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Expanded(
              child: FutureBuilder<List<Tarefa>>(
                initialData: [],
                future: db.findAll(),
                builder: (context, snapshot) {
                  switch(snapshot.connectionState) {
                    case (ConnectionState.done):
                      if (snapshot.data != null ) {
                        List<Tarefa>? tarefas = snapshot.data;
                        return ListView.builder(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          itemCount: tarefas?.length,
                          itemBuilder: (context, index) { return ItemTarefa(tarefas![index]);}
                        );
                      } else { return Center(child: Text("else do switch: Carregando os dados.............")); }
                    default:
                      return Center(child: Text("default do switch: Carregando os dados.........."));
                  }
                }
              ),
            )]
        )
      )
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
        subtitle: Text(this._tarefa.obs),
      ),
    );
  }
}
