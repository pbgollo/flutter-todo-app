// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:trabalho_1/components/botao_login.dart';
import 'package:trabalho_1/components/botao_redes.dart';
import 'package:trabalho_1/components/text_field.dart';
import 'package:trabalho_1/control/usuario_controller.dart';
import 'package:trabalho_1/model/usuario.dart';
import 'package:trabalho_1/view/cadastro_gui.dart';
import 'package:trabalho_1/view/principal_gui.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

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
                size: 110,
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
              // Texto esqueci minha senha
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
                  String nomeUsuario = usuarioController.text;
                  String senha = senhaController.text;

                  if (nomeUsuario.isEmpty || senha.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Center(child: Text('Preencha todos os campos!')),
                        backgroundColor: Colors.red,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  } else {
                    bool usuarioValido = await _usuarioController.validarUsuario(nomeUsuario, senha);
                    if (usuarioValido) {
                      Usuario usuario = (await _usuarioController.consultarUsuarioPorNome(nomeUsuario))!;
                      _usuarioController.verificaSeguranca(usuario);            
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Center(child: Text('Login bem-sucedido!')),
                          backgroundColor: Colors.green,
                          behavior: SnackBarBehavior.floating,
                          duration: Duration(seconds: 2),
                        ),
                      ); 
                      Navigator.pushReplacement(
                        context,
                          PageTransition(
                            child: PrincipalPage(usuario: usuario), 
                            type: PageTransitionType.size,
                            alignment: Alignment.center,
                            duration: const Duration(milliseconds: 600),
                            reverseDuration: const Duration(milliseconds: 600),
                          ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Center(child: Text('Credenciais inválidas!')),
                          backgroundColor: Colors.red,
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    }
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
              // Botão do Google
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SquareTile(
                    onTap: () async {
                      Usuario? usuario = await _usuarioController.signInWithGoogle();
                      if (usuario != null) {
                        Navigator.pushReplacement(
                          context,
                          PageTransition(
                            child: PrincipalPage(usuario: usuario), 
                            type: PageTransitionType.size,
                            alignment: Alignment.center,
                            duration: const Duration(milliseconds: 600),
                            reverseDuration: const Duration(milliseconds: 600),
                          ),
                        );
                      } else {
                        print('Falha ao fazer login com o Google');
                      }
                    },
                    imagePath: 'assets/images/google.png'
                  ),
                  const SizedBox(width: 20),
                  SquareTile(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Center(child: Text('Funcionalidade ainda não implementada!')),
                          backgroundColor: Colors.red,
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                    imagePath: 'assets/images/github.png'
                  ),
                ],
              ),
              const SizedBox(height: 40),
              // Texto não possui uma conta
              GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      PageTransition(
                        child: RegisterPage(), 
                        type: PageTransitionType.rightToLeft,
                        duration: const Duration(milliseconds: 200),
                        reverseDuration: const Duration(milliseconds: 200),
                      ),
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
                        color: Colors.blueAccent,
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