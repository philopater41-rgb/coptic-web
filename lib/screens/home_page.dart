import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../services/stage_service.dart';
import '../utils/donation_utils.dart';
import '../widgets/settings_bottom_sheet.dart';

class HomePage extends StatefulWidget {
  final Function(int) onNavigateTo;

  const HomePage({super.key, required this.onNavigateTo});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final StageService _stageService = StageService();

  // Curated vivid Tailwind 50 -> 500 palette to eliminate any color repeating
  final Map<String, Map<String, Color>> _stageColors = {
    'nursery': {'bg': const Color(0xFFFEF2F2), 'border': const Color(0xFFEF4444)},
    'primary12': {'bg': const Color(0xFFFFFBEB), 'border': const Color(0xFFF59E0B)},
    'primary34': {'bg': const Color(0xFFECFDF5), 'border': const Color(0xFF10B981)},
    'primary56': {'bg': const Color(0xFFECFEFF), 'border': const Color(0xFF06B6D4)},
    'prep': {'bg': const Color(0xFFFDF2F8), 'border': const Color(0xFFEC4899)},
    'sec': {'bg': const Color(0xFFEEF2FF), 'border': const Color(0xFF6366F1)},
    'qana': {'bg': const Color(0xFFF0FDFA), 'border': const Color(0xFF14B8A6)},
    'uni': {'bg': const Color(0xFFF5F3FF), 'border': const Color(0xFF8B5CF6)},
    'graduates': {'bg': const Color(0xFFEFF6FF), 'border': const Color(0xFF3B82F6)},
    'servants': {'bg': const Color(0xFFFAF5FF), 'border': const Color(0xFFA855F7)},
    'servants_trainees': {'bg': const Color(0xFFF7FEE7), 'border': const Color(0xFF84CC16)},
    'special_needs_simple': {'bg': const Color(0xFFECFDF5), 'border': const Color(0xFF10B981)},
    'special_needs_average': {'bg': const Color(0xFFFFF7ED), 'border': const Color(0xFFF97316)},
    'special_needs_advanced': {'bg': const Color(0xFFFDF2F8), 'border': const Color(0xFFEC4899)},
  };

  @override
  void initState() {
    super.initState();
    _stageService.addListener(_updateState);
  }

  @override
  void dispose() {
    _stageService.removeListener(_updateState);
    super.dispose();
  }

  void _updateState() {
    if (mounted) setState(() {});
  }

  Future<void> _launchWhatsApp(String phone) async {
    final url = Uri.parse("https://wa.me/2$phone");
    try {
      bool launched = await launchUrl(url, mode: LaunchMode.externalApplication);
      if (!launched) {
        final fallbackUrl = Uri.parse("whatsapp://send?phone=2$phone");
        await launchUrl(fallbackUrl, mode: LaunchMode.externalApplication);
      }
    } catch (_) {
      try {
        final fallbackUrl = Uri.parse("whatsapp://send?phone=2$phone");
        await launchUrl(fallbackUrl, mode: LaunchMode.externalApplication);
      } catch (__) {
        // Fallback or debug print if needed
      }
    }
  }

