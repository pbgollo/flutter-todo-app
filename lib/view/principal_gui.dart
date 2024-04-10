import 'package:flutter/material.dart';
import 'package:trabalho_1/components/search_box.dart';
import 'package:trabalho_1/components/todo_item.dart';
import 'package:trabalho_1/model/usuario.dart';

class PrincipalPage extends StatelessWidget {
  final Usuario? usuario;

  const PrincipalPage({super.key, required this.usuario});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.grey[200],
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Icon(
              Icons.menu, 
              color: Colors.black,
              size:27,
            ),
            Text(
              "Olá ${usuario?.nome ?? ''}!",
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 18,
                ),
            ),
            const Icon(
              Icons.add_to_photos_outlined, 
              color: Colors.black,
              size:26,
            )
          ],
        ),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 15,
        ),
        child: Column(
          children: [
            const SearchBox(),
            Expanded(
              child: ListView(
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 50, bottom: 20),
                    child: const Text(
                      "Lista de Tarefas",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const ToDoItem(),
                ],
              ),
            ),
          ],
        )
      ),
    );
  }
}