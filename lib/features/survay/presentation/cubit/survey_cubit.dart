import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swim/core/error/app_exception.dart';
import 'package:swim/features/survay/domain/entities/swimmer_level.dart';
import 'package:swim/features/survay/domain/use_cases/submit_pace_usecase.dart';
import 'package:swim/features/survay/presentation/cubit/survey_state.dart';

class SurveyCubit extends Cubit<SurveyState> {
  final SubmitPaceUsecase _submitPaceUsecase;

  SurveyCubit(this._submitPaceUsecase) : super(const SurveyInitial());

  void updateSeconds(double seconds) {
    emit(SurveyInitial(seconds: seconds));
  }

  Future<void> submit(SwimmerLevel level) async {
    final seconds = level.seconds ?? SwimmerLevel.minSeconds;
    try {
      emit(SurveyLoading(seconds));
      await _submitPaceUsecase(seconds.round());
      emit(const SurveySuccess());
    } on NetworkException catch (e) {
      emit(SurveyError(e.message, seconds, isNetwork: true));
    } on AppException catch (e) {
      emit(SurveyError(e.message, seconds));
    } catch (_) {
      emit(SurveyError('Something went wrong', seconds));
    }
  }
}
