// ignore_for_file: avoid_print, use_build_context_synchronously

import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:trabalho_1/components/todo_item.dart';
import 'package:trabalho_1/control/audio_player_controller.dart';
import 'package:trabalho_1/control/usuario_controller.dart';
import 'package:trabalho_1/model/tarefa.dart';
import 'package:trabalho_1/model/grupo.dart';
import 'package:trabalho_1/model/usuario.dart';
import 'package:trabalho_1/control/tarefa_controller.dart';
import 'package:trabalho_1/control/grupo_controller.dart';
import 'package:trabalho_1/view/fractal_gui.dart';
import 'package:trabalho_1/view/login_gui.dart';
import 'package:trabalho_1/view/weather_gui.dart';
import 'package:trabalho_1/main.dart';

class PrincipalPage extends StatefulWidget {
  const PrincipalPage({super.key, required this.usuario});

  final Usuario usuario;

  @override
  State<PrincipalPage> createState() => _PrincipalPageState();
}

class _PrincipalPageState extends State<PrincipalPage> 
  with WidgetsBindingObserver {
  int _selectedIndex = 0;

  final tarefaPesquisaController = TextEditingController();
  final tarefaTextController = TextEditingController();
  final TarefaController tarefaController = TarefaController();
  final GrupoController grupoController = GrupoController();
  final UsuarioController _usuarioController = UsuarioController();
  final AudioPlayerController playerController = AudioPlayerController();
  
  final imagePicker = ImagePicker();

  List<Tarefa> todoList = [];
  List<Tarefa> todoListFiltrada = [];
  List<Grupo> groupList = [];

  File? imageFile;

  bool _notificationEnabled = false;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);

    super.initState();
    grupoController.buscarGrupoPorUsuario(widget.usuario).then((value) {
      groupList = value;
      buscarTarefas(value.first);
    });
  }

  @override
  Widget build(BuildContext context) {
    notificationService.setUser(widget.usuario);

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
                // Botão do Menu Bar
                Builder(
                  builder: (context) => IconButton(
                    icon: const Icon(Icons.menu),
                    color: Colors.black,
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                  ),
                ),
                // Botão da previsão do tempo
                IconButton(
                icon: const Icon(Icons.sunny), 
                color: Colors.black,
                onPressed: () {
                  _usuarioController.logout();
                  Navigator.pushReplacement(
                    context,
                    PageTransition(
                      child: WeatherPage(usuario: widget.usuario), 
                      type: PageTransitionType.topToBottom,
                      duration: const Duration(milliseconds: 600),
                      reverseDuration: const Duration(milliseconds: 600),
                    ),
                  );
                },
               ),
              ],
            ),
            // Texto de boas vindas
            Text(
              "Olá ${widget.usuario.nome ?? ''}!",
                style: TextStyle(
                  color: Colors.grey[800],
                  fontSize: 17,
                  fontWeight: FontWeight.w500
                ),
            ),
            // Botão do fractal
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.dirty_lens),
                  iconSize: 26,
                  color: Colors.black,
                  onPressed: () {
                    Navigator.pushReplacement(
                    context,
                    PageTransition(
                      child: FractalPage(usuario: widget.usuario), 
                      type: PageTransitionType.topToBottom,
                      duration: const Duration(milliseconds: 600),
                      reverseDuration: const Duration(milliseconds: 600),
                    ),
                  );
                  },
                ),
                const SizedBox(
                  height: 11,
                  width: 11,
                ),
                // Ícone do perfil do usuário
                GestureDetector(
                  onTap: () {
                    abrirModalUsuario(context, widget.usuario);
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: SizedBox(
                      height: 35,
                      width: 35,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: widget.usuario.imagem != null && widget.usuario.imagem!.isNotEmpty
                          ? widget.usuario.imagem!.startsWith('https://') || widget.usuario.imagem!.startsWith('http://')
                              ? Image.network(
                                  widget.usuario.imagem!,  
                                  fit: BoxFit.cover,
                                )
                              : Image.file(
                                  File(widget.usuario.imagem!),  
                                  fit: BoxFit.cover,
                                )
                          : const Icon(
                              Icons.account_circle,
                              size: 35,
                              color: Colors.grey,
                            ),
                      ),
                    ),
                  ),
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
                    color: Colors.white,
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
                    height: 45,
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
                        contentPadding: EdgeInsets.only(top: -11),
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
      return const Text('');
    }
  }

  // Busca as tarefas do grupo
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
        playerController.playAudio('audio/write.wav'); 
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
      if (todo.estado == 1) {
        playerController.playAudio('audio/correct.wav'); 
      }
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
      playerController.playAudio('audio/delete.wav'); 
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

  // Adiciona um novo grupo
  void adicionarGrupo(String descricao) {
    if (descricao.isNotEmpty) {
      grupoController.adicionarGrupo(descricao, widget.usuario).then((value) {
        setState(() {
          groupList.add(value);
          todoList=[];
          todoListFiltrada=[];
          _selectedIndex = groupList.length - 1;
        });
        playerController.playAudio('audio/write.wav'); 
      }).catchError((error) {
        print("Erro ao adicionar grupo: $error");
      });
    }
  }
  
  // Modal para adicionar um novo grupo de tarefas
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

  // Função para deletar um grupo do menu
  void deletarGrupo(Grupo grupo){
    grupoController.deletarGrupo(grupo).then((success) {
      playerController.playAudio('audio/delete.wav');
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

  // Modal para editar um grupo do menu
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
                    playerController.playAudio('audio/write.wav'); 
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

  // Abre um modal com as informações do usuário
  void abrirModalUsuario(BuildContext context, Usuario usuario) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 20),
              SizedBox(
                height: 120,
                width: 120,
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 65,
                      backgroundColor: Colors.grey[300],
                      backgroundImage: (() {
                        if (widget.usuario.imagem != null && widget.usuario.imagem!.isNotEmpty) {
                          if (widget.usuario.imagem!.startsWith('https://') || widget.usuario.imagem!.startsWith('http://')) {
                            return NetworkImage(widget.usuario.imagem!);
                          } else {
                            return FileImage(File(widget.usuario.imagem!));
                          }
                        } else {
                          return null;
                        }
                      })() as ImageProvider<Object>?,
                      child: widget.usuario.imagem == null || widget.usuario.imagem!.isEmpty
                        ? const Icon(
                            Icons.account_circle,
                            size: 120,
                            color: Colors.grey,
                          )
                        : null,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 5,
                      child: CircleAvatar(
                        backgroundColor: Colors.grey[300],
                        child: IconButton(
                          onPressed: (){
                            exibeBottomSheet(context);
                          },
                          icon: Icon(
                            Icons.edit,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Text(
                usuario.nome ?? '',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                usuario.usuario ?? '',
                style: const TextStyle(fontSize: 17, color: Colors.grey),
              ),
            ],
          ),
          actions: [
            ButtonBar(
              alignment: MainAxisAlignment.center,
              children: [
                // Botão de logout
                IconButton(
                  color: Colors.grey[700], 
                  iconSize: 32, 
                  icon: const Icon(Icons.logout), 
                  onPressed: () {
                    _usuarioController.logout();
                    Navigator.pushReplacement(
                      context,
                      PageTransition(
                        child: LoginPage(), 
                        type: PageTransitionType.size,
                        alignment: Alignment.center,
                        duration: const Duration(milliseconds: 600),
                        reverseDuration: const Duration(milliseconds: 600),                 
                      ),
                    );
                  },
                ),
                // Botão da biometria
                IconButton(
                  color: () {
                    if (widget.usuario.seguranca != null && widget.usuario.seguranca == 1) {
                      return Colors.green; 
                    } else {
                      return Colors.red; 
                    }
                  }(),
                  iconSize: 34, 
                  icon: const Icon(Icons.fingerprint_rounded), 
                  onPressed: () async { 
                    if (widget.usuario.seguranca != null && widget.usuario.seguranca == 1) {
                      widget.usuario.seguranca = 0;
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Center(child: Text('Biometria desativada com sucesso!')),
                            backgroundColor: Colors.red,
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                    } else {
                      bool possuiBiometria = await _usuarioController.verificaSuporteBiometria();  
                      if (possuiBiometria){
                        widget.usuario.seguranca = 1;
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Center(child: Text('Biometria ativada com sucesso!')),
                            backgroundColor: Colors.green,
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Center(child: Text('Este dispositivo não suporta biometria!')),
                            backgroundColor: Colors.red,
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      }
                    }
                    Navigator.pop(context);
                    abrirModalUsuario(context, widget.usuario);
                    _usuarioController.atualizarSeguranca(widget.usuario.usuario!, widget.usuario.seguranca!);         
                  },
                ),
                // Botão de ok
                IconButton(
                  color: Colors.green, 
                  iconSize: 36, 
                  icon: const Icon(Icons.check_rounded), 
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                // Botão de Notificação
                IconButton(
                  color:_notificationEnabled ? Colors.green : Colors.grey[700],
                  iconSize: 36, 
                    icon: Icon(
                      _notificationEnabled ? Icons.notifications_active_outlined : Icons.notifications_off_outlined,
                    ),
                  onPressed: () {
                    setState(() {
                      _notificationEnabled = !_notificationEnabled;  
                    });
                    notificationService.toggleNotifications(_notificationEnabled);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Center(child: _notificationEnabled ? const Text('Notificações habilitadas com sucesso!'): const Text('Notificações desativadas com sucesso!')),
                        backgroundColor: _notificationEnabled ? Colors.green : Colors.red,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                    Navigator.pop(context);
                    abrirModalUsuario(context, widget.usuario);
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  // Método que seleciona a imagem da câmera/galeria do usuário
  void pegarImagem(ImageSource source) async {
    final pickedFile = await imagePicker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        widget.usuario.imagem = pickedFile.path;
        print("Caminho da imagem: ${widget.usuario.imagem}");
        _usuarioController.atualizarImagemUsuario(widget.usuario.usuario!, pickedFile.path);
      });
    }
    Navigator.pop(context);
    abrirModalUsuario(context, widget.usuario);
  }

  // Exibe as opções de manipulação da imagem
  void exibeBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.grey[200],
                  child: Center(
                    child: Icon(
                      Icons.add_photo_alternate_outlined,
                      color: Colors.grey[500],
                    ),
                  ),
                ),
                title: Text(
                  'Galeria',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  // Buscar imagem da galeria
                  pegarImagem(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.grey[200],
                  child: Center(
                    child: Icon(
                      Icons.add_a_photo_outlined,
                      color: Colors.grey[500],
                    ),
                  ),
                ),
                title: Text(
                  'Câmera',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  // Fazer foto da câmera
                  pegarImagem(ImageSource.camera);
                },
              ),
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.grey[200],
                  child: Center(
                    child: Icon(
                      Icons.delete_outline,
                      color: Colors.grey[500],
                    ),
                  ),
                ),
                title: Text(
                  'Remover',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  // Tornar a foto null
                  setState(() {
                    widget.usuario.imagem = null;
                  });
                  Navigator.pop(context);
                  abrirModalUsuario(context, widget.usuario);
                  _usuarioController.atualizarImagemUsuario(widget.usuario.usuario!, "");
                },
              ),
            ],
          ),
        );
      },
    );
  } 
}
