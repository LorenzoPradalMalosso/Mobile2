import 'package:path/path.dart';
import 'package:sa_petshop_sqlite/models/pet_model.dart';
import 'package:sa_petshop_sqlite/models/consulta_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

class DatabaseHelper {
  // Transforma essa classe em singleton
  // Não permite instanciar outro obj enquanto um obj estiver ativo
  static final DatabaseHelper _instance = DatabaseHelper._internal();

  // Construir o Singleton
  // Essa Classe não possui um Construtor Normal,
  // ele precisa do factory para estabelecer a conexão
  DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  // Conector do Banco de Dados
  Database? _database; // Privado

  // get database
  Future<Database> get database async{
    if(_database != null) return _database!;
    _database = await _initDb();
    return _database!;
  }

  Future<Database> _initDb() async{
    // Pegar o armazenamento do banco
    String path = join(await getDatabasesPath(), "petshop.db");
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async{
        await db.execute(
          '''CREATE TABLE pets(
          id INTEGER PRIMARY KEY AUTOINCREMENT, 
          nome TEXT, raca TEXT, 
          nomeDono TEXT, 
          telefoneDono TEXT)''');
        await db.execute(
          '''CREATE TABLE consultas(
          id INTEGER PRIMARY KEY AUTOINCREMENT, 
          petId INTEGER, 
          tipoServico TEXT, 
          dataHora TEXT, 
          observacoes TEXT, 
          FOREIGN KEY(petId) REFERENCES pets(id) ON DELETE CASCADE)''');
      },
      onConfigure: (db) async => await db.execute("PRAGMA foreign_key = ON"), // delete on CASCADE
    );
  }

  // Métodos CRUD Simplicados
  // Inserir pet no DB
  Future<int> insertPet(Pet pet) async => (await database).insert("pets", pet.toMap());

  // Listar Pets
  Future<List<Pet>> getPets() async{
    final List<Map<String,dynamic>> maps = await (await database).query("pets", orderBy: "nome ASC");
    return List.generate(maps.length, (e) => Pet.fromMap(maps[e]));
  }

  // InsertConsulta
  Future<int> insertConsulta(Consulta c) async => (await database).insert("consultas", c.toMap());

  // Get Consultas por Pet
  Future<List<Consulta>> getConsultasPorPet(int petId) async {
    final List<Map<String,dynamic>> maps = await (await database).query("consultas", where: "petId = ?", whereArgs: [petId], orderBy: "dataHora DESC");
    return List.generate(maps.length, (e) => Consulta.fromMap(maps[e]));
  }
  
}