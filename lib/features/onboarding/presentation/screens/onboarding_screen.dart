import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/constants/storage_keys.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late final PageController _pageController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(AppStorageKeys.onboardingCompleted, true);
    final isAuthenticated =
        prefs.getBool(AppStorageKeys.isAuthenticated) ?? false;

    if (!mounted) {
      return;
    }

    context.go(isAuthenticated ? '/' : '/auth/request-otp');
  }

  void _goToNextPage(int totalPages) {
    if (_currentIndex >= totalPages - 1) {
      _completeOnboarding();
      return;
    }

    _pageController.nextPage(
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final pages = <_OnboardingPageData>[
      _OnboardingPageData(
        icon: Icons.visibility_rounded,
        title: loc.get('onboarding_title_1'),
        description: loc.get('onboarding_desc_1'),
        colors: const [Color(0xFF7B5CFF), Color(0xFF38B6FF)],
      ),
      _OnboardingPageData(
        icon: Icons.tune_rounded,
        title: loc.get('onboarding_title_2'),
        description: loc.get('onboarding_desc_2'),
        colors: const [Color(0xFF00B8A9), Color(0xFF4CD3A0)],
      ),
      _OnboardingPageData(
        icon: Icons.auto_graph_rounded,
        title: loc.get('onboarding_title_3'),
        description: loc.get('onboarding_desc_3'),
        colors: const [Color(0xFFFF7A59), Color(0xFFFFB347)],
      ),
    ];

    final bool isLastPage = _currentIndex == pages.length - 1;

    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? [
                    const Color(0xFF101017),
                    const Color(0xFF171726),
                    const Color(0xFF1F1F31),
                  ]
                : [
                    const Color(0xFFFDFBFF),
                    const Color(0xFFF3F8FF),
                    const Color(0xFFFFFFFF),
                  ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: _completeOnboarding,
                    child: Text(
                      loc.get('onboarding_skip'),
                      style: TextStyle(
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.72,
                        ),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: pages.length,
                    onPageChanged: (index) {
                      setState(() {
                        _currentIndex = index;
                      });
                    },
                    itemBuilder: (context, index) {
                      final page = pages[index];
                      return _OnboardingCard(page: page);
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    pages.length,
                    (index) => AnimatedContainer(
                      duration: const Duration(milliseconds: 220),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      height: 8,
                      width: _currentIndex == index ? 24 : 8,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: _currentIndex == index
                            ? AppColors.primary
                            : theme.colorScheme.onSurface.withValues(
                                alpha: 0.24,
                              ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => _goToNextPage(pages.length),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text(
                      isLastPage
                          ? loc.get('onboarding_get_started')
                          : loc.get('onboarding_next'),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _OnboardingCard extends StatelessWidget {
  final _OnboardingPageData page;

  const _OnboardingCard({required this.page});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 200,
          height: 200,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: page.colors,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: page.colors.first.withValues(alpha: 0.38),
                blurRadius: 28,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Icon(page.icon, size: 86, color: Colors.white),
        ),
        const SizedBox(height: 30),
        Text(
          page.title,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: theme.colorScheme.onSurface,
            fontSize: 30,
            fontWeight: FontWeight.w900,
            height: 1.15,
            letterSpacing: -0.4,
          ),
        ),
        const SizedBox(height: 14),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            page.description,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.67),
              fontSize: 15,
              height: 1.55,
            ),
          ),
        ),
      ],
    );
  }
}

class _OnboardingPageData {
  final IconData icon;
  final String title;
  final String description;
  final List<Color> colors;

  const _OnboardingPageData({
    required this.icon,
    required this.title,
    required this.description,
    required this.colors,
  });
}
