// ignore_for_file: non_constant_identifier_names

class Grupo {
  int? id;
  String? nome;
  int? id_usuario;

  Grupo({
    this.id,
    required this.nome,
    this.id_usuario
  });

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'nome': nome,
      'id_usuario': id_usuario,
    };
  }

  static Grupo fromMap(Map<String, dynamic> map) {
    return Grupo(
      id: map['id'] as int?,
      nome: map['nome'] as String?,
      id_usuario: map['id_usuario'] as int,
    );
  }
}
