import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:swim/core/presentation/widgets/life_ring.dart';
import 'package:swim/core/presentation/widgets/wave_divider.dart';
import 'package:swim/features/users/data/datasources/users_remote_datasource.dart';
import 'package:swim/features/users/data/repositories/users_repository_impl.dart';
import 'package:swim/features/users/domain/entities/user.dart';
import 'package:swim/features/users/domain/use_cases/get_user_usecase.dart';
import 'package:swim/features/users/presentation/cubit/user_detail_cubit.dart';
import 'package:swim/features/users/presentation/cubit/user_detail_state.dart';

class UserDetailPage extends StatelessWidget {
  final int userId;

  const UserDetailPage({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => UserDetailCubit(
        GetUserUsecase(
          UsersRepositoryImpl(UsersRemoteDatasourceImpl(http.Client())),
        ),
      )..getUser(userId),
      child: Scaffold(
        backgroundColor: const Color(0xFF0A1628),
        appBar: AppBar(
          backgroundColor: const Color(0xFF0A1628),
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.white),
          title: const Text(
            'User Detail',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
          ),
        ),
        body: BlocBuilder<UserDetailCubit, UserDetailState>(
          builder: (context, state) {
            return switch (state) {
              UserDetailInitial() => const SizedBox.shrink(),
              UserDetailLoading() => const Center(
                child: CircularProgressIndicator(color: Color(0xFF00E096)),
              ),
              UserDetailLoaded(:final user) => _UserDetailView(user: user),
              UserDetailError(:final message) => Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: Colors.white38,
                      size: 48,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      message,
                      style: const TextStyle(color: Colors.white38),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            };
          },
        ),
      ),
    );
  }
}

class _UserDetailView extends StatelessWidget {
  final User user;

  const _UserDetailView({required this.user});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Аватар + имя
          Center(
            child: Column(
              children: [
                LifeRing(letter: user.name[0]),
                const SizedBox(height: 12),
                Text(
                  user.name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '@${user.username}',
                  style: const TextStyle(fontSize: 13, color: Colors.white38),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          WaveDivider(
            squareSize: 3,
            gap: 1,
            color: const Color(0xFF1565C0),
            alternateColor: Colors.white,
            borderRadius: 2,
            animated: true,
            animationDuration: const Duration(milliseconds: 5000),
          ),
          _Section(
            title: 'MAIN',
            items: [
              _Item(icon: Icons.sailing, label: 'Email', value: user.email),
              _Item(icon: Icons.waves, label: 'Phone', value: user.phone),
              _Item(icon: Icons.explore, label: 'Website', value: user.website),
            ],
          ),
          const SizedBox(height: 16),

          _Section(
            title: 'ADDRESS',
            items: [
              _Item(
                icon: Icons.anchor,
                label: 'City',
                value: user.address.city,
              ),
              _Item(
                icon: Icons.map_outlined,
                label: 'Street',
                value: '${user.address.street}, ${user.address.suite}',
              ),
              _Item(
                icon: Icons.markunread_mailbox_outlined,
                label: 'Zip Code',
                value: user.address.zipcode,
              ),
            ],
          ),
          const SizedBox(height: 16),

          _Section(
            title: 'COMPANY',
            items: [
              _Item(
                icon: Icons.directions_boat_outlined,
                label: 'Name',
                value: user.company.name,
              ),
              _Item(
                icon: Icons.format_quote_outlined,
                label: 'Catch Phrase',
                value: user.company.catchPhrase,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final List<_Item> items;

  const _Section({required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 11,
            color: Colors.white38,
            letterSpacing: 2,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: List.generate(items.length, (i) {
              return Column(
                children: [
                  items[i],
                  if (i < items.length - 1)
                    Divider(
                      height: 1,
                      color: Colors.white.withOpacity(0.06),
                      indent: 52,
                    ),
                ],
              );
            }),
          ),
        ),
      ],
    );
  }
}

class _Item extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _Item({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF4DA6FF), size: 20),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(fontSize: 11, color: Colors.white38),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}



