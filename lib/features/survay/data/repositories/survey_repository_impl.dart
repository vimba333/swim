import 'package:swim/features/survay/data/datasources/survey_remote_datasource.dart';
import 'package:swim/features/survay/domain/repositories/survey_repository.dart';

class SurveyRepositoryImpl implements SurveyRepository {
  final SurveyRemoteDatasource datasource;

  SurveyRepositoryImpl(this.datasource);

  @override
  Future<void> submitPace(int paceSeconds) {
    return datasource.submitPace(paceSeconds);
  }
}