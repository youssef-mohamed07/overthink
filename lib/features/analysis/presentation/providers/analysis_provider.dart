import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'analysis_state.dart';

class AnalysisNotifier extends Notifier<AnalysisState> {
  @override
  AnalysisState build() {
    return AnalysisInitial();
  }

  Future<void> analyzeMessage(String message) async {
    state = AnalysisLoading();
    try {
      // Mocking an AI delay for MVP
      await Future.delayed(const Duration(seconds: 3));
      
      state = AnalysisLoaded({
        'Worst': 'They are definitely ghosting you. They found someone better.',
        'Funny': 'They dropped their phone in a puddle and pigeons stole it.',
        'Realistic': 'They are likely busy at work and will reply later.',
        'Calm': 'Take a deep breath. A delayed response is normal and not a reflection of your worth.'
      });
    } catch (e) {
      state = AnalysisError('Failed to analyze the message: \$e');
    }
  }
}

final analysisProvider = NotifierProvider<AnalysisNotifier, AnalysisState>(() {
  return AnalysisNotifier();
});
