// Ajudante de conexão com o dataBase(DB)
import 'package:exemplo_sqflite/nota_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class NotaDbhelper {
  // Atributos
  static const String db_nome = "notas.db";
  static const String table_nome = "notas";
  static const String create_table = """
    CREATE TABLE IF NOT EXISTS $table_nome(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    titulo TEXT NOT NULL,
    conteudo TEXTO NOT NULL)""";

  // MÉTODO DE CONEXÃO do Aplicativo ao Banco de Dados
  // Método do tipo future (Async) vau retornar o Banco de dados
  Future<Database> _getDB() async { //async
    return openDatabase(
      // Colocar o endereço do DB
      join(await getDatabasesPath(), db_nome),
      onCreate: (db, version) { // Se é a primeira vez que está sendo executado, ele irá criar o DB
        return db.execute(create_table);
      },
      version: 1,
    );
  } // Retorna o banco de dados no final

  // CRUD do Banco de Dados (Controller)

  // Create
  void create(Nota nota) async {
    try {
      final Database db = await _getDB();
      await db.insert(table_nome, nota.toMap()); // Insere o dado no banco
    } catch (e) {
      print(e);
      return;
    }
  }

  // Read
  Future<List<Nota>> getNotas() async {
    try {
      final Database db = await _getDB(); // Estabelece a conexão
      final List<Map<String,dynamic>> maps = await db.query(table_nome); // Pega todos os dados do banco
      // Converter o MAP em List<Nota>
      return List.generate(maps.length, (e) => Nota.fromMap(maps[e]));
    } catch (e) {
      print(e);
      return [];
    }
  }

  // Update
  void updateNota(Nota nota) async {
    try {
      final Database db = await _getDB();
      await db.update(table_nome, nota.toMap(), where: "id = ?", whereArgs: [nota.id]);
      // Atualiza a nota a partir do ID
    } catch (e) {
      print(e);
      return;
    }
  }

  // Delete
  void deleteNota (int id) async {
    try {
      final Database db = await _getDB();
      await db.delete(table_nome, where: "id = ?", whereArgs: [id]);
    } catch (e) {
      print(e);
      return;
    }
  }
}