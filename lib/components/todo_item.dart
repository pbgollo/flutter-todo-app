import 'package:flutter/material.dart';
import 'package:trabalho_1/model/tarefa.dart';

class ToDoItem extends StatelessWidget {
  final Tarefa todo;
  final mudarEstado;
  final deletarTarefa;

  const ToDoItem({super.key, required this.todo, required this.mudarEstado, required this.deletarTarefa});

  @override
  Widget build(BuildContext context) {
    // Caixa da tarefa
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: ListTile( 
        onTap: (){
          mudarEstado(todo);
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20)
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20, 
          vertical: 5
        ),
        tileColor: todo.estado ? Colors.grey[300]: Colors.white,
        // CheckBox de feito/não feito
        leading: Icon(
          todo.estado ? Icons.check_box: Icons.check_box_outline_blank,
          color: Colors.blueAccent,
        ),
        // Descrição da tarefa
        title: Text(
          todo.descricao!,
          style: TextStyle(
            fontSize: 16,
            color: todo.estado? Colors.grey[700] : Colors.black,
            decoration: todo.estado ? TextDecoration.lineThrough : null,
            decorationThickness: 2,
            decorationColor: Colors.grey[700],
            fontStyle: todo.estado ? FontStyle.italic : FontStyle.normal,
          ),
        ),
        // Botão de deletar a tarefa
        trailing: Container(
          padding: const EdgeInsets.all(0),
          margin: const EdgeInsets.symmetric(vertical: 12),
          height: 35,
          width: 35,
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(5)
          ),
          child: IconButton(
            color: Colors.white,
            iconSize: 18,
            icon: const Icon(Icons.delete),
            onPressed: (){
              deletarTarefa(todo.id);
            }
          ),
        ),
      )
    );
  }
}