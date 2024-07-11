import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:async';
import 'dart:isolate';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;

class FractalController with ChangeNotifier {
  ui.Image? fractalImage;
  Duration elapsedTime = Duration.zero;

  final Random random = Random();

  // Parâmetros conhecidos que produzem bons fractais de Julia
  final List<List<double>> knownGoodParams = [
    [-0.7, 0.27015],
    [0.355, 0.355],
    [-0.4, 0.6],
    [0.37, -0.1],
    [-0.70176, -0.3842]
  ];

  // Método para iniciar a geração do fractal
  Future<void> generateFractal() async {
    List<double> params = knownGoodParams[random.nextInt(knownGoodParams.length)];
    double cx = params[0];
    double cy = params[1];

    final Stopwatch stopwatch = Stopwatch()..start();

    // Chama a função para calcular o fractal em um isolado
    final result = await computeJuliaFractalIsolate(800, 800, cx, cy);

    // Tempo total de execução dos métodos
    elapsedTime = stopwatch.elapsed;

    final codec = await ui.instantiateImageCodec(result.imageData);
    final frame = await codec.getNextFrame();
    fractalImage = frame.image;

    notifyListeners();
  }

  // Função assíncrona para calcular o fractal em um isolado
  Future<FractalResult> computeJuliaFractalIsolate(int width, int height, double cx, double cy) async {
    final receivePort = ReceivePort();
    final isolate = await Isolate.spawn(_computeJuliaFractal, receivePort.sendPort);

    final sendPort = await receivePort.first as SendPort;
    final responsePort = ReceivePort();

    sendPort.send([responsePort.sendPort, width, height, cx, cy]);
    final result = await responsePort.first as FractalResult;

    receivePort.close();
    responsePort.close();
    isolate.kill(priority: Isolate.immediate);  // Fecha o Isolate

    return result;
  }

  // Função executada no isolado para calcular o fractal
  static void _computeJuliaFractal(SendPort sendPort) async {
    final receivePort = ReceivePort();
    sendPort.send(receivePort.sendPort);

    await for (final message in receivePort) {
      final replyPort = message[0] as SendPort;
      final width = message[1] as int;
      final height = message[2] as int;
      final cx = message[3] as double;
      final cy = message[4] as double;

      final img.Image image = img.Image(width, height);
      const int maxIter = 255;

      final Stopwatch stopwatch = Stopwatch()..start();

      for (int x = 0; x < width; x++) {
        for (int y = 0; y < height; y++) {
          double zx = 1.5 * (x - width / 2) / (0.5 * width);
          double zy = (y - height / 2) / (0.5 * height);
          int i = maxIter;
          while (zx * zx + zy * zy < 4.0 && i > 0) {
            double tmp = zx * zx - zy * zy + cx;
            zy = 2.0 * zx * zy + cy;
            zx = tmp;
            i--;
          }

          int color = (255 * (i / maxIter)).toInt();
          image.setPixel(x, y, img.getColor(color, color, color));
        }
      }

      final Uint8List imageData = Uint8List.fromList(img.encodePng(image));
      final elapsedTime = stopwatch.elapsed;

      replyPort.send(FractalResult(imageData, elapsedTime));
      receivePort.close();  // Fecha o ReceivePort no isolado
    }
  }
}

class FractalResult {
  final Uint8List imageData;
  final Duration elapsedTime;

  FractalResult(this.imageData, this.elapsedTime);
}
