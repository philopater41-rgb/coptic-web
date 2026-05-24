import 'package:flutter/material.dart';
import 'audio_service.dart';

class SettingsService extends ChangeNotifier {
  static final SettingsService _instance = SettingsService._internal();
  factory SettingsService() => _instance;
  SettingsService._internal();

  // Words page settings
  bool _wordsShowCoptic = true;
  bool _wordsShowArabic = true;
  bool _wordsShowPronunciation = true;
  bool _wordsShowImage = true;

  // Hymns page settings
  bool _hymnsShowCoptic = true;
  bool _hymnsShowArabic = true;
  bool _hymnsShowPronunciation = true;

  // Getters for Words Page
  bool get wordsShowCoptic => _wordsShowCoptic;
  bool get wordsShowArabic => _wordsShowArabic;
  bool get wordsShowPronunciation => _wordsShowPronunciation;
  bool get wordsShowImage => _wordsShowImage;

  // Getters for Hymns Page
  bool get hymnsShowCoptic => _hymnsShowCoptic;
  bool get hymnsShowArabic => _hymnsShowArabic;
  bool get hymnsShowPronunciation => _hymnsShowPronunciation;

  // Compatibility Getters (mapping to Words page)
  bool get showCoptic => _wordsShowCoptic;
  bool get showArabic => _wordsShowArabic;
  bool get showPronunciation => _wordsShowPronunciation;
  bool get showImage => _wordsShowImage;

  double get audioSpeed => AudioService().playbackSpeed;

  void setAudioSpeed(double speed) {
    AudioService().setSpeed(speed);
    notifyListeners();
  }

  // Setters for Words Page
  void setWordsShowCoptic(bool value) {
    if (value == _wordsShowCoptic) return;
    _wordsShowCoptic = value;
    notifyListeners();
  }

  void setWordsShowArabic(bool value) {
    if (value == _wordsShowArabic) return;
    _wordsShowArabic = value;
    notifyListeners();
  }

  void setWordsShowPronunciation(bool value) {
    if (value == _wordsShowPronunciation) return;
    _wordsShowPronunciation = value;
    notifyListeners();
  }

  void setWordsShowImage(bool value) {
    if (value == _wordsShowImage) return;
    _wordsShowImage = value;
    notifyListeners();
  }

  // Setters for Hymns Page
  void setHymnsShowCoptic(bool value) {
    if (value == _hymnsShowCoptic) return;
    _hymnsShowCoptic = value;
    notifyListeners();
  }

  void setHymnsShowArabic(bool value) {
    if (value == _hymnsShowArabic) return;
    _hymnsShowArabic = value;
    notifyListeners();
  }

  void setHymnsShowPronunciation(bool value) {
    if (value == _hymnsShowPronunciation) return;
    _hymnsShowPronunciation = value;
    notifyListeners();
  }

  // Compatibility Setters (mapping to Words page)
  void setShowCoptic(bool value) => setWordsShowCoptic(value);
  void setShowArabic(bool value) => setWordsShowArabic(value);
  void setShowPronunciation(bool value) => setWordsShowPronunciation(value);
  void setShowImage(bool value) => setWordsShowImage(value);
}
