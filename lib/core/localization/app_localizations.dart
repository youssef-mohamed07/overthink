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
      'recent': 'Recent Sessions',
      'splash_tagline': 'Decode before you overthink.',
      'onboarding_skip': 'Skip',
      'onboarding_next': 'Next',
      'onboarding_get_started': 'Get Started',
      'onboarding_title_1': 'Read What Is Not Said',
      'onboarding_desc_1':
          'Turn short replies and mixed signals into clear emotional context in seconds.',
      'onboarding_title_2': 'Choose Your Lens',
      'onboarding_desc_2':
          'Switch between realistic, calm, funny, and roast modes to view any message your way.',
      'onboarding_title_3': 'Track Your Patterns',
      'onboarding_desc_3':
          'Save sessions and spot repeated overthinking loops so your next response is smarter.',
      'auth_request_otp_title': 'Request OTP',
      'auth_request_otp_subtitle':
          'Enter your email or phone to receive a one-time code.',
      'auth_identifier_label': 'Email or phone',
      'auth_identifier_hint': 'name@example.com',
      'auth_send_otp': 'Send OTP',
      'auth_forgot_password': 'Forgot Password?',
      'auth_demo_note': 'Demo: use any email/phone and any 6-digit OTP.',
      'auth_verify_otp_title': 'Verify OTP',
      'auth_verify_otp_subtitle': 'We sent a code to',
      'auth_otp_label': 'One-Time Password',
      'auth_otp_hint': '123456',
      'auth_verify_otp_button': 'Verify OTP',
      'auth_resend_otp': 'Resend OTP',
      'auth_identifier_missing':
          'Missing identifier, please request OTP again.',
      'auth_otp_sent_again': 'A new OTP has been sent.',
      'auth_set_password_title': 'Set Password',
      'auth_set_password_subtitle':
          'Create a secure password for your account.',
      'auth_password_label': 'Password',
      'auth_password_hint': 'At least 8 characters',
      'auth_confirm_password_label': 'Confirm password',
      'auth_confirm_password_hint': 'Re-enter your password',
      'auth_set_password_button': 'Continue',
      'auth_setup_profile_title': 'Setup Profile',
      'auth_setup_profile_subtitle': 'Tell us a little about you.',
      'auth_full_name_label': 'Full name',
      'auth_full_name_hint': 'John Doe',
      'auth_username_label': 'Username',
      'auth_username_hint': 'john_doe',
      'auth_setup_profile_button': 'Finish Setup',
      'auth_forgot_password_title': 'Forgot Password',
      'auth_forgot_password_subtitle':
          'Enter your email or phone to receive reset OTP.',
      'auth_send_reset_otp_button': 'Send Reset OTP',
      'auth_reset_password_title': 'Reset Password',
      'auth_reset_password_subtitle': 'Enter OTP and create a new password.',
      'auth_reset_password_button': 'Reset Password',
      'auth_password_reset_success': 'Password updated. Please sign in.',
      'auth_generic_error': 'Something went wrong. Please try again.',
      'auth_biometric_title': 'Biometric Login',
      'auth_biometric_subtitle':
          'Use your fingerprint or face to unlock your account.',
      'auth_biometric_helper':
          'Confirm your identity with Face ID or fingerprint sensor.',
      'auth_biometric_reason':
          'Authenticate using your face or fingerprint to continue.',
      'auth_biometric_login_button': 'Login with Biometrics',
      'auth_use_otp_instead': 'Use OTP Instead',
      'auth_biometric_setting': 'Biometric Login',
      'auth_biometric_enabled': 'Fingerprint / Face enabled',
      'auth_biometric_disabled': 'Fingerprint / Face disabled',
      'auth_biometric_unavailable': 'Not available on this device',
      'auth_biometric_enable_success': 'Biometric login enabled.',
      'auth_biometric_disable_success': 'Biometric login disabled.',
      'auth_biometric_enable_reason':
          'Confirm biometric verification to enable quick login.',
      'auth_skip_to_home': 'Skip to Home',
      'auth_error_identifier_required': 'Please enter email or phone number.',
      'auth_error_otp_invalid': 'OTP must be 6 digits.',
      'auth_error_password_too_short':
          'Password must be at least 8 characters.',
      'auth_error_password_mismatch': 'Passwords do not match.',
      'auth_error_full_name_invalid': 'Please enter a valid full name.',
      'auth_error_username_invalid': 'Username must be at least 3 characters.',
      'auth_error_biometric_unavailable':
          'Biometric authentication is not available on this device.',
      'auth_error_biometric_canceled': 'Biometric authentication was canceled.',
      'auth_error_biometric_failed':
          'Biometric authentication failed. Please try again.',
      'auth_error_biometric_not_enrolled':
          'No biometrics enrolled. Please add face or fingerprint in device settings.',
      'auth_error_biometric_passcode_not_set':
          'Set a screen lock on your device before using biometrics.',
      'auth_error_biometric_locked':
          'Too many attempts. Please unlock your device and try again.',
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
      'recent': 'الجلسات الأخيرة',
      'splash_tagline': 'افهم قبل ما تفرط في التفكير.',
      'onboarding_skip': 'تخطي',
      'onboarding_next': 'التالي',
      'onboarding_get_started': 'ابدأ الآن',
      'onboarding_title_1': 'افهم ما بين السطور',
      'onboarding_desc_1':
          'حوّل الردود القصيرة والإشارات المربكة إلى معنى عاطفي واضح خلال ثوان.',
      'onboarding_title_2': 'اختَر زاوية التحليل',
      'onboarding_desc_2':
          'بدّل بين الواقعي والهادئ والمضحك والتحميص لتشوف نفس الرسالة بأكثر من منظور.',
      'onboarding_title_3': 'تتبّع نمط تفكيرك',
      'onboarding_desc_3':
          'احفظ الجلسات واكتشف حلقات التفكير المفرط المتكررة حتى يكون ردك القادم أذكى.',
      'auth_request_otp_title': 'طلب رمز التحقق',
      'auth_request_otp_subtitle':
          'ادخل البريد الإلكتروني أو رقم الهاتف لاستلام رمز مؤقت.',
      'auth_identifier_label': 'البريد أو الهاتف',
      'auth_identifier_hint': 'name@example.com',
      'auth_send_otp': 'إرسال الرمز',
      'auth_forgot_password': 'نسيت كلمة المرور؟',
      'auth_demo_note':
          'نسخة تجريبية: استخدم أي بريد/هاتف وأي رمز مكون من 6 أرقام.',
      'auth_verify_otp_title': 'تأكيد الرمز',
      'auth_verify_otp_subtitle': 'تم إرسال الرمز إلى',
      'auth_otp_label': 'رمز التحقق',
      'auth_otp_hint': '123456',
      'auth_verify_otp_button': 'تأكيد الرمز',
      'auth_resend_otp': 'إعادة إرسال الرمز',
      'auth_identifier_missing': 'البيانات غير موجودة، اطلب الرمز مرة أخرى.',
      'auth_otp_sent_again': 'تم إرسال رمز جديد.',
      'auth_set_password_title': 'تعيين كلمة المرور',
      'auth_set_password_subtitle': 'أنشئ كلمة مرور قوية لحسابك.',
      'auth_password_label': 'كلمة المرور',
      'auth_password_hint': '8 أحرف على الأقل',
      'auth_confirm_password_label': 'تأكيد كلمة المرور',
      'auth_confirm_password_hint': 'أعد إدخال كلمة المرور',
      'auth_set_password_button': 'متابعة',
      'auth_setup_profile_title': 'إعداد الملف الشخصي',
      'auth_setup_profile_subtitle': 'أخبرنا قليلًا عنك.',
      'auth_full_name_label': 'الاسم الكامل',
      'auth_full_name_hint': 'محمد أحمد',
      'auth_username_label': 'اسم المستخدم',
      'auth_username_hint': 'mohamed_ahmed',
      'auth_setup_profile_button': 'إنهاء الإعداد',
      'auth_forgot_password_title': 'استعادة كلمة المرور',
      'auth_forgot_password_subtitle':
          'ادخل البريد أو الهاتف لاستلام رمز إعادة التعيين.',
      'auth_send_reset_otp_button': 'إرسال رمز الاستعادة',
      'auth_reset_password_title': 'إعادة تعيين كلمة المرور',
      'auth_reset_password_subtitle':
          'ادخل رمز التحقق ثم أنشئ كلمة مرور جديدة.',
      'auth_reset_password_button': 'تحديث كلمة المرور',
      'auth_password_reset_success': 'تم تحديث كلمة المرور. سجّل الدخول الآن.',
      'auth_generic_error': 'حدث خطأ ما. حاول مرة أخرى.',
      'auth_biometric_title': 'تسجيل دخول بيومتري',
      'auth_biometric_subtitle': 'استخدم البصمة أو الوجه لفتح حسابك.',
      'auth_biometric_helper':
          'أكد هويتك عبر بصمة الإصبع أو التعرّف على الوجه.',
      'auth_biometric_reason': 'أكّد هويتك بالبصمة أو الوجه للمتابعة.',
      'auth_biometric_login_button': 'تسجيل الدخول بالبصمة/الوجه',
      'auth_use_otp_instead': 'استخدم رمز OTP بدلًا من ذلك',
      'auth_biometric_setting': 'تسجيل الدخول البيومتري',
      'auth_biometric_enabled': 'البصمة / الوجه مفعّل',
      'auth_biometric_disabled': 'البصمة / الوجه غير مفعّل',
      'auth_biometric_unavailable': 'غير متاح على هذا الجهاز',
      'auth_biometric_enable_success': 'تم تفعيل تسجيل الدخول البيومتري.',
      'auth_biometric_disable_success': 'تم إيقاف تسجيل الدخول البيومتري.',
      'auth_biometric_enable_reason':
          'أكد هويتك بالبصمة أو الوجه لتفعيل تسجيل الدخول السريع.',
      'auth_skip_to_home': 'تخطي إلى الرئيسية',
      'auth_error_identifier_required':
          'يرجى إدخال البريد الإلكتروني أو رقم الهاتف.',
      'auth_error_otp_invalid': 'رمز OTP يجب أن يكون 6 أرقام.',
      'auth_error_password_too_short':
          'كلمة المرور يجب أن تكون 8 أحرف على الأقل.',
      'auth_error_password_mismatch': 'كلمتا المرور غير متطابقتين.',
      'auth_error_full_name_invalid': 'يرجى إدخال اسم كامل صحيح.',
      'auth_error_username_invalid':
          'اسم المستخدم يجب أن يكون 3 أحرف على الأقل.',
      'auth_error_biometric_unavailable':
          'المصادقة البيومترية غير متاحة على هذا الجهاز.',
      'auth_error_biometric_canceled': 'تم إلغاء المصادقة البيومترية.',
      'auth_error_biometric_failed': 'فشلت المصادقة البيومترية. حاول مرة أخرى.',
      'auth_error_biometric_not_enrolled':
          'لا توجد بصمة أو وجه مسجل. أضفها من إعدادات الجهاز.',
      'auth_error_biometric_passcode_not_set':
          'فعّل قفل الشاشة على الجهاز قبل استخدام البصمة أو الوجه.',
      'auth_error_biometric_locked':
          'محاولات كثيرة. افتح الجهاز ثم حاول مرة أخرى.',
    },
  };

  String get(String key) {
    return _localizedValues[locale.languageCode]?[key] ??
        _localizedValues['en']![key]!;
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
