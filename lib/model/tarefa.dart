class Tarefa {
  int? id;
  String? descricao;
  bool estado;

  Tarefa({
    required this.id,
    required this.descricao,
    this.estado = false,
  });

  static List<Tarefa> todoList() {
    return [
      Tarefa(id: 1, descricao: 'Morning Exercise', estado: true ),
      Tarefa(id: 2, descricao: 'Buy Groceries', estado: true ),
      Tarefa(id: 3, descricao: 'Check Emails', ),
      Tarefa(id: 4, descricao: 'Team Meeting', ),
      Tarefa(id: 5, descricao: 'Work on mobile apps for 2 hours', ),
      Tarefa(id: 6, descricao: 'Dinner with Jenny', ),
    ];
  }
}
