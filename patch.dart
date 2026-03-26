import 'dart:io';

void main() {
  final files = [
    'lib/features/home/presentation/screens/home_screen.dart',
    'lib/features/history/presentation/screens/history_screen.dart',
    'lib/features/profile/presentation/screens/profile_screen.dart',
    'lib/features/analysis/presentation/screens/analysis_screen.dart'
  ];

  for (var path in files) {
    var f = File(path);
    if (!f.existsSync()) continue;
    var content = f.readAsStringSync();
    
    // Fix Inner Scaffold backgrounds to be transparent so blur can see the scroll view
    content = content.replaceAll(
      "backgroundColor: AppColors.backgroundDark,", 
      "backgroundColor: Colors.transparent,"
    );

    // Give some bottom padding so users can scroll above the floating navbar
    if (path.contains('analysis_screen.dart')) continue; // specific cases later
    
    content = content.replaceAll(
      "padding: const EdgeInsets.symmetric(horizontal: 24.0),",
      "padding: const EdgeInsets.fromLTRB(24.0, 0, 24.0, 120.0),"
    );
    
    f.writeAsStringSync(content);
    print("Patched " + path);
  }
}
