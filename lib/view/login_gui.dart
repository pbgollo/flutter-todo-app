import 'package:flutter/material.dart';
import 'package:trabalho_1/components/botao.dart';
import 'package:trabalho_1/components/quadrado.dart';
import 'package:trabalho_1/components/textfield.dart';
import 'package:trabalho_1/control/usuario_controller.dart';
import 'package:trabalho_1/view/cadastro_gui.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  // Controladores
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
                Icons.lock,
                size: 100,
              ),
              const SizedBox(height: 30),

              // Mensagem de bem-vindo
              Text(
                "Seja bem-vindo de volta!",
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 17,
                ),
              ),
              const SizedBox(height: 20),

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

              // Mensagem esqueci minha senha
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      "Esqueceu sua senha?",
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 25),

              // Botao de login
              MyButton(
                onTap: () async {
                  // Obtendo valores dos campos de texto
                  String nomeUsuario = usuarioController.text;
                  String senha = senhaController.text;

                  // Chamando o método validarUsuario
                  bool usuarioValido = await _usuarioController.validarUsuario(nomeUsuario, senha);
                  if (usuarioValido) {
                    // Faça algo se o usuário for válido, como navegar para outra tela
                    print('Usuário válido. Acesso permitido.');
                  } else {
                    // Faça algo se o usuário não for válido, como exibir uma mensagem de erro
                    print('Usuário ou senha inválidos. Acesso negado.');
                  }
                }, 
                buttonText: "Entrar"
              ),
              const SizedBox(height: 40),

              // Linha continue com
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Divider(
                        thickness: 0.5,
                        color: Colors.grey[400],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text(
                        'Ou continue com',
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        thickness: 0.5,
                        color: Colors.grey[400],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              // Botao do google
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SquareTile(onTap:(){}, imagePath: 'lib/images/google.png'),
                ],
              ),
              const SizedBox(height: 45),

              // Nao possui uma conta
              GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RegisterPage()),
                    );
                  },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Não possui uma conta?',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    const SizedBox(width: 4),
                    const Text(
                      'Cadastre-se',
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