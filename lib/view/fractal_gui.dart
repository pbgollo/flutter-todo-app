// ignore_for_file: library_private_types_in_public_api

import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trabalho_1/control/fractal_controller.dart';
import 'package:trabalho_1/model/usuario.dart';
import 'package:page_transition/page_transition.dart';
import 'package:trabalho_1/view/principal_gui.dart';

class FractalPage extends StatefulWidget {
  final Usuario usuario;

  const FractalPage({super.key, required this.usuario});

  @override
  _FractalPageState createState() => _FractalPageState();
}

class _FractalPageState extends State<FractalPage> {
  final FractalController _controller = FractalController();
  Uint8List? _imageBytes;
  String _elapsedTimeText = '';

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onControllerChange);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onControllerChange() {
    setState(() {
      _elapsedTimeText = 'Tempo decorrido: ${_controller.elapsedTime.inMilliseconds} ms';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[250],
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(30.0),
        child: AppBar(
          backgroundColor: Colors.transparent, 
          elevation: 0, 
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                PageTransition(
                  child: PrincipalPage(usuario: widget.usuario), 
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Fractal de Julia",
              style: GoogleFonts.bebasNeue(
                fontSize: 45,
                fontWeight: FontWeight.bold, 
                color: Colors.grey[700], 
              ),
            ),
            const SizedBox(height: 50),
            Container(
              width: 380, 
              height: 380,
              decoration: BoxDecoration(
                border: Border.all(
                  color: const Color.fromARGB(255, 0, 0, 0), 
                  width: 1.0,
                ),
              ),
              child: Center(
                child: _imageBytes == null
                    ? const Text('Pressione o botão para gerar o fractal',
                        style: TextStyle(
                        fontSize: 17.0, 
                        fontWeight: FontWeight.bold,  
                      ),
                    )
                    : Image.memory(_imageBytes!),
              ),
            ),
            const SizedBox(height: 15),
            Text(
              _elapsedTimeText,
              style: const TextStyle(
                fontSize: 16.0,  
                fontWeight: FontWeight.bold,  
              ),
            ),
            const SizedBox(height: 95),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueAccent,
        onPressed: () async {
          await _generateFractal();
        },
        child: const Icon(
          Icons.dirty_lens,
          size: 32,
          color: Colors.white,
        ),
      ),
    );
  }

  Future<void> _generateFractal() async {
    await _controller.generateFractal();
    final image = _controller.fractalImage;
    if (image != null) {
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      setState(() {
        _imageBytes = byteData!.buffer.asUint8List();
      });
    }
  }
}
