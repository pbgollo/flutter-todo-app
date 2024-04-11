import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class BancoHelper {
  static const arquivoDoBancoDeDados = 'nossoBanco.db';
  static const arquivoDoBancoDeDadosVersao = 3;

  BancoHelper._privateConstructor();
  static final BancoHelper instance = BancoHelper._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String caminhoBD = await getDatabasesPath();
    String path = join(caminhoBD, arquivoDoBancoDeDados);

    return openDatabase(path,
        version: arquivoDoBancoDeDadosVersao,
        // onOpen: _iniciarDatabase,
        // onConfigure: _iniciarDatabase,
        onCreate: _criarBanco,
        onUpgrade: _atualizarBanco,
        onDowngrade: _downgradeBanco);
  }

  FutureOr<void> _iniciarDatabase(Database db) async {

    await db.execute('drop table tarefa');
    await db.execute('drop table grupo_tarefa');

    await db.execute('''
      CREATE TABLE grupo_tarefa (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT NOT NULL,
        id_usuario INT NOT NULL,
        FOREIGN KEY (id_usuario) REFERENCES usuario(id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE tarefa (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        descricao TEXT NOT NULL,
        estado INT NOT NULL,
        id_grupo INT, --NOT NULL
        id_usuario INT NOT NULL,
        FOREIGN KEY (id_usuario) REFERENCES usuario(id) ON DELETE CASCADE
      )
    ''');
    // FOREIGN KEY (id_grupo) REFERENCES grupo(id) ON DELETE CASCADE

  }

  Future<void> _criarBanco(Database db, int version) async {
    await db.execute('''
      CREATE TABLE usuario (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT NOT NULL,
        usuario TEXT NOT NULL,
        senha TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE grupo_tarefa (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT NOT NULL,
        id_usuario INT NOT NULL,
        FOREIGN KEY (id_usuario) REFERENCES usuario(id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE tarefa (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        descricao TEXT NOT NULL,
        estado INT NOT NULL,
        id_grupo INT, --NOT NULL
        id_usuario INT NOT NULL,
        FOREIGN KEY (id_usuario) REFERENCES usuario(id) ON DELETE CASCADE
      )
    ''');
    // FOREIGN KEY (id_grupo) REFERENCES grupo(id) ON DELETE CASCADE

  }

  Future<void> _atualizarBanco(Database db, int oldVersion, int newVersion) async {
    // Lógica atualizar o banco de dados para versões mais recentes
    if (oldVersion < 2) {

    }
  }

  Future<void> _downgradeBanco(Database db, int oldVersion, int newVersion) async {
    // Lógica para reverter o banco de dados para versões anteriores
  }

  Future<void> close() async {
    _database?.close();
    _database = null;
  }

}
