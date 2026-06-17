
sealed class SurveyState {
  const SurveyState();
}

class SurveyInitial extends SurveyState {
  final double seconds;
  const SurveyInitial({this.seconds = 90});
}

class SurveyLoading extends SurveyState {
  final double seconds;
  const SurveyLoading(this.seconds);
}

class SurveySuccess extends SurveyState {
  const SurveySuccess();
}

class SurveyError extends SurveyState {
  final String message;
  final double seconds;
  final bool isNetwork;
  const SurveyError(this.message, this.seconds, {this.isNetwork = false});
}