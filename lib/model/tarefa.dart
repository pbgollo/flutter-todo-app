import 'package:trabalho_1/model/usuario.dart';

class Tarefa {
  int? id;
  String? descricao;
  bool estado;
  Usuario usuario;

  Tarefa({
    this.id,
    required this.descricao,
    this.estado = false,
    required this.usuario
  });

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'descricao': descricao,
      'estado': estado? 1 : 0,
      'id_usuario': usuario.id
    };
  }

  static Tarefa fromMap(Map<String, dynamic> map) {
    return Tarefa(
      id: map['id'] as int?,
      descricao: map['descricao'] as String?,
      estado: map['estado']==1,
      usuario: map['usuario'] as Usuario,
    );
  }
}
