class Usuario {
  int? id;
  String? nome;
  String? usuario;
  String? senha;
  String? imagem;
  
  Usuario({
    this.id,
    this.nome,
    this.usuario,
    this.senha,
    this.imagem,
  });
  
  Map<String, Object?> toMap() {
    return {
      'id': id,
      'nome': nome,
      'usuario': usuario,
      'senha': senha,
      'imagem': imagem,
    };
  }

  static Usuario fromMap(Map<String, dynamic> map) {
    return Usuario(
      id: map['id'] as int?,
      nome: map['nome'] as String?,
      usuario: map['usuario'] as String?,
      senha: map['senha'] as String?,
      imagem: map['imagem'] as String?,
    );
  }

  @override
  String toString() {
    return 'Usuario $id';
  }
  
}
