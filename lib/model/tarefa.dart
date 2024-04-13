import 'package:trabalho_1/model/usuario.dart';
import 'package:trabalho_1/model/grupo.dart';

class Tarefa {
  int? id;
  String? descricao;
  int estado;
  Grupo grupo;
  Usuario usuario;

  Tarefa({
    this.id,
    required this.descricao,
    this.estado = 0,
    required this.usuario,
    required this.grupo
  });

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'descricao': descricao,
      'estado': estado,
      'id_usuario': usuario.id,
      'id_grupo': grupo.id
    };
  }

  static Tarefa fromMap(Map<String, dynamic> map) {
    return Tarefa(
      id: map['id'] as int?,
      descricao: map['descricao'] as String?,
      estado: map['estado'] as int,
      usuario: map['usuario'] as Usuario,
      grupo: map['grupo'] as Grupo,
    );
  }

  @override
  String toString() {
    return 'Tarefa $id';
  }
}
