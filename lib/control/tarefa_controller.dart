// ignore_for_file: avoid_print

import 'package:sqflite/sqflite.dart';
import 'package:trabalho_1/database/banco_helper.dart';
import 'package:trabalho_1/model/grupo.dart';
import 'package:trabalho_1/model/tarefa.dart';
import 'package:trabalho_1/model/usuario.dart';

class TarefaController {
  final BancoHelper _bancoHelper = BancoHelper.instance; // Instância do BancoHelper

  // Altera o estado da tarefa entre feita e não feita
  Future<bool> mudarEstado(Tarefa tarefa) async{
    final Database db = await _bancoHelper.database;
    await db.update(
      'tarefa',
      {'estado':tarefa.estado==1?0:1},
      where: 'id =?',
      whereArgs: [tarefa.id],
    );
    return true;
  }

  // Método para deletar uma tarefa
  Future<bool> deletarTarefa(int id) async{
    final Database db = await _bancoHelper.database;
    await db.delete(
      'tarefa',
      where: 'id =?',
      whereArgs: [id],
    );
    return true;
  }

  // Método para adicionar uma nova tarefa
  Future<Tarefa> adicionarTarefa(String descricao, Usuario usuario, Grupo grupo) async {
    final Database db = await _bancoHelper.database;
    Tarefa tarefa = Tarefa(descricao: descricao, usuario: usuario, grupo: grupo);
    int? id = await db.insert(
      'tarefa',
      tarefa.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    tarefa.id = id;
    return tarefa;
  }

  // Método que retorna as tarefas do usuário
  Future<List<Tarefa>> buscarTarefaPorUsuarioEGrupo(Usuario usuario, Grupo grupo) async {
    try {
      final Database db = await _bancoHelper.database;

      List<Map<String, dynamic>> result = await db.query(
        'tarefa',
        where: 'id_usuario = ? and id_grupo = ?',
        whereArgs: [usuario.id, grupo.id],
      );
      
      List<Tarefa> tarefas = [];
      for (var row in result) {
        Tarefa tarefa = Tarefa(
          id: row['id'] as int,
          descricao: row['descricao'] as String?,
          estado: row['estado'] as int,
          usuario: usuario,
          grupo: grupo
        );
        tarefas.add(tarefa);
      }       
      return tarefas;
    } catch (e) {
      return [];
    }
  }
}
