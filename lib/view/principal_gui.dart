import 'package:flutter/material.dart';
import 'package:trabalho_1/components/search_box.dart';
import 'package:trabalho_1/components/todo_item.dart';
import 'package:trabalho_1/model/tarefa.dart';
import 'package:trabalho_1/model/usuario.dart';

class PrincipalPage extends StatefulWidget {
  PrincipalPage({super.key, required this.usuario});

  final Usuario? usuario;

  @override
  State<PrincipalPage> createState() => _PrincipalPageState();
}
class _PrincipalPageState extends State<PrincipalPage> {
  
  final todosList = Tarefa.todoList();
  final tarefaController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        scrolledUnderElevation: 0,
        elevation: 0,
        backgroundColor: Colors.grey[200],
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(Icons.menu), 
              color: Colors.black,
              onPressed: () {},
            ),
            Text(
              "Olá ${widget.usuario?.nome ?? ''}!",
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 18,
                  fontWeight: FontWeight.w500
                ),
            ),
            IconButton(
              icon: const Icon(Icons.add), 
              color: Colors.black,
              onPressed: () {},
            ),
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
                      for (Tarefa tarefa in todosList.reversed)
                        ToDoItem(
                          todo: tarefa,
                          mudarEstado: mudarEstado,
                          deletarTarefa: deletarTarefa,
                      ),
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
                    child: TextField(
                      controller: tarefaController,
                      decoration: const InputDecoration(
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
                    onPressed: (){
                      adicionarTarefa(tarefaController.text);
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.blueAccent), 
                      overlayColor: MaterialStateProperty.all<Color>(Colors.blueAccent), 
                      elevation: MaterialStateProperty.all<double>(10),
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

  // Altera o estado da tarefa entre feita e não feita
  void mudarEstado(Tarefa todo){
    setState(() {
      todo.estado = !todo.estado;
    });
  }

  void deletarTarefa(int id){
    setState(() {
      todosList.removeWhere((item) => item.id == id);
    });
  }

  void adicionarTarefa(String descricao){
    if(tarefaController.text.isNotEmpty){
      setState(() {
        todosList.add(Tarefa(id: DateTime.now().millisecondsSinceEpoch, descricao: descricao));
      });
      tarefaController.clear();
    }
  }

}