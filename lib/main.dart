import 'package:flutter/material.dart';
import 'package:swim/core/theme/app_colors.dart';
import 'app_router.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Swim test',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: const ColorScheme.dark().copyWith(
          surface: AppColors.background,
        ),
      ),
      routerConfig: appRouter,
    );
  }
}
