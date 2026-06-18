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
          SurveyRepositoryImpl(
            SurveyRemoteDatasourceImpl(http.Client()),
          ),
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
            const SnackBar(content: Text('Готово!')),
          );
        }
        if (state is SurveyError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      child: BlocBuilder<SurveyCubit, SurveyState>(
        builder: (context, state) {
          final seconds = switch (state) {
            SurveyInitial(:final seconds) => seconds,
            SurveyLoading(:final seconds) => seconds,
            SurveyError(:final seconds) => seconds,
            _ => 90.0,
          };

          return Scaffold(
            backgroundColor: const Color(0xFF0A1628),
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                onPressed: () => context.go('/'),
                icon: const Icon(Icons.chevron_left, color: Colors.white),
              ),
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    // Прогресс бар
                    _ProgressBar(current: 3, total: 5),
                    const SizedBox(height: 32),
                    // Заголовок
                    const Text(
                      "What's your fastest\n100m freestyle?",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'This helps us build a more accurate plan\nfor you.',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white54,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 40),
                    // Редактор
                    SwimmerLevelEditor(
                      initial: SwimmerLevel(seconds: seconds),
                      onSubmit: (level) =>
                          context.read<SurveyCubit>().submit(level),
                      isLoading: state is SurveyLoading,
                    ),
                    const SizedBox(height: 16),
                    // Skip
                    Center(
                      child: TextButton(
                        onPressed: () => context.go('/'),
                        child: const Text(
                          "I don't know my pace, skip this",
                          style: TextStyle(
                            color: Colors.white38,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ProgressBar extends StatelessWidget {
  final int current;
  final int total;

  const _ProgressBar({required this.current, required this.total});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(total, (i) {
        final active = i < current;
        return Expanded(
          child: Container(
            margin: const EdgeInsets.only(right: 4),
            height: 3,
            decoration: BoxDecoration(
              color: active ? const Color(0xFF00E096) : Colors.white12,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        );
      }),
    );
  }
}