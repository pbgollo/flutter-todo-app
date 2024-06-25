import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:trabalho_1/control/fractal_controller.dart';
import 'package:trabalho_1/model/usuario.dart';
import 'package:page_transition/page_transition.dart';
import 'package:trabalho_1/view/principal_gui.dart';

class FractalPage extends StatefulWidget {
  final Usuario usuario;

  const FractalPage({Key? key, required this.usuario}) : super(key: key);

  @override
  _FractalPageState createState() => _FractalPageState();
}

class _FractalPageState extends State<FractalPage> {
  final FractalController _controller = FractalController();
  Uint8List? _imageBytes;
  String _iterationsText = '';
  String _elapsedTimeText = '';

  @override
  void initState() {
    super.initState();
    // Adiciona um listener para o FractalController
    _controller.addListener(_onControllerChange);
  }

  @override
  void dispose() {
    _controller.dispose(); // Limpa o listener do FractalController
    super.dispose();
  }

  void _onControllerChange() {
    // Atualiza o estado do widget quando o FractalController mudar
    setState(() {
      _iterationsText = 'Número de iterações: ${_controller.iterations}';
      _elapsedTimeText = 'Tempo decorrido: ${_controller.elapsedTime.inMilliseconds} ms';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100], // Cor de fundo do Scaffold
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(30.0),
        child: AppBar(
          backgroundColor: Colors.transparent, // Cor transparente para a barra de navegação
          elevation: 0, // Sem sombra
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
            Container(
              width: 380, // Largura do contêiner
              height: 380, // Altura do contêiner
              decoration: BoxDecoration(
                border: Border.all(
                  color: const Color.fromARGB(255, 0, 0, 0), // Cor da borda
                  width: 1.0, // Largura da borda
                ),
              ),
              child: Center(
                child: _imageBytes == null
                    ? const Text('Pressione o botão para gerar o fractal!')
                    : Image.memory(_imageBytes!),
              ),
            ),
            const SizedBox(height: 20),
            Text(_iterationsText),
            Text(_elapsedTimeText),
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
