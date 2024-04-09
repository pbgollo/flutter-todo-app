// ignore_for_file: avoid_print

import 'package:sqflite/sqflite.dart';
import 'package:trabalho_1/database/banco_helper.dart';
import 'package:trabalho_1/model/usuario.dart';

class UsuarioController {
  final BancoHelper _bancoHelper = BancoHelper(); // Instância do BancoHelper

  // Método para validar o usuário
  Future<bool> validarUsuario(String nomeUsuario, String senha) async {
    try {
      final Usuario? usuario = await consultarUsuarioPorNome(nomeUsuario);
      
      if (usuario != null && usuario.senha == senha) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print("Erro ao validar usuário: $e");
      return false;
    }
  }

  // Método para adicionar um novo usuário ao banco de dados
  Future<bool> adicionarUsuario(Usuario usuario) async {
    try {
      final Database db = await _bancoHelper.iniciarBanco();

      final Usuario? usuarioExistente = await consultarUsuarioPorNome(usuario.usuario!);
      
      if (usuarioExistente == null) {
        await db.insert(
          BancoHelper.tabelaUsuario,
          usuario.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      return true;
      } else {
        print('Já existe um usuário com esse nome de usuário!');
        return false;
      }
    } catch (e) {
      print("Erro ao adicionar usuário: $e");
      return false;
    }
  }

  // Método para consultar um usuário pelo campo "usuario"
  Future<Usuario?> consultarUsuarioPorNome(String nomeUsuario) async {
    try {
      final Database db = await _bancoHelper.iniciarBanco();

      List<Map<String, dynamic>> result = await db.query(
        BancoHelper.tabelaUsuario,
        where: '${BancoHelper.colunaUsuarioUsuario} = ?',
        whereArgs: [nomeUsuario],
        limit: 1,
      );

      if (result.isNotEmpty) {
        return Usuario.fromMap(result.first);
      } else {
        return null; 
      }
    } catch (e) {
      print("Erro ao consultar usuário por nome: $e");
      return null;
    }
  }
}

