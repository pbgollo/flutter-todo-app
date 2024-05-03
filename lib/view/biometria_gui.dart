// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';
import 'package:trabalho_1/control/usuario_controller.dart';
import 'package:trabalho_1/model/usuario.dart';
import 'package:trabalho_1/view/login_gui.dart';
import 'package:trabalho_1/view/principal_gui.dart';

class BiometricPage extends StatefulWidget {
  const BiometricPage({super.key, required this.usuario});

  final Usuario usuario;

  @override
  State<BiometricPage> createState() => _BiometricPageState();
}

class _BiometricPageState extends State<BiometricPage> {

  final UsuarioController _usuarioController = UsuarioController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // App bar
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(30.0), 
        child: AppBar(
          backgroundColor: Colors.transparent, 
          elevation: 0, 
          // Botão de voltar
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushReplacement(
              context,
              PageTransition(
                child: LoginPage(), 
                type: PageTransitionType.bottomToTop,
                duration: const Duration(milliseconds: 600),
                reverseDuration: const Duration(milliseconds: 600),
                ),
              );
            },
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            // Ícone de cadeado
            Icon(Icons.lock,
              color: Colors.grey[500], 
              size: 25,
            ),
            const SizedBox(height: 5),
            // Texto da autenticação
            Text(
              "Autenticação Biométrica",
              style: GoogleFonts.bebasNeue(
                fontSize: 25,
                fontWeight: FontWeight.w400, 
                color: Colors.grey[500], 
              ),
            ),
            const SizedBox(height: 100),
            // Animação da digital
            Lottie.asset(
              "assets/animation/fingerprint.json",
              width: 160, 
              height: 160,
            ),
            const SizedBox(height: 100),
            // Texto de use a biometria
            Text(
              "Use sua biometria para prosseguir!",
              style: GoogleFonts.bebasNeue(
                fontSize: 25,
                fontWeight: FontWeight.w400, 
                color: Colors.grey[500], 
              ),
            ),
            const SizedBox(height: 15),
            // Botão que verifica a impressão digital
            SizedBox(
              width: 140,
              child: ElevatedButton(
                onPressed: () async {
                  bool autenticado = await _usuarioController.solicitaBiometria();
                  if (autenticado) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Center(child: Text('Autenticação bem-sucedida!')),
                        backgroundColor: Colors.green,
                        behavior: SnackBarBehavior.floating,
                        duration: Duration(seconds: 2),
                      ),
                    );
                    Navigator.pushReplacement(
                      context,
                      PageTransition(
                        child: PrincipalPage(usuario: widget.usuario),
                        type: PageTransitionType.size,
                        alignment: Alignment.center,
                        duration: const Duration(milliseconds: 600),
                        reverseDuration: const Duration(milliseconds: 600),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Center(child: Text('Autenticação biométrica falhou!')),
                        backgroundColor: Colors.red,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: 
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                         Icons.fingerprint,
                         size: 26,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 5), 
                      Text(
                        "Verificar",
                        style: GoogleFonts.bebasNeue(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
              ),
            ),
          ],
        ),
      ),  
    );
  }
}