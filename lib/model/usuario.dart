class Usuario {
  int? id;
  String? nome;
  String? usuario;
  String? senha;
  String? imagem;
   int? seguranca;
  
  Usuario({
    this.id,
    this.nome,
    this.usuario,
    this.senha,
    this.imagem,
    this.seguranca,
  });
  
  Map<String, Object?> toMap() {
    return {
      'id': id,
      'nome': nome,
      'usuario': usuario,
      'senha': senha,
      'imagem': imagem,
      'seguranca': seguranca,
    };
  }

  static Usuario fromMap(Map<String, dynamic> map) {
    return Usuario(
      id: map['id'] as int?,
      nome: map['nome'] as String?,
      usuario: map['usuario'] as String?,
      senha: map['senha'] as String?,
      imagem: map['imagem'] as String?,
      seguranca: map['seguranca'] as int?,
    );
  }

  @override
  String toString() {
    return 'Usuario $id';
  }
  
}