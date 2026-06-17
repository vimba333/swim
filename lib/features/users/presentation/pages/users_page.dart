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
          UsersRepositoryImpl(UsersRemoteDatasourceImpl(http.Client())),
        ),
      )..getUsers(),
      child: const _UsersView(),
    );
  }
}

class _UsersView extends StatefulWidget {
  const _UsersView();

  @override
  State<_UsersView> createState() => _UsersViewState();
}

class _UsersViewState extends State<_UsersView> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Users'),
        leading: IconButton(
          onPressed: () => context.go('/'),
          icon: const Icon(Icons.arrow_back),
          tooltip: 'Back to the home page',
        ),

        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              _searchController.clear();
              context.read<UsersCubit>().getUsers();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search by name or email...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          context.read<UsersCubit>().search('');
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: context.read<UsersCubit>().search,
            ),
          ),
          Expanded(
            child: BlocBuilder<UsersCubit, UsersState>(
              builder: (context, state) {
                return switch (state) {
                  UsersInitial() => const SizedBox.shrink(),
                  UsersLoading() => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  UsersLoaded(:final filtered) =>
                    filtered.isEmpty
                        ? const Center(child: Text('Nothing found'))
                        : ListView.builder(
                            itemCount: filtered.length,
                            itemBuilder: (context, index) => InkWell(
                              onTap: () =>
                                  context.push('/users/${filtered[index].id}'),
                              child: UserCard(user: filtered[index]),
                            ),
                          ),
                  UsersError(:final message) => Center(child: Text(message)),
                };
              },
            ),
          ),
        ],
      ),
    );
  }
}
