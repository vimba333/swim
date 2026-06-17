import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swim/core/presentation/cubit/current_user_cubit.dart';
import 'package:swim/core/theme/app_colors.dart';
import 'app_router.dart';

/// dart run lean_builder build
/// dart run lean_builder watch

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CurrentUserCubit(),
      child: MaterialApp.router(
        title: 'Swim test',
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: AppColors.background,
          colorScheme: const ColorScheme.dark().copyWith(
            surface: AppColors.background,
          ),
        ),
        routerConfig: appRouter,
      ),
    );
  }
}