  Future<void> _launchEmail(String email) async {
    final Uri params = Uri(
      scheme: 'mailto',
      path: email,
    );
    try {
      await launchUrl(params, mode: LaunchMode.externalApplication);
    } catch (_) {
      try {
        await launchUrl(params);
      } catch (__) {
        // Fallback
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 24, bottom: 120),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(), // Spacer
              Row(
                children: [
                  GestureDetector(
                    onTap: () => _showContactDialog(context),
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.72),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.white.withValues(alpha: 0.55)),
                      ),
                      child: const Icon(Icons.phone_rounded, color: Color(0xFF64748B), size: 22),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () => DonationUtils.showDonationDialog(context),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFB45309).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFB45309).withValues(alpha: 0.2)),
                      ),
                      child: const Icon(Icons.volunteer_activism_rounded, color: Color(0xFFB45309), size: 22),
                    ),
                  ),
                  const SizedBox(width: 12),
                  GestureDetector(
                    onTap: () => showSettingsBottomSheet(context),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.white.withValues(alpha: 0.55)),
                      ),
                      child: const Icon(Icons.settings_rounded, color: Color(0xFF64748B), size: 22),
                    ),
                  ),
                ],
              )
            ],
          ),
          const SizedBox(height: 24),

          // Logo without white background or shadows
          Center(
            child: Column(
              children: [
                SizedBox(
                  height: 140,
                  width: 210,
                  child: Image.asset(
                    'assets/images/logo.webp',
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.auto_awesome_rounded, size: 72, color: Color(0xFFB45309));
                    },
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'منهج القبطي - مهرجان الكرازة المرقسية',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.cairo(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: const Color(0xFF1c1917),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFB45309).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFFB45309).withValues(alpha: 0.2)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.auto_awesome_rounded, size: 14, color: Color(0xFFB45309)),
                      const SizedBox(width: 6),
                      Text(
                        'سنة ٢٠٢٦',
                        style: GoogleFonts.cairo(
                          fontSize: 11,
                          fontWeight: FontWeight.w900,
                          color: const Color(0xFFB45309),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),



          // Premium Grid with slim aspect ratio for mobile compactness
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 2.3,
            ),
            itemCount: _stageService.stages.length,
            itemBuilder: (context, index) {
              final stage = _stageService.stages[index];
              final isSelected = _stageService.selectedStage.id == stage.id;
              final colMap = _stageColors[stage.id] ?? {'bg': Colors.white, 'border': const Color(0xFFB45309)};

              return GestureDetector(
                onTap: () {
                  _stageService.setSelectedStage(stage);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: isSelected 
                        ? (colMap['border'] ?? const Color(0xFFB45309))
                        : (colMap['bg'] ?? Colors.white).withValues(alpha: 0.85),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: isSelected ? Colors.white.withValues(alpha: 0.5) : (colMap['border'] ?? const Color(0xFFB45309)).withValues(alpha: 0.3),
                      width: isSelected ? 2.5 : 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: isSelected 
                          ? (colMap['border'] ?? const Color(0xFFB45309)).withValues(alpha: 0.4)
                          : Colors.black.withValues(alpha: 0.02),
                        blurRadius: 6,
                        offset: const Offset(0, 4),
                      )
                    ],
                  ),
                  child: Stack(
                    children: [
                      if (isSelected)
                        const Positioned(
                          top: 0,
                          left: 0,
                          child: Icon(Icons.check_circle_rounded, color: Colors.white, size: 16),
                        ),
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          stage.name,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.cairo(
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                            color: isSelected ? Colors.white : const Color(0xFF1C1917),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 32),

          DonationUtils.buildDonationBanner(context),
          
          const SizedBox(height: 24),
        ],
      ),
    );
  }


  void _showContactDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
          child: AlertDialog(
            backgroundColor: Colors.white.withValues(alpha: 0.92),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(32),
              side: const BorderSide(color: Colors.white, width: 1.5),
            ),
            title: Text(
              'للتواصل معنا',
              textAlign: TextAlign.center,
              style: GoogleFonts.cairo(
                fontWeight: FontWeight.w900,
                fontSize: 20,
                color: const Color(0xFF1C1917),
              ),
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildModernContactCard(
                    name: 'م. مينا چوزيف',
                    phone: '01098734124',
                  ),
                  const SizedBox(height: 12),
                  _buildModernContactCard(
                    name: 'م. فيلوباتير چوزيف',
                    phone: '01210826678',
                  ),
                  const SizedBox(height: 12),
                  _buildModernEmailCard(
                    email: 'philopater41@gmail.com',
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  'إغلاق',
                  style: GoogleFonts.cairo(
                    color: const Color(0xFFB45309),
                    fontWeight: FontWeight.w900,
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  Widget _buildModernContactCard({
    required String name,
    required String phone,
  }) {
    return InkWell(
      onTap: () => _launchWhatsApp(phone),
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.65),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withValues(alpha: 0.6)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF25D366).withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: const FaIcon(
                FontAwesomeIcons.whatsapp,
                color: Color(0xFF25D366),
                size: 20,
              ),
            ),
            Expanded(
              child: Text(
                name,
                textAlign: TextAlign.right,
                style: GoogleFonts.cairo(
                  fontWeight: FontWeight.w900,
                  fontSize: 14,
                  color: const Color(0xFF1C1917),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModernEmailCard({
    required String email,
  }) {
    return InkWell(
      onTap: () => _launchEmail(email),
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.65),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withValues(alpha: 0.6)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFB45309).withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.mail_rounded,
                color: Color(0xFFB45309),
                size: 20,
              ),
            ),
            Expanded(
              child: Text(
                email,
                textAlign: TextAlign.right,
                style: GoogleFonts.cairo(
                  fontWeight: FontWeight.w800,
                  fontSize: 13,
                  color: const Color(0xFF475569),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

