class Usuario {
  int? id;
  String? nome;
  String? usuario;
  String? senha;
  
  Usuario({
     this.id,
     this.nome,
     this.usuario,
     this.senha,
  });
  
  Map<String, Object?> toMap() {
    return {
      'id': id,
      'nome': nome,
      'usuario': usuario,
      'senha': senha,
    };
  }
}