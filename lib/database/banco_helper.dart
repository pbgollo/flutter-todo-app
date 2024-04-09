import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class BancoHelper {
  static const arquivoDoBancoDeDados = 'nossoBanco.db';
  static const arquivoDoBancoDeDadosVersao = 1;

  static const tabelaUsuario = 'usuario';
  static const colunaIdUsuario = 'id';
  static const colunaNomeUsuario = 'nome';
  static const colunaUsuarioUsuario = 'usuario';
  static const colunaSenhaUsuario = 'senha';

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
        onCreate: _criarBanco,
        onUpgrade: _atualizarBanco,
        onDowngrade: _downgradeBanco);
  }

  Future<void> _criarBanco(Database db, int version) async {
    await db.execute('''
        CREATE TABLE $tabelaUsuario (
          $colunaIdUsuario INTEGER PRIMARY KEY AUTOINCREMENT,
          $colunaNomeUsuario TEXT NOT NULL,
          $colunaUsuarioUsuario TEXT NOT NULL,
          $colunaSenhaUsuario TEXT NOT NULL
        )
      ''');
  }

  Future<void> _atualizarBanco(Database db, int oldVersion, int newVersion) async {
    // Lógica atualizar o banco de dados para versões mais recentes
    if (oldVersion < 2) {
      //Executa comandos  
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
