import 'dart:async';
import 'dart:js' as js;
import 'package:flutter/foundation.dart';

/// A Web-specific implementation of AudioService that uses a single, persistent
/// HTMLAudioElement via JavaScript (audio_helper.js) to bypass mobile browsers' limits.
class AudioService {
  static final AudioService _instance = AudioService._internal();
  factory AudioService() => _instance;

  double _speed = 1.0;
  void Function()? _onCompleteCallback;
  
  final StreamController<Duration> _positionController = StreamController<Duration>.broadcast();
  Timer? _positionTimer;

  AudioService._internal() {
    // Register the completion callback with JS.
    // Wrap it using allowInterop.
    js.context['webAudioOnEnded'] = js.allowInterop(() {
      _stopTimer();
      _positionController.add(Duration.zero);
      if (_onCompleteCallback != null) {
        // Run the callback to notify listeners
        _onCompleteCallback!();
      }
    });
  }

  Stream<Duration> get onPositionChanged => _positionController.stream;

  Future<Duration?> getDuration() async {
    try {
      final double seconds = js.context.callMethod('webGetAudioDuration') as double? ?? 0.0;
      return Duration(milliseconds: (seconds * 1000).round());
    } catch (e) {
      debugPrint("AudioService getDuration Error: $e");
      return null;
    }
  }

  void setOnComplete(void Function() callback) {
    // Capture the current Dart/Flutter Zone so that when JS invokes the callback,
    // the callback executes in the correct zone. This ensures setState triggers UI updates.
    final zone = Zone.current;
    _onCompleteCallback = () {
      zone.run(callback);
    };
  }

  void _startTimer() {
    _stopTimer();
    _positionTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      try {
        final double posSec = js.context.callMethod('webGetAudioPosition') as double? ?? 0.0;
        _positionController.add(Duration(milliseconds: (posSec * 1000).round()));
      } catch (_) {}
    });
  }

  void _stopTimer() {
    _positionTimer?.cancel();
    _positionTimer = null;
  }

  Future<void> playAsset(String path) async {
    String cleanPath = path.trim();
    if (cleanPath.startsWith('/')) cleanPath = cleanPath.substring(1);
    if (cleanPath.startsWith('assets/')) {
      cleanPath = cleanPath.replaceFirst('assets/', '');
    }

    final String url = "assets/assets/$cleanPath";

    try {
      _stopTimer();
      js.context.callMethod('webPlayAudio', [url, _speed]);
      _startTimer();
    } catch (e) {
      debugPrint("AudioService Web Error playing $url: $e");
    }
  }

  Future<void> stop() async {
    try {
      _stopTimer();
      js.context.callMethod('webStopAudio');
      _positionController.add(Duration.zero);
    } catch (e) {
      debugPrint("AudioService stop Error: $e");
    }
  }

  Future<void> pause() async {
    try {
      _stopTimer();
      js.context.callMethod('webPauseAudio');
    } catch (e) {
      debugPrint("AudioService pause Error: $e");
    }
  }

  double get playbackSpeed => _speed;

  Future<void> setSpeed(double speed) async {
    _speed = speed;
    try {
      js.context.callMethod('webSetAudioSpeed', [speed]);
    } catch (e) {
      debugPrint("AudioService setSpeed Error: $e");
    }
  }

  void dispose() {
    _stopTimer();
    _positionController.close();
  }
}
