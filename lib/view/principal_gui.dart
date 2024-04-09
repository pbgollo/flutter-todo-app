import 'package:flutter/material.dart';
import 'package:trabalho_1/model/usuario.dart';

class PrincipalPage extends StatelessWidget {
  final Usuario? usuario;

  const PrincipalPage({super.key, required this.usuario});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      resizeToAvoidBottomInset: false,
    );
  }
}