// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
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
  bool primeira = true;
  int? _selectedIndex;
  final tarefaPesquisaController = TextEditingController();
  final tarefaTextController = TextEditingController();
  final TarefaController tarefaController = TarefaController();
  List<Tarefa> todoList = [];
  List<Tarefa> todoListFiltrada = [];

  List<String> itensMenu = ['Lista 1', 'Lista 2', 'Lista 3'];

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
            Builder(
              builder: (context) => IconButton(
                icon: const Icon(Icons.menu),
                color: Colors.black,
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              ),
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
      // Menu bar
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          // Alinhamento do ListView
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blueAccent,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.list_alt_rounded,
                    color: Colors.white,
                    size: 60,
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Minhas Listas',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                ],
              ),
            ),
            // Adicionando os itens do menu
            for (var i = 0; i < itensMenu.length; i++)
              GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedIndex = i;
                  });
                  // Lista selecionada
                  print('Item clicado: ${itensMenu[i]}');
                },
                child: Container(
                  color: _selectedIndex == i ? Colors.grey[200] : null,
                  child: ListTile(
                    title: Text(itensMenu[i]),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          color: Colors.grey[600],
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            editarItemMenu(i);
                          },
                        ),
                        IconButton(
                          color: Colors.red,
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            deletarItemMenu(i);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            // Botão de adicionar lista
            Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 25, bottom: 8, top: 5), // Reduzindo o espaçamento
              child: SizedBox(
                width: 46,
                height: 46,
                child: FloatingActionButton(
                  onPressed: () {
                    adicionarNovaLista();
                  },
                  backgroundColor: const Color.fromARGB(255, 147, 212, 74),
                  child: const Icon(
                    Icons.add,
                    size: 24,
                  ),
                ),
              ),
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
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20)
                  ),
                  child: TextField(
                    controller: tarefaPesquisaController,
                    onChanged: (value) => filtrarTarefas(value),
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(0),
                      prefixIcon: const Icon(
                        Icons.search,
                        color: Colors.black,
                        size: 20,
                      ),
                      prefixIconConstraints: const BoxConstraints(
                        maxHeight: 20,
                        minWidth: 25,
                      ),
                      border: InputBorder.none,
                      hintText: "Pesquisar",
                      hintStyle: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 15
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: montarLista(todoListFiltrada),
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
        if(primeira){
          todoListFiltrada = value;
        }
        primeira = false;
      });
    }).catchError((error) {
      print("Erro ao buscar tarefas: $error");
    });
  }

  // Altera o estado da tarefa entre feita e não feita
  void mudarEstado(Tarefa todo) {
    tarefaController.mudarEstado(todo).then((success) {
      setState(() {
        todo.estado = todo.estado==1?0:1;
      });
    }).catchError((error) {
      print("Erro ao mudar estado da tarefa: $error");
    });
  }

  // Deleta uma tarefa
  void deletarTarefa(int id){
    setState(() {
      tarefaController.deletarTarefa(id).then((success) {
        todoList.removeWhere((item) => item.id == id);
        
      if (tarefaPesquisaController.text.isEmpty){
        todoListFiltrada = todoList;
      } else {
        todoListFiltrada = todoList.where((element) => element.descricao!.toLowerCase().contains(tarefaPesquisaController.text.toLowerCase())).toList();
      }
      });
    });
  }

  // Adiciona uma tarefa
  void adicionarTarefa(String descricao) {
    if (tarefaTextController.text.isNotEmpty) {
      Tarefa tarefa = Tarefa(descricao: descricao, usuario: widget.usuario);
      tarefaController.adicionarTarefa(tarefa).then((novaTarefa) {
        setState(() {
          todoList.add(novaTarefa);
          tarefaTextController.clear();
          todoListFiltrada = todoList;
        });
      }).catchError((error) {
        print("Erro ao adicionar tarefa: $error");
      });
    }
  }

  // Filtra as tarefas de acordo com a pesquisa
  void filtrarTarefas(String pesquisa){
    List<Tarefa> resultados = [];
    if (pesquisa.isEmpty){
      resultados = todoList;
    } else {
      resultados = todoList.where((element) => element.descricao!.toLowerCase().contains(pesquisa.toLowerCase())).toList();
    }
    setState(() {
      todoListFiltrada = resultados;
    });
  }

  // Monta a lista de tarefas
  Widget montarLista(List<Tarefa> lista) {
    return ListView(
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
        for (Tarefa tarefa in lista.reversed)
          ToDoItem(
            todo: tarefa,
            mudarEstado: mudarEstado,
            deletarTarefa: deletarTarefa,
          ),
      ],
    );
  }

  // Função para deletar um item do menu
  void deletarItemMenu(int index) {
    setState(() {
      itensMenu.removeAt(index);
    });
  }

  // Função para editar um item do menu
  void editarItemMenu(int index) {
    TextEditingController controller = TextEditingController(text: itensMenu[index]);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey[100],
          title: const Text(
            'Editar nome da lista',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w500
            ),
          ),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              labelText: 'Nome',
              labelStyle: TextStyle(
                fontSize: 19,
              ),
            ),
          ),
          actions: <Widget>[
            ButtonBar(
              alignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  color: Colors.red, 
                  iconSize: 36, 
                  icon: const Icon(Icons.close_rounded), 
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                IconButton(
                  color: Colors.green, 
                  iconSize: 36, 
                  icon: const Icon(Icons.check_rounded), 
                  onPressed: () {
                    setState(() {
                      itensMenu[index] = controller.text;
                    });
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  void adicionarNovaLista() {
    TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey[100],
          title: const Text(
            'Criar nova lista',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w500
            ),
          ),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              labelText: 'Nome',
              labelStyle: TextStyle(
                fontSize: 19,
              ),
            ),
          ),
          actions: <Widget>[
            ButtonBar(
              alignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  color: Colors.red, 
                  iconSize: 36, 
                  icon: const Icon(Icons.close_rounded), 
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                IconButton(
                  color: Colors.green, 
                  iconSize: 36, 
                  icon: const Icon(Icons.check_rounded), 
                  onPressed: () {
                    if (controller.text.isNotEmpty) {
                      setState(() {
                        itensMenu.add(controller.text);
                      });
                    }
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  } 
}