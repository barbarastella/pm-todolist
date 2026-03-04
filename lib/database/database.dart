import "package:sqflite/sqflite.dart";
import 'package:path/path.dart';

Future<Database> getDatabase() async {
  String tableSql =
      'CREATE TABLE tarefas('
      ' id INTEGER PRIMARY KEY,'
      ' descricao TEXT,'
      ' obs TEXT,'
      ' status INTEGER);';

  String path = join(await getDatabasesPath(), 'dbtarefas.db');

  return openDatabase(
    path,
    onCreate: (db, version) {
      db.execute(tableSql);
      print("Tabela criada!");
    },
    version: 1,
  );
}
