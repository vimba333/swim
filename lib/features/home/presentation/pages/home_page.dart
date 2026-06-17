import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:swim/core/presentation/cubit/current_user_cubit.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.read<CurrentUserCubit>().state.user;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            Text('Hi, ${user.name}!', style: const TextStyle(fontSize: 24)),
            Image.asset(
              'assets/images/fun_swim.png', // Путь к вашей PNG картинке
              width: 250,
              height: 250,
              fit: BoxFit.contain,
            ),

            ElevatedButton(
              onPressed: () => context.go('/surveys'),
              child: const Text('Survey'),
            ),
            const SizedBox(height: 16), // Отступ между кнопками
            ElevatedButton(
              onPressed: () => context.go('/users'),
              child: const Text('Users'),
            ),
          ],
        ),
      ),
    );
  }
}
