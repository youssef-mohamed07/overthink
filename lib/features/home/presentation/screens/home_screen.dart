import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/components/custom_text_field.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _selectedPerspective = 2;
  final TextEditingController _textController = TextEditingController();
  bool _isRecording = false;

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final onSurface = theme.colorScheme.onSurface;
    final panelColor = theme.colorScheme.surface;
    final fieldColor = isDark ? AppColors.backgroundDark : const Color(0xFFF2F4F8);
    final gradientTop = isDark ? AppColors.backgroundDark : const Color(0xFFF8F9FC);
    final gradientBottom = isDark ? const Color(0xFF161616) : const Color(0xFFEFF2F8);

    final List<Map<String, dynamic>> perspectives = [
      {'label': loc.get('worst'), 'color': const Color(0xFFE91E63)},
      {'label': loc.get('funny'), 'color': const Color(0xFFFF9800)},
      {'label': loc.get('realistic'), 'color': const Color(0xFF00D9FF)},
      {'label': loc.get('calm'), 'color': const Color(0xFF4CAF50)},
      {'label': loc.get('roast_me'), 'color': const Color(0xFFFF5252)},
    ];

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        bottom: false,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [gradientTop, gradientBottom],
            ),
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 120),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 8),
                Text(
                  loc.get('analyze_the'),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 44,
                    fontWeight: FontWeight.w900,
                    color: onSurface,
                    height: 1.0,
                    letterSpacing: -1.0,
                  ),
                ),
                ShaderMask(
                  shaderCallback: (bounds) => const LinearGradient(
                    colors: [AppColors.primary, AppColors.secondary],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ).createShader(bounds),
                  child: Text(
                    loc.get('unsaid'),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 44,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      height: 1.0,
                      letterSpacing: -1.0,
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: Text(
                    loc.get('decode'),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      color: onSurface.withValues(alpha: 0.6),
                      height: 1.45,
                    ),
                  ),
                ),
                const SizedBox(height: 26),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: panelColor,
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: onSurface.withValues(alpha: 0.08)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: isDark ? 0.35 : 0.08),
                        blurRadius: 18,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _isRecording
                          ? _buildVoiceControls(context, loc, onSurface, fieldColor)
                          : _buildInputField(onSurface, fieldColor, loc),
                      const SizedBox(height: 24),
                      Text(
                        loc.get('perspective_mode'),
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 2.2,
                          color: onSurface.withValues(alpha: 0.45),
                        ),
                      ),
                      const SizedBox(height: 14),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: List.generate(
                          perspectives.length,
                          (index) => _PerspectiveChip(
                            label: perspectives[index]['label'] as String,
                            color: perspectives[index]['color'] as Color,
                            baseTextColor: onSurface,
                            baseBackgroundColor: panelColor,
                            isSelected: _selectedPerspective == index,
                            onTap: () => setState(() => _selectedPerspective = index),
                          ),
                        ),
                      ),
                      const SizedBox(height: 28),
                      _GenerateButton(
                        text: loc.get('generate'),
                        onPressed: () {
                          if (_textController.text.trim().isEmpty) {
                            _textController.text = loc.get('input_hint');
                          }
                          context.push('/analysis');
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(child: _buildEngineCard(loc, onSurface, panelColor)),
                    const SizedBox(width: 12),
                    Expanded(child: _buildPulseCard(loc, onSurface, panelColor)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(Color onSurface, Color fieldColor, AppLocalizations loc) {
    return Container(
      decoration: BoxDecoration(
        color: fieldColor,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: onSurface.withValues(alpha: 0.08)),
      ),
      child: CustomTextField(
        controller: _textController,
        hintText: loc.get('input_hint'),
        maxLines: 5,
        suffixIcon: IconButton(
          icon: const Icon(Icons.mic_none_rounded),
          color: AppColors.secondary,
          iconSize: 27,
          onPressed: () => setState(() => _isRecording = true),
        ),
      ),
    );
  }

  Widget _buildVoiceControls(BuildContext context, AppLocalizations loc, Color onSurface, Color fieldColor) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 22),
      decoration: BoxDecoration(
        color: fieldColor,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.tertiary.withValues(alpha: 0.6)),
      ),
      child: Column(
        children: [
          Text(
            '${loc.get('recording')} 00:15',
            style: TextStyle(
              color: onSurface,
              fontSize: 24,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 18),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                onPressed: () => setState(() => _isRecording = false),
                icon: const Icon(Icons.delete_outline_rounded),
                color: onSurface.withValues(alpha: 0.7),
                iconSize: 30,
              ),
              Container(
                padding: const EdgeInsets.all(13),
                decoration: BoxDecoration(
                  color: AppColors.tertiary.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.tertiary, width: 1.5),
                ),
                child: const Icon(Icons.mic_rounded, color: AppColors.tertiary, size: 28),
              ),
              IconButton(
                onPressed: () {
                  setState(() => _isRecording = false);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(loc.get('audio_received'))),
                  );
                },
                icon: const Icon(Icons.check_circle_outline_rounded),
                color: AppColors.secondary,
                iconSize: 30,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEngineCard(AppLocalizations loc, Color onSurface, Color panelColor) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: panelColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: onSurface.withValues(alpha: 0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.psychology_outlined, color: AppColors.primary, size: 20),
          ),
          const SizedBox(height: 12),
          Text(
            loc.get('ai_subtext_engine'),
            style: TextStyle(
              color: onSurface,
              fontSize: 16,
              fontWeight: FontWeight.w800,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            loc.get('model_label'),
            style: TextStyle(
              color: onSurface.withValues(alpha: 0.6),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPulseCard(AppLocalizations loc, Color onSurface, Color panelColor) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: panelColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: onSurface.withValues(alpha: 0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: const [
              _Bar(height: 14, color: AppColors.secondary),
              SizedBox(width: 4),
              _Bar(height: 26, color: AppColors.primary),
              SizedBox(width: 4),
              _Bar(height: 20, color: AppColors.secondary),
              SizedBox(width: 4),
              _Bar(height: 30, color: AppColors.primary),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            loc.get('pulse_rate'),
            style: TextStyle(
              color: onSurface,
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            loc.get('monitoring_intent'),
            style: TextStyle(
              color: onSurface.withValues(alpha: 0.6),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class _PerspectiveChip extends StatelessWidget {
  final String label;
  final Color color;
  final Color baseTextColor;
  final Color baseBackgroundColor;
  final bool isSelected;
  final VoidCallback onTap;

  const _PerspectiveChip({
    required this.label,
    required this.color,
    required this.baseTextColor,
    required this.baseBackgroundColor,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? color.withValues(alpha: 0.17) : baseBackgroundColor,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected ? color : Colors.white.withValues(alpha: 0.1),
            width: isSelected ? 1.4 : 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? color : baseTextColor.withValues(alpha: 0.72),
            fontSize: 13,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.8,
          ),
        ),
      ),
    );
  }
}

class _GenerateButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const _GenerateButton({required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.secondary],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.22),
            blurRadius: 18,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          foregroundColor: const Color(0xFF090B10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.8,
              ),
            ),
            SizedBox(width: 6),
            Icon(Icons.bolt_rounded, size: 18),
          ],
        ),
      ),
    );
  }
}

class _Bar extends StatelessWidget {
  final double height;
  final Color color;

  const _Bar({required this.height, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 6,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }
}
