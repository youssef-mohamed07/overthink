import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/analysis_provider.dart';
import '../providers/analysis_state.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../../../../core/localization/app_localizations.dart';

class AnalysisScreen extends ConsumerStatefulWidget {
  const AnalysisScreen({super.key});

  @override
  ConsumerState<AnalysisScreen> createState() => _AnalysisScreenState();
}

class _AnalysisScreenState extends ConsumerState<AnalysisScreen> 
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  
  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1500))..repeat(reverse: true);
        
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(analysisProvider.notifier).analyzeMessage('');
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(analysisProvider);
    final theme = Theme.of(context);
    final loc = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: theme.colorScheme.onSurface),
          onPressed: () {
            context.pop();
          },
        ),
        title: Text(
          "ANALYSIS",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w800,
            letterSpacing: 2,
            color: theme.colorScheme.onSurface,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          child: _buildBody(state, theme, loc),
        ),
      ),
    );
  }

  Widget _buildBody(AnalysisState state, ThemeData theme, AppLocalizations loc) {
    if (state is AnalysisLoading) {
      return _buildLoadingState(theme);
    } else if (state is AnalysisLoaded) {
      return _buildLoadedState(state, theme, loc);
    }
    return const SizedBox.shrink();
  }

  Widget _buildLoadingState(ThemeData theme) {
    return Center(
      key: const ValueKey('loading'),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedBuilder(
            animation: _pulseController,
            builder: (context, child) {
              return Transform.scale(
                scale: 1.0 + (_pulseController.value * 0.1),
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primary.withValues(alpha: 0.2),
                    border: Border.all(color: AppColors.primary, width: 2),
                  ),
                  child: const Center(
                    child: Icon(Icons.psychology_outlined, color: AppColors.primary, size: 50),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 40),
          Text(
            "Decoding subtext...",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            "Analyzing tone and context",
            style: TextStyle(
              fontSize: 14,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadedState(AnalysisLoaded state, ThemeData theme, AppLocalizations loc) {
    return SingleChildScrollView(
      key: const ValueKey('loaded'),
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Your Thoughts.",
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w900,
              height: 1.1,
              letterSpacing: -0.5,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "The unsaid translated.",
            style: TextStyle(
              fontSize: 14,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          ),
          const SizedBox(height: 32),
          ...state.interpretations.entries.map((e) {
            final isWorst = e.key.toLowerCase().contains('worst');
            final isRoast = e.key.toLowerCase().contains('roast');
            return Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: _buildInsightCard(
                title: e.key.toUpperCase(),
                content: e.value,
                icon: (isWorst || isRoast) ? Icons.local_fire_department_rounded : Icons.psychology_rounded,
                color: (isWorst || isRoast) ? AppColors.tertiary : AppColors.primary,
                theme: theme,
                isHighlight: isWorst || isRoast,
              ),
            );
          }),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: PrimaryButton(
                  text: "SAVE TO LOGS",
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                       SnackBar(content: Text('Saved to history', style: TextStyle(color: theme.colorScheme.onSurface))),
                    );
                    context.pop();
                  },
                ),
              ),
              const SizedBox(width: 16),
              Container(
                decoration: BoxDecoration(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: IconButton(
                  icon: Icon(Icons.share_rounded, color: theme.colorScheme.onSurface),
                  onPressed: () {
                    context.push('/share');
                  },
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _buildInsightCard({
    required String title,
    required String content,
    required IconData icon,
    required Color color,
    required ThemeData theme,
    bool isHighlight = false,
  }) {
    final bool isDark = theme.brightness == Brightness.dark;
    
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isHighlight
            ? color.withValues(alpha: isDark ? 0.15 : 0.05)
            : theme.colorScheme.onSurface.withValues(alpha: 0.03),
        gradient: isHighlight
            ? LinearGradient(
                colors: [
                  color.withValues(alpha: isDark ? 0.2 : 0.1),
                  Colors.transparent,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : null,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: color.withValues(alpha: isHighlight ? 0.5 : 0.2),
          width: isHighlight ? 1.5 : 1,
        ),
        boxShadow: isHighlight && isDark
            ? [
                BoxShadow(
                  color: color.withValues(alpha: 0.1),
                  blurRadius: 20,
                  spreadRadius: -5,
                )
              ]
            : [],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 12),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            content,
            style: TextStyle(
              fontSize: 16,
              height: 1.6,
              
              
              color: theme.colorScheme.onSurface.withValues(alpha: 0.9),
            ),
          ),
        ],
      ),
    );
  }
}
