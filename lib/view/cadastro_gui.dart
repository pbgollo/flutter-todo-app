import 'package:flutter/material.dart';
import 'package:trabalho_1/components/botao.dart';
import 'package:trabalho_1/components/textfield.dart';
import 'package:trabalho_1/control/usuario_controller.dart';
import 'package:trabalho_1/model/usuario.dart';
import 'package:trabalho_1/view/login_gui.dart';

class RegisterPage extends StatelessWidget {
  RegisterPage({super.key});

  // Controladores
  final nomeController = TextEditingController();
  final usuarioController = TextEditingController();
  final senhaController = TextEditingController();
  final UsuarioController _usuarioController = UsuarioController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 25),

              // Logo
              const Icon(
                Icons.supervised_user_circle,
                size: 115,
              ),
              const SizedBox(height: 25),

              // Mensagem de bem-vindo
              Text(
                "Vamos criar a sua conta!",
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 17,
                ),
              ),
              const SizedBox(height: 20),

              // Campo de nome
              MyTextField(
                controller: nomeController, 
                hintText: "Nome", 
                obscureText: false
              ),
              const SizedBox(height: 10),

              // Campo de usuario
              MyTextField(
                controller: usuarioController, 
                hintText: "Usuário", 
                obscureText: false
              ),
              const SizedBox(height: 10),

              // Campo de senha
              MyTextField(
                controller: senhaController, 
                hintText: "Senha", 
                obscureText: true
              ),
              const SizedBox(height: 10),

              // Mensagem termos e condicoes
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      "Li e concordo com os termos e condições.",
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 25),

              // Botão de cadastro
              MyButton(
                onTap: () {
                  Usuario usuario = Usuario(
                    nome: nomeController.text,
                    usuario: usuarioController.text,
                    senha: senhaController.text,
                  );

                  _usuarioController.adicionarUsuario(usuario);
                },
                buttonText: "Cadastre-se"
              ),
              const SizedBox(height: 135),

              // Ja possui uma conta
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Já possui uma conta?',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    const SizedBox(width: 4),
                    const Text(
                      'Entre',
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}