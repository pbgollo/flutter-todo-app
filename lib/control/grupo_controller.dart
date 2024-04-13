// ignore_for_file: avoid_print

import 'package:sqflite/sqflite.dart';
import 'package:trabalho_1/database/banco_helper.dart';
import 'package:trabalho_1/model/grupo.dart';
import 'package:trabalho_1/model/usuario.dart';

class GrupoController {
  final BancoHelper _bancoHelper = BancoHelper.instance; // Instância do BancoHelper

  // Altera o estado da tarefa entre feita e não feita
  Future<bool> editarGrupo(Grupo grupo) async{
    final Database db = await _bancoHelper.database;
    await db.update(
      'grupo',
      {'nome': grupo.nome},
      where: 'id =?',
      whereArgs: [grupo.id],
    );
    return true;
  }

  // Método para deletar uma tarefa
  Future<bool> deletarGrupo(Grupo grupo) async{
    final Database db = await _bancoHelper.database;
    await db.delete(
      'grupo',
      where: 'id =?',
      whereArgs: [grupo.id],
    );

    // await buscarGrupoPorUsuario(grupo.usuario);

    return true;
  }

  // Método para adicionar uma nova tarefa
  Future<Grupo> adicionarGrupo(String nome, Usuario usuario) async {
    final Database db = await _bancoHelper.database;
    Grupo grupo = Grupo(nome: nome, usuario: usuario);
    int tarefaId = await db.insert(
      'grupo',
      grupo.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return Grupo(id: tarefaId,nome: grupo.nome, usuario: grupo.usuario);
  }

  // Método que retorna as tarefas do usuário
  Future<List<Grupo>> buscarGrupoPorUsuario(Usuario usuario) async {
    try {
      final Database db = await _bancoHelper.database;
      
      List<Map<String, dynamic>> result = await db.query(
        'grupo',
        where: 'id_usuario = ?',
        whereArgs: [usuario.id],
      );
      
      List<Grupo> grupos = [];
      for (var row in result) {
        Grupo grupo = Grupo(
          id: row['id'] as int,
          nome: row['nome'] as String,
          usuario: usuario
        );
        grupos.add(grupo);
      }
      if (grupos.isEmpty) {
        Grupo grupo = await adicionarGrupo("Lista padrão", usuario);
        grupos.add(grupo);
      }

      return grupos;

    } catch (e) {
      print("Erro ao consultar grupos: $e");
      return [];
    }
  }
}
