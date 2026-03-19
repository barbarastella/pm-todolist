class Usuario {
  int id;
  String nome;
  String sobrenome;
  String logradouro;
  String bairro;
  String cidade;
  String uf;
  String cep;

  Usuario(this.id, this.nome, this.sobrenome, this.logradouro, this.bairro, this.cidade, this.uf, this.cep);

  @override
  String toString() {
    return 'Usuario{id: $id | nome: $nome $sobrenome | endereco: $logradouro, $bairro. $cidade - $uf. $cep}';
  }
}