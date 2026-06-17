import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

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
          UsersRepositoryImpl(
            UsersRemoteDatasourceImpl(http.Client()),
          ),
        ),
      )..getUser(userId),
      child: Scaffold(
        appBar: AppBar(title: const Text('Пользователь')),
        body: BlocBuilder<UserDetailCubit, UserDetailState>(
          builder: (context, state) {
            return switch (state) {
              UserDetailInitial() => const SizedBox.shrink(),
              UserDetailLoading() =>
                const Center(child: CircularProgressIndicator()),
              UserDetailLoaded(:final user) => _UserDetailView(user: user),
              UserDetailError(:final message) =>
                Center(child: Text(message)),
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
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: CircleAvatar(
              radius: 40,
              child: Text(
                user.name[0],
                style: const TextStyle(fontSize: 32),
              ),
            ),
          ),
          const SizedBox(height: 24),
          _Section(title: 'Основное', items: [
            _Item(icon: Icons.person, label: 'Имя', value: user.name),
            _Item(icon: Icons.alternate_email, label: 'Username', value: '@${user.username}'),
            _Item(icon: Icons.email, label: 'Email', value: user.email),
            _Item(icon: Icons.phone, label: 'Телефон', value: user.phone),
            _Item(icon: Icons.language, label: 'Сайт', value: user.website),
          ]),
          const SizedBox(height: 16),
          _Section(title: 'Адрес', items: [
            _Item(icon: Icons.location_on, label: 'Город', value: user.address.city),
            _Item(icon: Icons.map, label: 'Улица', value: '${user.address.street}, ${user.address.suite}'),
            _Item(icon: Icons.markunread_mailbox, label: 'Индекс', value: user.address.zipcode),
          ]),
          const SizedBox(height: 16),
          _Section(title: 'Компания', items: [
            _Item(icon: Icons.business, label: 'Название', value: user.company.name),
            _Item(icon: Icons.format_quote, label: 'Девиз', value: user.company.catchPhrase),
          ]),
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
        Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
        )),
        const SizedBox(height: 8),
        Card(
          child: Column(
            children: items,
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
    return ListTile(
      leading: Icon(icon),
      title: Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      subtitle: Text(value),
    );
  }
}