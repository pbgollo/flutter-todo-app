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

  Future<Database> iniciarBanco() async {
    String caminhoBD = await getDatabasesPath();
    String path = join(caminhoBD, arquivoDoBancoDeDados);

    return openDatabase(path,
        version: arquivoDoBancoDeDadosVersao, 
        onCreate: criarBanco, 
        onUpgrade: atualizarBanco, 
        onDowngrade: downgradeBanco);
  }

  Future<void> criarBanco(Database db, int version) async {
    await db.execute('''
        CREATE TABLE $tabelaUsuario (
          $colunaIdUsuario INTEGER PRIMARY KEY AUTOINCREMENT,
          $colunaNomeUsuario TEXT NOT NULL,
          $colunaUsuarioUsuario TEXT NOT NULL,
          $colunaSenhaUsuario INTEGER NOT NULL
        )
      ''');
  }

  Future<void> atualizarBanco(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      //Executa comandos  
    }
  }

  Future<void> downgradeBanco(Database db, int oldVersion, int newVersion) async {
    // Lógica para reverter o banco de dados para versões anteriores
  }
}
