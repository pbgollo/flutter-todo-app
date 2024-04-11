// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:trabalho_1/components/search_box.dart';
import 'package:trabalho_1/components/todo_item.dart';
import 'package:trabalho_1/model/tarefa.dart';
import 'package:trabalho_1/model/usuario.dart';
import 'package:trabalho_1/control/tarefa_controller.dart';
import 'package:trabalho_1/view/login_gui.dart';

class PrincipalPage extends StatefulWidget {
  final Usuario usuario;

  const PrincipalPage({super.key, required this.usuario});


  @override
  State<PrincipalPage> createState() => _PrincipalPageState();
}
class _PrincipalPageState extends State<PrincipalPage> {
  
  final tarefaTextController = TextEditingController();
  final TarefaController tarefaController = TarefaController();
  List<dynamic> todoList = [];

  @override
  Widget build(BuildContext context) {
    buscarTarefas();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey[200],
      // App bar
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
              "Olá ${widget.usuario.nome ?? ''}!",
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 18,
                  fontWeight: FontWeight.w500
                ),
            ),
            IconButton(
              icon: const Icon(Icons.logout), 
              color: Colors.black,
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                    MaterialPageRoute(
                    builder: (context) => LoginPage(),
                  ),
                );
              },
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
                // Barra de pesquisa
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
                      // Criação das tarefas
                      for (Tarefa tarefa in todoList.reversed)
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
                // Barra de adicionar nova tarefa
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
                      controller: tarefaTextController,
                      decoration: const InputDecoration(
                        hintText: "Adicionar nova tarefa",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                // Botão de adicionar nova tarefa
                Container(
                  margin: const EdgeInsets.only(
                    bottom: 20,
                    right: 20
                  ),
                  child: ElevatedButton(
                    onPressed: (){
                      adicionarTarefa(tarefaTextController.text);
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

  // Busca as tarefas do usuário
  void buscarTarefas() {
    tarefaController.buscarTarefaPorUsuario(widget.usuario).then((value) {
      setState(() {
        todoList = value;
      });
    }).catchError((error) {
      print("Erro ao buscar tarefas: $error");
    });
  }

  // Altera o estado da tarefa entre feita e não feita
  void mudarEstado(Tarefa todo){
    setState(() {
      tarefaController.mudarEstado(todo).then((success) {
        print('tarefa marcada/desmarcada');
        print(todo.id);
        todo.estado = !todo.estado;
      });
    });
  }

  // Deleta uma tarefa
  void deletarTarefa(int id){
    setState(() {
      tarefaController.deletarTarefa(id).then((success) {
        todoList.removeWhere((item) => item.id == id);
        print('tarefa removida');
        print(id);
      });
    });
  }

  // Adiciona uma tarefa
  void adicionarTarefa(String descricao) {
    if(tarefaTextController.text.isNotEmpty){
      setState(() {
        Tarefa tarefa = Tarefa(descricao: descricao, usuario: widget.usuario);
        tarefaController.adicionarTarefa(tarefa).then((tarefa) {
          todoList.add(tarefa);
          print("tarefa adicionada");
          print(tarefa.id);
        });
      });
      tarefaTextController.clear();
    }
  }

}