import 'package:flutter/material.dart';
import 'package:trabalho_1/components/search_box.dart';
import 'package:trabalho_1/components/todo_item.dart';
import 'package:trabalho_1/model/tarefa.dart';
import 'package:trabalho_1/model/usuario.dart';

class PrincipalPage extends StatelessWidget {
  final Usuario? usuario;
  final todosList = Tarefa.todoList();

  PrincipalPage({super.key, required this.usuario});

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
      body: Stack(
        children: [
          Container(
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
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      for (Tarefa tarefa in todosList)
                        ToDoItem(todo: tarefa),
                    ],
                  ),
                ),
              ],
            )
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 50,
                    margin: const EdgeInsets.only(
                      bottom: 20, 
                      right: 10, 
                      left: 20
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 3
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: const [BoxShadow(
                        color: Colors.grey,
                        offset: Offset(0.0, 0.0),
                        blurRadius: 10.0,
                        spreadRadius: 0.0,
                      ),],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const TextField(
                      decoration: InputDecoration(
                        hintText: "Adicionar nova tarefa",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(
                    bottom: 20,
                    right: 20
                  ),
                  child: ElevatedButton(
                    onPressed: (){},
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.blueAccent), // Cor do botão quando não pressionado
                      overlayColor: MaterialStateProperty.all<Color>(Colors.blueAccent), // Cor do botão quando pressionado
                    ),
                    child: const Icon(
                      Icons.add_task, 
                      size: 25, 
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}