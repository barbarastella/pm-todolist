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
            MaterialPageRoute(
              builder: (context) {
                return FormTarefa();
              },
            ),
          );
          valorFuturo.then((x) {
            setState(() {});
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
                  switch (snapshot.connectionState) {
                    case (ConnectionState.done):
                      if (snapshot.data != null) {
                        List<Tarefa>? tarefas = snapshot.data;
                        return ListView.builder(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          itemCount: tarefas?.length,
                          itemBuilder: (context, index) {
                            return ItemTarefa(context, tarefas![index]);
                          },
                        );
                      } else {
                        return Center(
                          child: Text(
                            "else do switch: Carregando os dados.............",
                          ),
                        );
                      }
                    default:
                      return Center(
                        child: Text(
                          "default do switch: Carregando os dados..........",
                        ),
                      );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget ItemTarefa(BuildContext context, Tarefa tarefa) {
    bool isChecked;

    if (tarefa.status == 1)
      isChecked = true;
    else
      isChecked = false;

    return GestureDetector(
      onTap: () {
        Future future = Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return FormTarefa(tarefa: tarefa);
            },
          ),
        );
        future.then((value) => setState(() {}));
      },
      child: Card(
        child: ListTile(
          leading: Checkbox(
            value: isChecked,
            checkColor: Colors.white,
            activeColor: Colors.green,
            onChanged: (bool? value) {
              setState(() {
                _atualizar(context, tarefa, value == true ? 1 : 0);
              });
            },
          ),
          title: Text(tarefa.descricao),
          subtitle: Text(tarefa.obs),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  _confirmarExclusao(context, tarefa.id);
                },
                child: Icon(Icons.delete),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _confirmarExclusao(BuildContext context, int id) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text("Atenção!"),
          content: Text(
            "Tem certeza que deseja excluir permanentemente esta tarefa?",
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: Text("Cancelar", style: TextStyle(color: Colors.red)),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                _excluir(context, id);
              },
              child: Text("Confirmar", style: TextStyle(color: Colors.green)),
            ),
          ],
        );
      },
    );
  }

  void _excluir(BuildContext context, int id) {
    db.delete(id).then((value) => setState(() {}));
  }

  void _atualizar(BuildContext context, Tarefa tarefa, int status) {
    Tarefa ta = Tarefa(tarefa.id, status, tarefa.descricao, tarefa.obs);
    db.update(ta); //.then((value) => setState(() {}));
  }
}
