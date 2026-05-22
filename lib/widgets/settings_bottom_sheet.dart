import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/settings_service.dart';
import '../services/language_service.dart';

class SettingsBottomSheet extends StatefulWidget {
  final bool showImageOption;

  const SettingsBottomSheet({
    super.key,
    this.showImageOption = true,
  });

  static Future<void> show(BuildContext context, {bool showImageOption = true}) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.3),
      builder: (context) => SettingsBottomSheet(showImageOption: showImageOption),
    );
  }

  @override
  State<SettingsBottomSheet> createState() => _SettingsBottomSheetState();
}

class _SettingsBottomSheetState extends State<SettingsBottomSheet> {
  final SettingsService _settingsService = SettingsService();
  final LanguageService _langService = LanguageService();

  @override
  void initState() {
    super.initState();
    _settingsService.addListener(_updateState);
    _langService.addListener(_updateState);
  }

  @override
  void dispose() {
    _settingsService.removeListener(_updateState);
    _langService.removeListener(_updateState);
    super.dispose();
  }

  void _updateState() {
    if (mounted) setState(() {});
  }

  void _toggleCoptic(bool value) {
    if (!value && !_settingsService.showArabic && !_settingsService.showPronunciation) {
      _showWarning();
      return;
    }
    _settingsService.setShowCoptic(value);
  }

  void _toggleArabic(bool value) {
    if (!value && !_settingsService.showCoptic && !_settingsService.showPronunciation) {
      _showWarning();
      return;
    }
    _settingsService.setShowArabic(value);
  }

  void _togglePronunciation(bool value) {
    if (!value && !_settingsService.showCoptic && !_settingsService.showArabic) {
      _showWarning();
      return;
    }
    _settingsService.setShowPronunciation(value);
  }

