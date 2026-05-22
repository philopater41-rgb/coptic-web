import 'package:flutter/material.dart';

class Stage {
  final String id;
  final String name;
  final String subtext;
  final Color color;
  final Color accent;
  final bool hideLetters;
  final bool hideGrammar;
  final bool hideWords;

  const Stage({
    required this.id,
    required this.name,
    this.subtext = '',
    required this.color,
    required this.accent,
    this.hideLetters = false,
    this.hideGrammar = false,
    this.hideWords = false,
  });
}

class StageService extends ChangeNotifier {
  static final StageService _instance = StageService._internal();

  factory StageService() => _instance;

  StageService._internal();

  final List<Stage> stages = const [
    Stage(id: "nursery", name: "حضانة", color: Color(0xFFFFEBEE), accent: Color(0xFFC62828), hideGrammar: true),
    Stage(id: "primary12", name: "أولى وتانية", color: Color(0xFFFFF8E1), accent: Color(0xFFE65100), hideGrammar: true),
    Stage(id: "primary34", name: "تالتة ورابعة", color: Color(0xFFE8F5E9), accent: Color(0xFF2E7D32)),
    Stage(id: "primary56", name: "خامسة وسادسة", color: Color(0xFFE3F2FD), accent: Color(0xFF1565C0)),
    Stage(id: "prep", name: "إعدادي", color: Color(0xFFFCE4EC), accent: Color(0xFFC2185B)),
    Stage(id: "sec", name: "ثانوي", color: Color(0xFFE8EAF6), accent: Color(0xFF283593)),
    Stage(id: "qana", name: "قانا الجليل", color: Color(0xFFE0F7FA), accent: Color(0xFF00838F)),
    Stage(id: "uni", name: "جامعة", color: Color(0xFFE0F2F1), accent: Color(0xFF00695C)),
    Stage(id: "graduates", name: "خريجين", color: Color(0xFFE1F5FE), accent: Color(0xFF0277BD)),
    Stage(id: "servants", name: "خدام", color: Color(0xFFEDE7F6), accent: Color(0xFF4527A0)),
    Stage(id: "servants_trainees", name: "إعداد خدام", color: Color(0xFFF3E5F5), accent: Color(0xFF6A1B9A)),
    Stage(
      id: "special_needs_simple", 
      name: "ذوي الهمم (بسيط)", 
      color: Color(0xFFE8F5E9), 
      accent: Color(0xFF2E7D32),
      hideLetters: true,
      hideGrammar: true,
    ),
    Stage(
      id: "special_needs_average", 
      name: "ذوي الهمم (متوسط)", 
      color: Color(0xFFFFF3E0), 
      accent: Color(0xFFE65100),
      hideLetters: true,
      hideGrammar: true,
    ),
    Stage(
      id: "special_needs_advanced", 
      name: "ذوي الهمم (متميز)", 
      color: Color(0xFFFCE4EC), 
      accent: Color(0xFFC2185B),
      hideLetters: true,
      hideWords: true,
      hideGrammar: true,
    ),
  ];

  late Stage _selectedStage = stages[0];

  Stage get selectedStage => _selectedStage;

  void setSelectedStage(Stage stage) {
    _selectedStage = stage;
    notifyListeners();
  }
}
