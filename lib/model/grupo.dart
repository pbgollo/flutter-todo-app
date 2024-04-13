import 'package:flutter/material.dart';
import 'package:trabalho_1/model/usuario.dart';


class Grupo {
  int? id;
  String nome;
  Usuario usuario;

  Grupo({
    this.id,
    required this.nome,
    required this.usuario
  });

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'nome': nome,
      'id_usuario': usuario.id
    };
  }

  static Grupo fromMap(Map<String, dynamic> map) {
    return Grupo(
      id: map['id'] as int?,
      nome: map['nome'] as String,
      usuario: map['usuario'] as Usuario,
    );
  }

  @override
  String toString() {
    return 'Grupo ${this.id}';
  }
}
