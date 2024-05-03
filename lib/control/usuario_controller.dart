// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:local_auth/local_auth.dart';
import 'package:sqflite/sqflite.dart';
import 'package:trabalho_1/database/banco_helper.dart';
import 'package:trabalho_1/model/usuario.dart';
import 'package:trabalho_1/services/auth_service.dart';

class UsuarioController {
  final BancoHelper _bancoHelper = BancoHelper.instance; 
  final AuthService _authService = AuthService();
  late final LocalAuthentication biometria;
  bool suportaBiometria = false;

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

  // Método para entrar com a conta do Google
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
          // Se o usuário não existir, deve ser cadastrado
          Usuario novoUsuario = Usuario(
            nome: user.displayName ?? '',
            usuario: user.email ?? '',
            senha: 'master',
            imagem: user.photoURL ?? '',
            seguranca: 0,
          );
          await adicionarUsuario(novoUsuario);
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

  // Método para deslogar da conta do Google
  void logout() {
    _authService.logOut();
  }

  // Atualiza a imagem do usuário
  Future<void> atualizarImagemUsuario(String usuario, String novaImagem) async {
    try {
      final Database db = await _bancoHelper.database;

      Map<String, dynamic> updates = {
        'imagem': novaImagem,
      };

      await db.update(
        'usuario',
        updates,
        where: 'usuario = ?',
        whereArgs: [usuario],
      );    

    } catch (e) {
      print("Erro ao atualizar a imagem!");
    }
  }

  // Atualiza a propriedade segurança
  Future<void> atualizarSeguranca(String usuario, int seguranca) async {
    try {
      final Database db = await _bancoHelper.database;

      Map<String, dynamic> updates = {
        'seguranca': seguranca,
      };

      await db.update(
        'usuario',
        updates,
        where: 'usuario = ?',
        whereArgs: [usuario],
      );    
      
    } catch (e) {
      print("Erro ao atualizar a segurança!");
    }
  }

  // Verifica se o usuário está com a biometria ativa e solicita-a
  void verificaSeguranca(Usuario usuario) async {
    if (usuario.seguranca != null && usuario.seguranca == 1) {
      try {
        biometria = LocalAuthentication();
        biometria.getAvailableBiometrics();
        bool autenticado = await biometria.authenticate(
          localizedReason: "Teste",
          options: const AuthenticationOptions(
            stickyAuth: true,
            biometricOnly: true,
          ),
        );
        
        if (autenticado) {
          print("Usuário autenticado com sucesso!");
        } else {
          print("Autenticação biométrica falhou.");
        }
      } catch (e) {
        print("Erro durante a autenticação biométrica: $e");
      }
    }
  }

  Future<bool> verificaSuporteBiometria() async {
    biometria = LocalAuthentication();
    bool suportaBiometria = await biometria.isDeviceSupported();
    if (suportaBiometria) {
      print("Dispositivo suporta biometria");
      return true;
    } else {
      print("Dispositivo não suporta biometria");
      return false;
    }
  }

}
