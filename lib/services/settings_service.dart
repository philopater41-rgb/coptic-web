import 'package:flutter/material.dart';
import 'audio_service.dart';

class SettingsService extends ChangeNotifier {
  static final SettingsService _instance = SettingsService._internal();
  factory SettingsService() => _instance;
  SettingsService._internal();

  bool _showCoptic = true;
  bool _showArabic = true;
  bool _showPronunciation = true;
  bool _showImage = true;

  bool get showCoptic => _showCoptic;
  bool get showArabic => _showArabic;
  bool get showPronunciation => _showPronunciation;
  bool get showImage => _showImage;

  double get audioSpeed => AudioService().playbackSpeed;

  void setAudioSpeed(double speed) {
    AudioService().setSpeed(speed);
    notifyListeners();
  }

  void setShowCoptic(bool value) {
    if (value == _showCoptic) return;
    _showCoptic = value;
    notifyListeners();
  }

  void setShowArabic(bool value) {
    if (value == _showArabic) return;
    _showArabic = value;
    notifyListeners();
  }

  void setShowPronunciation(bool value) {
    if (value == _showPronunciation) return;
    _showPronunciation = value;
    notifyListeners();
  }

  void setShowImage(bool value) {
    if (value == _showImage) return;
    _showImage = value;
    notifyListeners();
  }
}
