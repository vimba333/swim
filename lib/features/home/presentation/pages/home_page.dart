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
      backgroundColor: const Color(0xFF0A1628),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 32),
              // Приветствие
              Text(
                'Hi, ${user.name.split(' ').first}!',
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'What would you like to do today?',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white54,
                ),
              ),
              const Spacer(),
              // Картинка
              Center(
                child: Image.asset(
                  'assets/images/fun_swim.png',
                  width: 240,
                  height: 240,
                  fit: BoxFit.contain,
                ),
              ),
              const Spacer(),
              // Кнопки
              _NavButton(
                label: 'Start Survey',
                icon: Icons.speed_rounded,
                accent: const Color(0xFF00E096),
                onTap: () => context.go('/surveys'),
              ),
              const SizedBox(height: 12),
              _NavButton(
                label: 'View Users',
                icon: Icons.people_rounded,
                accent: const Color(0xFF4DA6FF),
                onTap: () => context.go('/users'),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color accent;
  final VoidCallback onTap;

  const _NavButton({
    required this.label,
    required this.icon,
    required this.accent,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: TextButton(
        onPressed: onTap,
        style: TextButton.styleFrom(
          backgroundColor: accent.withOpacity(0.12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: accent.withOpacity(0.4)),
          ),
        ),
        child: Row(
          children: [
            const SizedBox(width: 8),
            Icon(icon, color: accent, size: 20),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                color: accent,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            Icon(Icons.arrow_forward_ios_rounded, color: accent, size: 14),
            const SizedBox(width: 8),
          ],
        ),
      ),
    );
  }
}