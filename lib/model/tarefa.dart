class Tarefa {
  int id;
  int status;
  String descricao;
  String obs;

  Tarefa(this.id, this.status, this.descricao, this.obs);

  @override
  String toString() {
    return 'Tarefa{descricao: $descricao, obs: $obs}';
  }
}