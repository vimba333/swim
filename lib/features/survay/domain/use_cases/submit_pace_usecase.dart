import 'package:swim/features/survay/domain/repositories/survey_repository.dart';

class SubmitPaceUsecase {
  final SurveyRepository repository;

  const SubmitPaceUsecase(this.repository);

  Future<void> call(int paceSeconds) {
    return repository.submitPace(paceSeconds);
  }
}