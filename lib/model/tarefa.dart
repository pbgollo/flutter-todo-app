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

  static List<Tarefa> todoList() {
    // Usuario usr = Usuario(id: 1);
    return [
      // Tarefa(id: 1, descricao: 'Morning Exercise', estado: true ,usuario: usr),
      // Tarefa(id: 2, descricao: 'Buy Groceries', estado: true ,usuario: usr),
      // Tarefa(id: 3, descricao: 'Check Emails', usuario: usr),
      // Tarefa(id: 4, descricao: 'Team Meeting', usuario: usr),
      // Tarefa(id: 5, descricao: 'Work on mobile apps for 2 hours', usuario: usr),
      // Tarefa(id: 6, descricao: 'Dinner with Jenny', usuario: usr),
    ];
  }
}
