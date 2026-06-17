abstract interface class SurveyRepository {
  Future<void> submitPace(int paceSeconds);
}