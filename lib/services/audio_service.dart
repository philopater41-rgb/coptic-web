import 'package:just_audio/just_audio.dart';
import 'package:flutter/foundation.dart';

/// A singleton service to manage audio playback across the entire app.
class AudioService {
  static final AudioService _instance = AudioService._internal();
  factory AudioService() => _instance;

  final AudioPlayer _player = AudioPlayer();
  void Function()? _onCompleteCallback;

  AudioService._internal() {
    // just_audio handles web contexts much better than audioplayers.
    // Listen for playback completion.
    _player.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        if (_onCompleteCallback != null) {
          _onCompleteCallback!();
        }
      }
    });
  }

  AudioPlayer get player => _player;
  double _speed = 1.0;

  double get speed => _speed;

  Future<void> setSpeed(double speed) async {
    _speed = speed;
    try {
      await _player.setSpeed(speed);
    } catch (e) {
      debugPrint("AudioService setSpeed Error: $e");
    }
  }

  void setOnComplete(void Function() callback) {
    _onCompleteCallback = callback;
  }

  bool _isProcessing = false;

  Future<void> playAsset(String path) async {
    if (_isProcessing) {
      try {
        await _player.stop();
      } catch (_) {}
    }
    _isProcessing = true;

    // Clean path
    String cleanPath = path.trim();
    if (cleanPath.startsWith('/')) cleanPath = cleanPath.substring(1);
    if (cleanPath.startsWith('assets/')) cleanPath = cleanPath.replaceFirst('assets/', '');
    final assetPath = 'assets/$cleanPath';
    
    try {
      // 1. Stop and give the browser a moment to flush the audio buffer.
      await _player.stop();
      await Future.delayed(const Duration(milliseconds: 50));
      
      // 2. Load the source without pre-playing.
      // We use Uri.parse('asset:///') for Flutter Web asset resolution.
      await _player.setAudioSource(
        AudioSource.uri(Uri.parse('asset:///$assetPath')),
        preload: false,
      );
      
      // 3. Explicitly load and wait for the 'ready' state.
      await _player.load();

      // Apply current playback speed
      await _player.setSpeed(_speed);
      
      // 4. Reset position and a small final delay to ensure sync.
      await _player.seek(Duration.zero);
      await Future.delayed(const Duration(milliseconds: 50));
      
      // 5. Play only if we are still the active request.
      _player.play();
    } catch (e) {
      debugPrint("AudioService Error playing $assetPath: $e");
    } finally {
      _isProcessing = false;
    }
  }

  Future<void> stop() async {
    try {
      await _player.stop();
    } catch (e) {
      debugPrint("AudioService stop Error: $e");
    }
  }

  Future<void> pause() async {
    try {
      await _player.pause();
    } catch (e) {
      debugPrint("AudioService pause Error: $e");
    }
  }

  void dispose() {
    _player.dispose();
  }
}
