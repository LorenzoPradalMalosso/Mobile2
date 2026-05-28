import 'package:sa_petshop_sqlite/database/database_helper.dart';
import 'package:sa_petshop_sqlite/models/pet_model.dart';

class PetController {
  // Estabelecer as conexões com o DB
  final _dbHelper = DatabaseHelper();

  // Métodos do controller
  Future<int> salvarPet( Pet pet) async{
    return _dbHelper.insertPet(pet);
  }

  Future<List<Pet>> listarTodos() async => _dbHelper.getPets();
}