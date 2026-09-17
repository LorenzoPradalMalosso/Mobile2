import 'package:senai_checkin/models/registro_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  // Criação do Banco de Dados
  // ignore: constant_identifier_names
  static const String db_nome = "senai_checkin.db";
  static const String table_nome = "registros";
  static const String create_table = """
    CREATE TABLE IF NOT EXISTS $table_nome(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      data_hora TEXT NOT NULLM,
      latitude REAL NOT NULL,
      longitude REAL NOT NULL,
      observacao TEXT NOT NULL,
      caminho_foto TEXT NOT NULL)""";

  // Método de conexão com o Banco de Dados
  // Método do tipo future (async) vou retornar o Banco de Dados
  Future<Database> _getDB() async {
    return openDatabase(
      // Colocar o endereço do DB
      join(await getDatabasesPath(), db_nome),
      onCreate: (db, version) { // Se é a primeira vez executando, ele irá criar o DB
        return db.execute(create_table);
      },
      version: 1,
    );
  }

  // CRUD do Banco
  void create(Registro registro) async {
    try {
      final Database db = await _getDB();
      await db.insert(table_nome, registro.toMap()); // Insere o dado no banco
    } catch (e) {
      print (e);
      return;
    }
  }
}