  void _showWarning() {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: AlertDialog(
            backgroundColor: Colors.white.withValues(alpha: 0.95),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(28),
              side: const BorderSide(color: Color(0xFFF1F5F9), width: 1.5),
            ),
            icon: Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Color(0xFFFEF2F2),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.warning_amber_rounded,
                color: Colors.redAccent,
                size: 40,
              ),
            ),
            title: Text(
              _langService.translate('warning_title'),
              textAlign: TextAlign.center,
              style: GoogleFonts.cairo(
                fontWeight: FontWeight.w900,
                fontSize: 18,
                color: const Color(0xFF1C1917),
              ),
            ),
            content: Text(
              _langService.translate('visibility_error'),
              textAlign: TextAlign.center,
              style: GoogleFonts.cairo(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: const Color(0xFF475569),
                height: 1.5,
              ),
            ),
            actionsAlignment: MainAxisAlignment.center,
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 10),
                  backgroundColor: const Color(0xFFF1F5F9),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: Text(
                  _langService.translate('ok'),
                  style: GoogleFonts.cairo(
                    color: const Color(0xFF475569),
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isAr = _langService.isArabic;
    final speed = _settingsService.audioSpeed;

    final speeds = [0.25, 0.5, 0.75, 1.0, 1.25, 1.5, 1.75, 2.0];

    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.90),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(40),
            topRight: Radius.circular(40),
          ),
          border: Border.all(color: Colors.white.withValues(alpha: 0.6), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 30,
              offset: const Offset(0, -10),
            )
          ],
        ),
        padding: EdgeInsets.only(
          left: 24,
          right: 24,
          top: 16,
          bottom: MediaQuery.of(context).padding.bottom + 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Pull handle indicator
            Center(
              child: Container(
                width: 48,
                height: 5,
                decoration: BoxDecoration(
                  color: const Color(0xFFCBD5E1),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Dialog Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(width: 40), // spacer to center text
                Text(
                  _langService.translate('settings_title'),
                  style: GoogleFonts.cairo(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: const Color(0xFF1C1917),
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: Color(0xFFF1F5F9),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.close_rounded,
                      color: Color(0xFF64748B),
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 28),

            // Speed Control Section
            Text(
              _langService.translate('audio_speed'),
              textAlign: isAr ? TextAlign.right : TextAlign.left,
              style: GoogleFonts.cairo(
                fontSize: 15,
                fontWeight: FontWeight.w900,
                color: const Color(0xFF475569),
              ),
            ),
            const SizedBox(height: 12),

            // Speed selector segmented row(s)
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: speeds.sublist(0, 4).map((s) {
                    final isSelected = (speed - s).abs() < 0.05;
                    final label = s == 1.0 
                        ? '${s.toStringAsFixed(1)}x\n(${_langService.translate('speed_normal')})' 
                        : '${s.toStringAsFixed(2).replaceAll('.00', '')}x';

                    return Expanded(
                      child: GestureDetector(
                        onTap: () => _settingsService.setAudioSpeed(s),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                            color: isSelected ? theme.colorScheme.primary : Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isSelected ? theme.colorScheme.primary : const Color(0xFFE2E8F0),
                              width: isSelected ? 1.5 : 1.0,
                            ),
                            boxShadow: [
                              if (isSelected)
                                BoxShadow(
                                  color: theme.colorScheme.primary.withValues(alpha: 0.25),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                )
                            ],
                          ),
                          child: Center(
                            child: Text(
                              label,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.cairo(
                                fontSize: s == 1.0 ? 10 : 12,
                                fontWeight: FontWeight.w900,
                                color: isSelected ? Colors.white : const Color(0xFF475569),
                                height: 1.2,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: speeds.sublist(4).map((s) {
                    final isSelected = (speed - s).abs() < 0.05;
                    final label = s == 1.0 
                        ? '${s.toStringAsFixed(1)}x\n(${_langService.translate('speed_normal')})' 
                        : '${s.toStringAsFixed(2).replaceAll('.00', '')}x';

                    return Expanded(
                      child: GestureDetector(
                        onTap: () => _settingsService.setAudioSpeed(s),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                            color: isSelected ? theme.colorScheme.primary : Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isSelected ? theme.colorScheme.primary : const Color(0xFFE2E8F0),
                              width: isSelected ? 1.5 : 1.0,
                            ),
                            boxShadow: [
                              if (isSelected)
                                BoxShadow(
                                  color: theme.colorScheme.primary.withValues(alpha: 0.25),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                )
                            ],
                          ),
                          child: Center(
                            child: Text(
                              label,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.cairo(
                                fontSize: s == 1.0 ? 10 : 12,
                                fontWeight: FontWeight.w900,
                                color: isSelected ? Colors.white : const Color(0xFF475569),
                                height: 1.2,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Separator line
            Container(
              height: 1.5,
              color: const Color(0xFFF1F5F9),
            ),
            const SizedBox(height: 24),

            // Visibility Control Rows
            _buildToggleRow(
              icon: Icons.sort_by_alpha_rounded,
              title: _langService.translate('show_coptic'),
              value: _settingsService.showCoptic,
              onChanged: _toggleCoptic,
            ),
            const SizedBox(height: 16),

            _buildToggleRow(
              icon: Icons.translate_rounded,
              title: _langService.translate('show_meaning'),
              value: _settingsService.showArabic,
              onChanged: _toggleArabic,
            ),
            const SizedBox(height: 16),

            _buildToggleRow(
              icon: Icons.phonelink_ring_rounded,
              title: _langService.translate('show_pronunciation'),
              value: _settingsService.showPronunciation,
              onChanged: _togglePronunciation,
            ),

            if (widget.showImageOption) ...[
              const SizedBox(height: 16),
              _buildToggleRow(
                icon: Icons.image_outlined,
                title: _langService.translate('show_image'),
                value: _settingsService.showImage,
                onChanged: (val) => _settingsService.setShowImage(val),
              ),
            ],
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleRow({
    required IconData icon,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    final theme = Theme.of(context);
    final isAr = _langService.isArabic;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFF1F5F9)),
      ),
      child: Row(
        textDirection: isAr ? TextDirection.rtl : TextDirection.ltr,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: theme.colorScheme.primary,
              size: 20,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              title,
              textAlign: isAr ? TextAlign.right : TextAlign.left,
              style: GoogleFonts.cairo(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF334155),
              ),
            ),
          ),
          Switch.adaptive(
            value: value,
            onChanged: onChanged,
            activeTrackColor: theme.colorScheme.primary.withValues(alpha: 0.5),
            activeThumbColor: theme.colorScheme.primary,
          ),
        ],
      ),
    );
  }
}
