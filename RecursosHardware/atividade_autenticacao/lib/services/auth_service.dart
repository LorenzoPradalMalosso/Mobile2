import '../database/database_helper.dart';

class AuthService {
  AuthService({DatabaseHelper? database})
    : _database = database ?? DatabaseHelper.instance;
  final DatabaseHelper _database;

  Future<void> createAccount(String email, String password) async {
    if (!_validEmail(email)) {
      throw const AuthException('Informe um e-mail válido.');
    }
    if (password.length < 6) {
      throw const AuthException('A senha deve ter pelo menos 6 caracteres.');
    }
    try {
      await _database.createAccount(email, password);
      await _database.rememberBiometricAccount(email);
    } catch (_) {
      throw const AuthException('Já existe uma conta com este e-mail.');
    }
  }

  Future<void> signIn(String email, String password) async {
    if (!_validEmail(email) || password.isEmpty) {
      throw const AuthException('Informe um e-mail e uma senha válidos.');
    }
    if (!await _database.authenticate(email, password)) {
      throw const AuthException('E-mail ou senha incorretos.');
    }
    await _database.rememberBiometricAccount(email);
  }

  Future<String?> biometricAccount() async {
    final email = await _database.rememberedBiometricAccount();
    if (email == null || !await _database.accountExists(email)) return null;
    return email;
  }

  bool _validEmail(String email) =>
      RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(email.trim());
}

class AuthException implements Exception {
  const AuthException(this.message);
  final String message;
  @override
  String toString() => message;
}
