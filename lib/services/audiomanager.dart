import 'package:audioplayers/audioplayers.dart';

class AudioManager {
  final AudioPlayer _player = AudioPlayer();
  bool _isMuted = false;

  Future<void> play(String assetPath) async {
    if (!_isMuted) {
      await _player.play(AssetSource(assetPath));
    }
  }

  Future<void> pause() async {
    await _player.pause();
  }

  Future<void> stop() async {
    await _player.stop();
  }

  void toggleMute() {
    _isMuted = !_isMuted;
    if (_isMuted) {
      _player.stop();  // Optionally stop the music when muted
    } else {
      // Optionally restart your background music if needed
    }
  }

  void dispose() {
    _player.dispose();
  }
}