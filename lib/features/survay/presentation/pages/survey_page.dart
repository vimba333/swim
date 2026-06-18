import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:swim/features/survay/data/datasources/survey_remote_datasource.dart';
import 'package:swim/features/survay/data/repositories/survey_repository_impl.dart';
import 'package:swim/features/survay/domain/entities/swimmer_level.dart';
import 'package:swim/features/survay/domain/use_cases/submit_pace_usecase.dart';
import 'package:swim/features/survay/presentation/cubit/survey_cubit.dart';
import 'package:swim/features/survay/presentation/cubit/survey_state.dart';
import 'package:swim/features/survay/presentation/widgets/swimmer_level_editor.dart';

class SurveyPage extends StatelessWidget {
  const SurveyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SurveyCubit(
        SubmitPaceUsecase(
          SurveyRepositoryImpl(SurveyRemoteDatasourceImpl(http.Client())),
        ),
      ),
      child: const _SurveyView(),
    );
  }
}

class _SurveyView extends StatelessWidget {
  const _SurveyView();

  @override
  Widget build(BuildContext context) {
    return BlocListener<SurveyCubit, SurveyState>(
      listener: (context, state) {
        if (state is SurveySuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Pace submitted successfully')),
          );
        }
        if (state is SurveyError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      child: BlocBuilder<SurveyCubit, SurveyState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                onPressed: () => context.go('/'),
                icon: const Icon(Icons.arrow_back),
                tooltip: 'Back to the home page',
              ),
            ),
            body: GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: SwimmerLevelEditor(
                  initial: SwimmerLevel(seconds: 240),
                  onSubmit: (level) =>
                      context.read<SurveyCubit>().submit(level),
                  isLoading: state is SurveyLoading,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
