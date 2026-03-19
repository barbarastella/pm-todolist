import "package:sqflite/sqflite.dart";
import 'package:path/path.dart';

Future<Database> getDatabase() async {
  String tableTarefas =
      'CREATE TABLE tarefas('
      ' id INTEGER PRIMARY KEY,'
      ' descricao TEXT,'
      ' obs TEXT,'
      ' status INTEGER);';

  String tableUsuarios =
      'CREATE TABLE usuarios('
      ' id INTEGER PRIMARY KEY,'
      ' nome TEXT,'
      ' sobrenome TEXT,'
      ' logradouro TEXT,'
      ' numero TEXT,'
      ' bairro TEXT,'
      ' cidade TEXT,'
      ' uf TEXT,'
      ' cep TEXT);';

  String path = join(await getDatabasesPath(), 'dbtarefas.db'); // nome do db

  return openDatabase(
    path,
    onCreate: (db, version) {
      db.execute(tableTarefas);
      db.execute(tableUsuarios);
    },
    onUpgrade: (db, oldVersion, newVersion) {
      if (oldVersion == 1) {
        db.execute(tableUsuarios);
      }
      if (oldVersion == 2) {
        db.execute("ALTER TABLE usuarios ADD COLUMN numero TEXT DEFAULT '';");
      }
    },
    onDowngrade: onDatabaseDowngradeDelete, // excluir o db
    version: 3,
  );
}
