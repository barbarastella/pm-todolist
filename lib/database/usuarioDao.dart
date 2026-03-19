import 'package:sqflite/sqflite.dart';
import '../model/usuario.dart';
import 'database.dart';

class UsuarioDao {
  final String _tableName = "usuarios";

  Map<String, dynamic> toMap(Usuario usuario) {
    final Map<String, dynamic> usuarioMap = Map();

    usuarioMap['id'] = usuario.id;
    usuarioMap['nome'] = usuario.nome;
    usuarioMap['sobrenome'] = usuario.sobrenome;
    usuarioMap['logradouro'] = usuario.logradouro;
    usuarioMap['bairro'] = usuario.bairro;
    usuarioMap['cidade'] = usuario.cidade;
    usuarioMap['uf'] = usuario.uf;
    usuarioMap['cep'] = usuario.cep;

    return usuarioMap;
  }

  List<Usuario> toList(List<Map<String, dynamic>> result) {
    final List<Usuario> usuarios = [];

    for (Map<String, dynamic> row in result) {
      Usuario usuario = Usuario(
        row['id'],
        row['nome'],
        row['sobrenome'],
        row['logradouro'],
        row['bairro'],
        row['cidade'],
        row['uf'],
        row['cep'],
      );

      usuarios.add(usuario);
    }
    return usuarios;
  }

  Future<int> add(Usuario usuario) async {
    Database db = await getDatabase();
    Map<String, dynamic> usuarioMap = toMap(usuario);

    return db.insert(_tableName, usuarioMap);
  }

  Future<int> update(Usuario usuario) async {
    Database db = await getDatabase();
    Map<String, dynamic> usuarioMap = toMap(usuario);

    return db.update(
      _tableName,
      usuarioMap,
      where: 'id = ?',
      whereArgs: [usuario.id],
    );
  }

  Future<int> delete(int id) async {
    Database db = await getDatabase();
    return db.delete(_tableName, where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Usuario>> findAll() async {
    Database db = await getDatabase();
    List<Map<String, dynamic>> result = await db.query(_tableName);

    List<Usuario> usuarios = toList(result);
    return usuarios;
  }
}
