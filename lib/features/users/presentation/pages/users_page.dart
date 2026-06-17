
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:swim/features/users/data/datasources/users_remote_datasource.dart';
import 'package:swim/features/users/data/repositories/users_repository_impl.dart';
import 'package:swim/features/users/domain/use_cases/get_users_usecase.dart';
import 'package:swim/features/users/presentation/cubit/users_cubit.dart';
import 'package:swim/features/users/presentation/cubit/users_state.dart';
import 'package:swim/features/users/presentation/widgets/user_card.dart';

class UsersPage extends StatelessWidget {
  const UsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => UsersCubit(
        GetUsersUsecase(
          UsersRepositoryImpl(
            UsersRemoteDatasourceImpl(http.Client()),
          ),
        ),
      )..getUsers(),
      child: Scaffold(
        appBar: AppBar(
        title: const Text('Users'),
        leading: IconButton(
          onPressed: () => context.go('/'),
          icon: const Icon(Icons.arrow_back),
          tooltip: 'Back to the home page',
        ),
      ),
        body: BlocBuilder<UsersCubit, UsersState>(
          builder: (context, state) {
            return switch (state) {
              UsersInitial() => const SizedBox.shrink(),
              UsersLoading() => const Center(child: CircularProgressIndicator()),
              UsersLoaded(:final users) => ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (context, index) => UserCard(user: users[index]),
                ),
              UsersError(:final message) => Center(child: Text(message)),
            };
          },
        ),
      ),
    );
  }
}