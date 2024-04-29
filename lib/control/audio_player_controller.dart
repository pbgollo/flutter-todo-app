import 'package:audioplayers/audioplayers.dart';

class AudioPlayerController {

  // Reproduz o áudio que é passado como parâmetro
  Future<void> playAudio(String audioPath) async {
    final player = AudioPlayer();
    await player.play(AssetSource(audioPath));
  }

}
