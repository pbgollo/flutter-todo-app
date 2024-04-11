// ignore_for_file: avoid_print

import 'package:sqflite/sqflite.dart';
import 'package:trabalho_1/database/banco_helper.dart';
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
  Future<Tarefa> adicionarTarefa(Tarefa tarefa) async {
    final Database db = await _bancoHelper.database;
    int tarefaId = await db.insert(
      'tarefa',
      tarefa.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return Tarefa(id: tarefaId,descricao: tarefa.descricao, usuario: tarefa.usuario);
  }

  // Método que retorna as tarefas do usuário
  Future<List<Tarefa>> buscarTarefaPorUsuario(Usuario usuario) async {
    try {
      final Database db = await _bancoHelper.database;

      List<Map<String, dynamic>> result = await db.query(
        'tarefa',
        where: 'id_usuario = ?',
        whereArgs: [usuario.id],
      );
      
      List<Tarefa> tarefas = [];
      for (var row in result) {
        Tarefa tarefa = Tarefa(
          id: row['id'] as int,
          descricao: row['descricao'] as String?,
          estado: row['estado'] as int,
          usuario: usuario
        );
        tarefas.add(tarefa);
      }        
      return tarefas;

    } catch (e) {
      print("Erro ao consultar tarefas: $e");
      return [];
    }
  }

  Future<List<Tarefa>> filtrarTarefas(Usuario usuario, String descricao) async {
  try {
    final Database db = await _bancoHelper.database;

    List<Map<String, dynamic>> result = await db.query(
      'tarefa',
      where: 'id_usuario = ? AND descricao LIKE ?',
      whereArgs: [usuario.id, '%$descricao%'], 
    );
    
    List<Tarefa> tarefas = [];
    for (var row in result) {
      Tarefa tarefa = Tarefa(
        id: row['id'] as int,
        descricao: row['descricao'] as String?,
        estado: row['estado'] as int,
        usuario: usuario
      );
      tarefas.add(tarefa);
    }        
    return tarefas;

  } catch (e) {
    print("Erro ao consultar tarefas: $e");
    return [];
  }
}

}
