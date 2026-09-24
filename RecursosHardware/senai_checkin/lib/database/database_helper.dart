// ignore_for_file: avoid_print

import 'package:senai_checkin/models/registro_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  // Criação do Banco de Dados

  static const String dbNome = "senai_checkin.db";
  static const String tableNome = "registros";

  static const String createTable = """
    CREATE TABLE IF NOT EXISTS $tableNome(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      data_hora TEXT NOT NULL,
      latitude REAL NOT NULL,
      longitude REAL NOT NULL,
      observacao TEXT NOT NULL,
      caminho_foto TEXT NOT NULL,
      cidade TEXT NOT NULL DEFAULT '')
    """
  ;

  // Método de conexão com o Banco de Dados
  // Método do tipo future (async) vou retornar o Banco de Dados
  Future<Database> getDB() async {
    return openDatabase(
      join(await getDatabasesPath(), dbNome),
      onCreate: (db, version) {
        return db.execute(createTable);
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          final columns = await db.rawQuery('PRAGMA table_info($tableNome)');
          final hasCidade = columns.any((column) => column['name'] == 'cidade');

          if (!hasCidade) {
            await db.execute(
              'ALTER TABLE $tableNome ADD COLUMN cidade TEXT NOT NULL DEFAULT ""',
            );
          }
        }
      },
      version: 2,
    );
  }

  // CRUD do Banco
  Future<void> create(Registro registro) async {
    try {
      final Database db = await getDB();
      await db.insert(tableNome, registro.toMap()); // Insere o dado no banco
    } catch (e) {
      print (e);
    }
  }

  // Método para buscar todos os registros
  Future<List<Registro>> read() async {
    try {
      final Database db = await getDB();

      final List<Map<String, dynamic>> maps = await db.query(tableNome);

      return maps.map((map) => Registro.fromMap(map)).toList();
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<void> delete(int id) async {
    try {
      final Database db = await getDB();
      await db.delete(
        tableNome,
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      print(e);
    }
  }
}