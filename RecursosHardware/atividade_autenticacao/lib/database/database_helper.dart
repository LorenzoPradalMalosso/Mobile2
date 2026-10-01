import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:path/path.dart' as p;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

import '../models/punch_record.dart';

class DatabaseHelper {
  DatabaseHelper._();
  static final DatabaseHelper instance = DatabaseHelper._();
  static const _name = 'ponto_seguro.db';
  Database? _database;

  Future<Database> get database async => _database ??= await _open();
  Future<Database> _open() async => openDatabase(
    p.join(await getDatabasesPath(), _name),
    version: 2,
    onCreate: (db, version) async {
      await db.execute(
        '''CREATE TABLE punches (
          id INTEGER PRIMARY KEY AUTOINCREMENT, account_id TEXT NOT NULL, type TEXT NOT NULL,
          at TEXT NOT NULL, latitude REAL NOT NULL, longitude REAL NOT NULL,
          distance_meters REAL NOT NULL, note TEXT NOT NULL DEFAULT '', photo_path TEXT NOT NULL DEFAULT '')''',
      );
      await _createAccounts(db);
    },
    onUpgrade: (db, oldVersion, newVersion) async {
      if (oldVersion < 2) await _createAccounts(db);
    },
  );

  static Future<void> _createAccounts(Database db) =>
      db.execute('''CREATE TABLE IF NOT EXISTS accounts (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    email TEXT NOT NULL UNIQUE COLLATE NOCASE,
    password_salt TEXT NOT NULL,
    password_hash TEXT NOT NULL,
    created_at TEXT NOT NULL)''');

  String _hashPassword(String salt, String password) =>
      sha256.convert(utf8.encode('$salt:$password')).toString();

  Future<void> createAccount(String email, String password) async {
    final normalized = email.trim().toLowerCase();
    final random = Random.secure();
    final salt = base64UrlEncode(
      List<int>.generate(24, (_) => random.nextInt(256)),
    );
    await (await database).insert('accounts', {
      'email': normalized,
      'password_salt': salt,
      'password_hash': _hashPassword(salt, password),
      'created_at': DateTime.now().toIso8601String(),
    });
  }

  Future<bool> authenticate(String email, String password) async {
    final rows = await (await database).query(
      'accounts',
      where: 'email = ?',
      whereArgs: [email.trim().toLowerCase()],
      limit: 1,
    );
    if (rows.isEmpty) return false;
    final row = rows.first;
    return row['password_hash'] ==
        _hashPassword(row['password_salt'] as String, password);
  }

  Future<bool> accountExists(String email) async =>
      (await (await database).query(
        'accounts',
        where: 'email = ?',
        whereArgs: [email.trim().toLowerCase()],
        limit: 1,
      )).isNotEmpty;

  Future<void> rememberBiometricAccount(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('employee_email', email.trim().toLowerCase());
  }

  Future<String?> rememberedBiometricAccount() async =>
      (await SharedPreferences.getInstance()).getString('employee_email');

  Future<int> insert(PunchRecord record) async =>
      (await database).insert('punches', record.toMap());
  Future<List<PunchRecord>> list(String accountId) async {
    final rows = await (await database).query(
      'punches',
      where: 'account_id = ?',
      whereArgs: [accountId],
      orderBy: 'at DESC',
      limit: 100,
    );
    return rows.map((row) => PunchRecord.fromMap(row)).toList();
  }

  Future<void> delete(int id, String accountId) async =>
      (await database).delete(
        'punches',
        where: 'id = ? AND account_id = ?',
        whereArgs: [id, accountId],
      );
}
