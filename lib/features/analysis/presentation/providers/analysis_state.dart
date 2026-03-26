abstract class AnalysisState {}

class AnalysisInitial extends AnalysisState {}

class AnalysisLoading extends AnalysisState {}

class AnalysisLoaded extends AnalysisState {
  final Map<String, String> interpretations;
  AnalysisLoaded(this.interpretations);
}

class AnalysisError extends AnalysisState {
  final String message;
  AnalysisError(this.message);
}
