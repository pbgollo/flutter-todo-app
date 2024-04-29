// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:trabalho_1/components/todo_item.dart';
import 'package:trabalho_1/control/usuario_controller.dart';
import 'package:trabalho_1/model/tarefa.dart';
import 'package:trabalho_1/model/grupo.dart';
import 'package:trabalho_1/model/usuario.dart';
import 'package:trabalho_1/control/tarefa_controller.dart';
import 'package:trabalho_1/control/grupo_controller.dart';
import 'package:trabalho_1/view/login_gui.dart';
import 'package:trabalho_1/view/weather_gui.dart';

class PrincipalPage extends StatefulWidget {
  const PrincipalPage({super.key, required this.usuario});

  final Usuario usuario;

  @override
  State<PrincipalPage> createState() => _PrincipalPageState();
}

class _PrincipalPageState extends State<PrincipalPage> {
  int _selectedIndex = 0;

  final tarefaPesquisaController = TextEditingController();
  final tarefaTextController = TextEditingController();

  final TarefaController tarefaController = TarefaController();
  final GrupoController grupoController = GrupoController();
  final UsuarioController _usuarioController = UsuarioController();

  List<Tarefa> todoList = [];
  List<Tarefa> todoListFiltrada = [];
  List<Grupo> groupList = [];

  @override
  void initState() {
    super.initState();
    grupoController.buscarGrupoPorUsuario(widget.usuario).then((value) {
      groupList = value;
      buscarTarefas(value.first);
    });
  }

  @override
  Widget build(BuildContext context) {

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
            Row(
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
                IconButton(
                icon: const Icon(Icons.sunny), 
                color: Colors.black,
                onPressed: () {
                  _usuarioController.logout();
                  Navigator.pushReplacement(
                    context,
                      MaterialPageRoute(
                      builder: (context) => WeatherPage(usuario: widget.usuario),
                    ),
                  );
                },
               ),
              ],
            ),
            Text(
              "Olá ${widget.usuario.nome ?? ''}!",
                style: TextStyle(
                  color: Colors.grey[800],
                  fontSize: 17,
                  fontWeight: FontWeight.w500
                ),
            ),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.location_on), 
                  onPressed: (){
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Center(child: Text('Funcionalidade ainda não implementada!')),
                        backgroundColor: Colors.red,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  ),
                IconButton(
                  icon: const Icon(Icons.logout), 
                  color: Colors.black,
                  onPressed: () {
                    _usuarioController.logout();
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
          ],
        ),
      ),
      // Menu bar
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
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
            for (var i = 0; i < groupList.length; i++)
              GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedIndex = i;
                  });
                  buscarTarefas(groupList[i]);
                },
                child: Container(
                  color: _selectedIndex == i ? Colors.grey[300] : null,
                  child: ListTile(
                    title: Text(groupList[i].nome),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          color: Colors.grey[600],
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            editarItemMenu(groupList[i]);
                          },
                        ),
                        IconButton(
                          color: Colors.red,
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            deletarGrupo(groupList[i]);
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
              padding: const EdgeInsets.only(right: 25, bottom: 8, top: 5),
              child: SizedBox(
                width: 46,
                height: 46,
                child: FloatingActionButton(
                  onPressed: () {
                    alertAdicionarGrupo();
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
      // Corpo do app
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
                      adicionarTarefa(tarefaTextController.text, groupList[_selectedIndex]);
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

  // Monta a lista de tarefas
  Widget montarLista(List<Tarefa> lista) {
    if (groupList.isNotEmpty) {
      if (_selectedIndex < 0) {
        _selectedIndex = 0;
      }
      return Padding(
        padding: const EdgeInsets.only(bottom: 55),
        child: ListView(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 50, bottom: 20),
              child: Text(
                groupList[_selectedIndex].nome,
                style: const TextStyle(
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
        ),
      );
    } else {
      return const Text('Nenhum grupo disponível!');
    }
  }

  Future<void> buscarTarefas(Grupo grupo) async {
    try {
      List<Tarefa> tarefas = await tarefaController.buscarTarefaPorUsuarioEGrupo(widget.usuario, grupo);
      setState(() {
        todoList = tarefas;
        if (tarefaPesquisaController.text.isEmpty) {
          todoListFiltrada = todoList;
        } else {
          todoListFiltrada = todoList.where((element) => element.descricao!.toLowerCase().contains(tarefaPesquisaController.text.toLowerCase())).toList();
        }
      });
    } catch (error) {
      print("Erro ao buscar tarefas: $error");
    }
  }

  // Adiciona uma tarefa
  void adicionarTarefa(String descricao, Grupo grupo) {
    if (tarefaTextController.text.isNotEmpty) {
      tarefaController.adicionarTarefa(descricao, widget.usuario, grupo).then((novaTarefa) {
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
  void deletarTarefa(Tarefa todo) {
    tarefaController.deletarTarefa(todo.id!).then((success) {
      setState(() {
        buscarTarefas(todo.grupo).then((_) {
          if (tarefaPesquisaController.text.isEmpty) {
            todoListFiltrada = todoList;
          } else {
            todoListFiltrada = todoList.where((element) => element.descricao!.toLowerCase().contains(tarefaPesquisaController.text.toLowerCase())).toList();
          }
        });
      });
    }).catchError((error) {
      print("Erro ao deletar tarefa: $error");
    });
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

  // Adiciona uma tarefa
  void adicionarGrupo(String descricao) {
    if (descricao.isNotEmpty) {
      grupoController.adicionarGrupo(descricao, widget.usuario).then((value) {
        setState(() {
          groupList.add(value);
          todoList=[];
          todoListFiltrada=[];
          _selectedIndex = groupList.length - 1;
        });
      }).catchError((error) {
        print("Erro ao adicionar grupo: $error");
      });
    }
  }
  
  // Dialog para adicionar um novo grupo de tarefas
  void alertAdicionarGrupo() {
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
                    adicionarGrupo(controller.text);
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

  // Deleta uma tarefa
  void deletarGrupo(Grupo grupo){
    grupoController.deletarGrupo(grupo).then((success) {
      if (grupo.id == groupList[_selectedIndex].id) {
        if (_selectedIndex == 0){
          grupoController.buscarGrupoPorUsuario(widget.usuario).then((value) {
            setState(() {
              groupList = value;
              buscarTarefas(groupList.first);
            });
          });
          return null;
        }
        setState(() {
          _selectedIndex = 0;
          buscarTarefas(groupList[_selectedIndex]);
          groupList.removeWhere((item) => item.id == grupo.id);
        });
        return null;
      }
      setState(() {
        groupList.removeWhere((item) => item.id == grupo.id);
      });
    });
  }

  // Função para editar um item do menu
  void editarItemMenu(Grupo grupo) {
    TextEditingController controller = TextEditingController(text: grupo.nome);

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
                      grupo.nome = controller.text;
                      grupoController.editarGrupo(grupo);
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
}
