import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:google_fonts/google_fonts.dart';
import 'screens/home_page.dart';
import 'screens/letters_page.dart';
import 'screens/words_page.dart';
import 'screens/hymns_page.dart';
import 'screens/grammar_page.dart';
import 'screens/bookmarks_page.dart';
import 'services/stage_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'منهج القبطي',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFB45309)),
        useMaterial3: true,
        textTheme: GoogleFonts.cairoTextTheme(),
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  final StageService _stageService = StageService();

  @override
  void initState() {
    super.initState();
    _stageService.addListener(_onStageChanged);
  }

  @override
  void dispose() {
    _stageService.removeListener(_onStageChanged);
    super.dispose();
  }

  void _onStageChanged() {
    // If the currently selected tab becomes hidden, switch to Home (0)
    final stage = _stageService.selectedStage;
    bool currentIsHidden = false;
    if (_selectedIndex == 1 && stage.hideLetters) currentIsHidden = true;
    if (_selectedIndex == 2 && stage.hideWords) currentIsHidden = true;
    if (_selectedIndex == 4 && stage.hideGrammar) currentIsHidden = true;

    if (currentIsHidden) {
      setState(() {
        _selectedIndex = 0;
      });
    } else {
      setState(() {});
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final stage = _stageService.selectedStage;

    final List<Widget> widgetOptions = <Widget>[
      HomePage(onNavigateTo: _onItemTapped),
      const LettersPage(),
      const WordsPage(),
      const HymnsPage(),
      const GrammarPage(),
      const BookmarksPage(),
    ];

    // Define all possible items
    final allItems = [
      {'index': 0, 'icon': Icons.home_rounded, 'label': 'الرئيسية', 'hide': false},
      {'index': 1, 'icon': Icons.sort_by_alpha_rounded, 'label': 'الحروف', 'hide': stage.hideLetters},
      {'index': 2, 'icon': Icons.menu_book_rounded, 'label': 'الكلمات', 'hide': stage.hideWords},
      {'index': 3, 'icon': Icons.headphones_rounded, 'label': 'المحفوظات', 'hide': false},
      {'index': 4, 'icon': Icons.gavel_rounded, 'label': 'القواعد', 'hide': stage.hideGrammar},
      {'index': 5, 'icon': Icons.star_rounded, 'label': 'المحفوظة', 'hide': false},
    ];

    final visibleItems = allItems.where((item) => !(item['hide'] as bool)).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFFAF7F0), // Parchment Light Background
      body: Stack(
        children: [
          // Background Mesh matched to Next.js - Optimized with CustomPaint
          Positioned.fill(
            child: RepaintBoundary(
              child: CustomPaint(
                painter: BackgroundPainter(),
              ),
            ),
          ),

          // Core Content
          SafeArea(
            bottom: false,
            child: widgetOptions.elementAt(_selectedIndex),
          ),

          // Bottom Navigation Bar
          Align(
            alignment: Alignment.bottomCenter,
            child: RepaintBoundary(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 24.0, left: 16.0, right: 16.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(32),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 16.0, sigmaY: 16.0),
                    child: Container(
                      height: 74,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.76),
                        borderRadius: BorderRadius.circular(32),
                        border: Border.all(color: Colors.white.withValues(alpha: 0.6)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.04),
                            blurRadius: 20,
                          )
                        ]
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: visibleItems.map((item) => _buildNavItem(
                          item['index'] as int, 
                          item['icon'] as IconData, 
                          item['label'] as String
                        )).toList(),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {

    final isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () => _onItemTapped(index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            index == 1
                ? Text(
                    'ⲀⲰ',
                    style: TextStyle(
                      fontFamily: 'CopticStandard',
                      fontSize: isSelected ? 19 : 17,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? const Color(0xFFB45309) : const Color(0xFF94A3B8),
                    ),
                  )
                : Icon(
                    icon,
                    color: isSelected ? const Color(0xFFB45309) : const Color(0xFF94A3B8),
                    size: isSelected ? 25 : 22,
                  ),
            const SizedBox(height: 3),
            Text(
              label,
              style: GoogleFonts.cairo(
                fontSize: 10,
                fontWeight: FontWeight.w900,
                color: isSelected ? const Color(0xFFB45309) : const Color(0xFF94A3B8),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class BackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    
    // Draw base color
    canvas.drawRect(rect, Paint()..color = const Color(0xFFFAF7F0));
    
    // Draw gradient circles
    final paint1 = Paint()
      ..shader = const RadialGradient(
        colors: [Color(0x119A1515), Colors.transparent],
      ).createShader(Rect.fromCenter(center: Offset(size.width * 0.15, size.height * 0.15), width: size.width * 1.5, height: size.height * 1.5));
    canvas.drawRect(rect, paint1);

    final paint2 = Paint()
      ..shader = const RadialGradient(
        colors: [Color(0x17C27C0E), Colors.transparent],
      ).createShader(Rect.fromCenter(center: Offset(size.width * 0.85, size.height * 0.1), width: size.width * 1.5, height: size.height * 1.5));
    canvas.drawRect(rect, paint2);

    final paint3 = Paint()
      ..shader = const RadialGradient(
        colors: [Color(0xE6FFFFFF), Colors.transparent],
      ).createShader(Rect.fromCenter(center: Offset(size.width * 0.5, size.height * 0.6), width: size.width * 2.2, height: size.height * 2.2));
    canvas.drawRect(rect, paint3);

    final paint4 = Paint()
      ..shader = const RadialGradient(
        colors: [Color(0x0A0E3C78), Colors.transparent],
      ).createShader(Rect.fromCenter(center: Offset(size.width * 0.05, size.height * 0.9), width: size.width * 1.4, height: size.height * 1.4));
    canvas.drawRect(rect, paint4);
    
    final paint5 = Paint()
      ..shader = const RadialGradient(
        colors: [Color(0x0A9A1515), Colors.transparent],
      ).createShader(Rect.fromCenter(center: Offset(size.width * 0.9, size.height * 0.85), width: size.width * 1.4, height: size.height * 1.4));
    canvas.drawRect(rect, paint5);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
