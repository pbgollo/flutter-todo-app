// ignore_for_file: avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:sqflite/sqflite.dart';
import 'package:trabalho_1/database/banco_helper.dart';
import 'package:trabalho_1/model/usuario.dart';
import 'package:trabalho_1/services/auth_service.dart';

class UsuarioController {
  final BancoHelper _bancoHelper = BancoHelper.instance; 
  final AuthService _authService = AuthService();

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

  // Método para adicionar um novo usuário
  Future<bool> adicionarUsuario(Usuario usuario) async {
    try {
      final Database db = await _bancoHelper.database;

      final Usuario? usuarioExistente = await consultarUsuarioPorNome(usuario.usuario!);
      
      if (usuarioExistente == null) {
        await db.insert(
          'usuario',
          usuario.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
        return true;
      } else {
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
      final Database db = await _bancoHelper.database;

      List<Map<String, dynamic>> result = await db.query(
        'usuario',
        where: 'usuario = ?',
        whereArgs: [nomeUsuario],
        limit: 1,
      );

      if (result.isNotEmpty) {
        return Usuario.fromMap(result.first);
      } else {
        return null; 
      }
    } catch (e) {
      print("Erro ao consultar usuário: $e");
      return null;
    }
  }

  Future<Usuario?> signInWithGoogle() async {
    try {
      UserCredential? userCredential = await _authService.signInWithGoogle();

      if (userCredential != null) {
        User? user = userCredential.user;
        print('Usuário logado: ${user?.displayName} (${user?.email})');

        // Testar se o usuário já existe no banco de dados local
        Usuario? usuarioExistente = await consultarUsuarioPorNome(user!.email ?? '');
        
        if (usuarioExistente != null) {
          return usuarioExistente;
        } else {
          print('Usuário não existe, cadastrando...');
          Usuario novoUsuario = Usuario(
            nome: user.displayName ?? '',
            usuario: user.email ?? '',
            senha: 'master',
          );
          await adicionarUsuario(novoUsuario);
          print('Usuário cadastrado, realizando login...');
          return novoUsuario;
        }
      } else {
        print('Login com o Google cancelado ou falhou');
      }
    } catch (error) {
      print('Erro ao fazer login com o Google: $error');
    }
    return null;
  }

  void logout() {
    _authService.logOut();
  }

}
