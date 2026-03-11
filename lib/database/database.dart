import "package:sqflite/sqflite.dart";
import 'package:path/path.dart';

Future<Database> getDatabase() async {
  String tableSql =
      'CREATE TABLE tarefas('
      ' id INTEGER PRIMARY KEY,'
      ' descricao TEXT,'
      ' obs TEXT,'
      ' status INTEGER);';

  String tableSql2 =
      'CREATE TABLE cursos ('
      ' id INTEGER PRIMARY KEY,'
      ' nome TEXT,'
      ' descricao TEXT);';

  String path = join(await getDatabasesPath(), 'dbtarefas.db');

  return openDatabase(
    path,
    onCreate: (db, version) {
      db.execute(tableSql);
      print("db_v1: tabela TAREFAS criada com sucesso!");
    },
    onUpgrade: (db, oldVersion, newVersion) {
      if (newVersion == 2) {
        db.execute(tableSql2);
        print("db_v2: tabela CURSOS criada com sucesso!");
      }
    },
    onDowngrade: onDatabaseDowngradeDelete, // excluir toda a base de dados
    version: 1,
  );
}
