import 'package:flutter/material.dart';
import 'package:trabalho_1/model/tarefa.dart';

class ToDoItem extends StatelessWidget {
  final Tarefa todo;

  const ToDoItem({super.key, required this.todo});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: ListTile(
        onTap: (){

        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20)
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20, 
          vertical: 5
        ),
        tileColor: Colors.white,
        leading: Icon(
          todo.estado ? Icons.check_box: Icons.check_box_outline_blank,
          color: Colors.blueAccent,
        ),
        title: Text(
          todo.descricao!,
          style: TextStyle(
            fontSize: 16,
            color: Colors.black,
            decoration: todo.estado ? TextDecoration.lineThrough : null,
          ),
        ),
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

            }
          ),
        ),
      )
    );
  }
}