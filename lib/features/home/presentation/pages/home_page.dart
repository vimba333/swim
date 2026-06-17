import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
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
