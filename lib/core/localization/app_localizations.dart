import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;
  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const _localizedValues = <String, Map<String, String>>{
    'en': {
      'title': 'Overthink',
      'analyze_the': 'Analyze the',
      'unsaid': 'Unsaid.',
      'decode': 'Decode subtext, tone, and hidden\nmeanings in seconds.',
      'generate': 'GENERATE ANALYSIS',
      'home': 'HOME',
      'history': 'HISTORY',
      'profile': 'PROFILE',
      'settings': 'ACCOUNT SETTINGS',
      'theme': 'Theme',
      'language': 'Language',
      'language_val': 'English',
      'dark_mode': 'Dark Mode',
      'light_mode': 'Light Mode',
      'logout': 'LOG OUT FROM OVERTHINK',
      'membership': 'MEMBERSHIP STATUS',
      'pro': 'Overthink Pro',
      'worst': 'Worst',
      'funny': 'Funny',
      'realistic': 'Realistic',
      'calm': 'Calm',
      'roast_me': 'Roast Me',
      'perspective_mode': 'PERSPECTIVE MODE',
      'input_hint': 'She replied ok...',
      'recording': 'Recording',
      'audio_received': 'Audio received!',
      'ai_subtext_engine': 'AI Subtext\nEngine',
      'model_label': 'v4.2 Cognitive',
      'pulse_rate': 'Pulse Rate',
      'monitoring_intent': 'Monitoring intent...',
      'history_title': 'Cognitive Logs',
      'history_sub': 'Your spiral history, decoded.',
      'total_sessions': 'TOTAL SESSIONS',
      'fav_mode': 'FAV MODE',
      'streak': 'DAILY STREAK',
      'days': 'DAYS',
      'recent': 'Recent Sessions'
    },
    'ar': {
      'title': 'أوفر ثينك',
      'analyze_the': 'حلل',
      'unsaid': 'المخفي.',
      'decode': 'افهم النغمات الصوتية وما وراء\nالكلمات في ثوان.',
      'generate': 'إنشاء التحليل',
      'home': 'الرئيسية',
      'history': 'السجل',
      'profile': 'حسابي',
      'settings': 'إعدادات الحساب',
      'theme': 'المظهر',
      'language': 'اللغة',
      'language_val': 'العربية',
      'dark_mode': 'الوضع الداكن',
      'light_mode': 'الوضع المضيء',
      'logout': 'تسجيل الخروج',
      'membership': 'حالة العضوية',
      'pro': 'أوفر ثينك برو',
      'worst': 'الأسوأ',
      'funny': 'مضحك',
      'realistic': 'واقعي',
      'calm': 'هادئ',
      'roast_me': 'حمصني',
      'perspective_mode': 'وضع التحليل',
      'input_hint': 'قالت: أوكي...',
      'recording': 'جاري التسجيل',
      'audio_received': 'تم استلام التسجيل الصوتي!',
      'ai_subtext_engine': 'محرك\nتحليل المعنى',
      'model_label': 'الإصدار 4.2 المعرفي',
      'pulse_rate': 'معدل النبض',
      'monitoring_intent': 'جاري مراقبة النية...',
      'history_title': 'سجل الأفكار',
      'history_sub': 'تاريخ التفكير المفرط تم حله.',
      'total_sessions': 'إجمالي الجلسات',
      'fav_mode': 'الوضع المفضل',
      'streak': 'الاستمرارية',
      'days': 'أيام',
      'recent': 'الجلسات الأخيرة'
    }
  };

  String get(String key) {
    return _localizedValues[locale.languageCode]?[key] ?? _localizedValues['en']![key]!;
  }
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'ar'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}
