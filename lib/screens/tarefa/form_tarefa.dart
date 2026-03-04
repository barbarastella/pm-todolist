import 'package:flutter/material.dart';
import 'package:project_todolist/database/tarefaDao.dart';
import '../../model/tarefa.dart';
import '../../components/editor.dart';

class FormTarefa extends StatefulWidget {

  final Tarefa? tarefa;
  FormTarefa({this.tarefa});

  @override
  State<StatefulWidget> createState() {
    return FormTarefaState();
  }
}

class FormTarefaState extends State<FormTarefa> {
  TextEditingController _controllerDescricao = TextEditingController();
  TextEditingController _controllerObservacao = TextEditingController();
  int? _id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Formulário de tarefa")),
      floatingActionButton: FloatingActionButton(
        onPressed: () { criarTarefa(context); },
        child: Icon(Icons.save),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(children: <Widget>[
          Editor(_controllerDescricao, "Tarefa 1 teste", "descrição teste", Icons.task),
          Editor(_controllerObservacao, "Tarefa 2 teste", "observação teste")
        ]),
      ),
    );
  }

  void criarTarefa(BuildContext context) {
    TarefaDao _dao = TarefaDao();

    if (_id != null) { // alteração
      // exclamação garante que _id não será null nesta ocasião
      final _tarefa = Tarefa(_id!, widget.tarefa!.status, _controllerDescricao.text, _controllerObservacao.text,);
      _dao.update(_tarefa).then((id) => Navigator.pop(context));
    } else { // inclusão
      final _tarefa = Tarefa(0, 0, _controllerDescricao.text, _controllerObservacao.text,);
      _dao.add(_tarefa).then((id) => Navigator.pop(context));;
    }

    final SnackBar barraSnack = SnackBar(content: Text("Processo realizado com sucesso!"));
    ScaffoldMessenger.of(context).showSnackBar(barraSnack);
  }

  @override
  void initState() {
    super.initState();

    if (widget.tarefa != null) { // alteração
      _id = widget.tarefa!.id;
      _controllerDescricao.text = widget.tarefa!.descricao;
      _controllerObservacao.text = widget.tarefa!.obs;
    }
  }
}
