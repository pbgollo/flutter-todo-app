import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class BancoHelper {
  static const arquivoDoBancoDeDados = 'nossoBD.db';
  static const arquivoDoBancoDeDadosVersao = 1;

  static const tabelaUsuario = 'usuario';
  static const colunaIdUsuario = 'id';
  static const colunaNomeUsuario = 'nome';
  static const colunaUsuarioUsuario = 'usuario';
  static const colunaSenhaUsuario = 'senha';

  static late Database _bancoDeDados;

  iniciarBD() async {
    String caminhoBD = await getDatabasesPath();
    String path = join(caminhoBD, arquivoDoBancoDeDados);

    _bancoDeDados = await openDatabase(path,
        version: arquivoDoBancoDeDadosVersao, 
        onCreate: funcaoCriacaoBD, 
        onUpgrade: atualizarDB, 
        onDowngrade: downgradeDB);
  }

  Future funcaoCriacaoBD(Database db, int version) async {
    await db.execute('''
        CREATE TABLE $tabelaUsuario (
          $colunaIdUsuario INTEGER PRIMARY KEY,
          $colunaNomeUsuario TEXT NOT NULL,
          $colunaUsuarioUsuario TEXT NOT NULL,
          $colunaSenhaUsuario INTEGER NOT NULL
        )
      ''');
  }

  Future atualizarDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      //Executa comandos  
    }
  }

  Future downgradeDB(Database db, int oldVersion, int newVersion) async {

  }
}
