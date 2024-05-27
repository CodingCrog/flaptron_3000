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
  
  Future<void> resume() async {
    await _player.resume();
  }

  void toggleMute() {
    _isMuted = !_isMuted;
    _isMuted ? _player.setVolume(0) : _player.setVolume(1);
  }

  bool get isMuted => _isMuted;

  void dispose() {
    _player.dispose();
  }
}
