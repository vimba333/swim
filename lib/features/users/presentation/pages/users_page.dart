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
      backgroundColor: const Color(0xFF0A1628),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A1628),
        elevation: 0,
        leading: IconButton(
          onPressed: () => context.go('/'),
          icon: const Icon(Icons.chevron_left, color: Colors.white),
        ),
        title: const Text(
          'Users',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded, color: Colors.white54),
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
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: TextField(
              controller: _searchController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Search by name or email...',
                hintStyle: const TextStyle(color: Colors.white38),
                prefixIcon: const Icon(Icons.search, color: Colors.white38),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: Colors.white38),
                        onPressed: () {
                          _searchController.clear();
                          context.read<UsersCubit>().search('');
                        },
                      )
                    : null,
                filled: true,
                fillColor: Colors.white.withOpacity(0.06),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (val) {
                setState(() {});
                context.read<UsersCubit>().search(val);
              },
            ),
          ),
          Expanded(
            child: BlocBuilder<UsersCubit, UsersState>(
              builder: (context, state) {
                return switch (state) {
                  UsersInitial() => const SizedBox.shrink(),
                  UsersLoading() => const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF00E096),
                      ),
                    ),
                  UsersLoaded(:final filtered) => filtered.isEmpty
                      ? const Center(
                          child: Text(
                            'Nothing found',
                            style: TextStyle(color: Colors.white38),
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          itemCount: filtered.length,
                          itemBuilder: (context, index) => _UserCardWrapper(
                            onTap: () =>
                                context.push('/users/${filtered[index].id}'),
                            child: UserCard(user: filtered[index]),
                          ),
                        ),
                  UsersError(:final message) => Center(
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
                          const SizedBox(height: 16),
                          TextButton(
                            onPressed: () =>
                                context.read<UsersCubit>().getUsers(),
                            child: const Text(
                              'Try again',
                              style: TextStyle(color: Color(0xFF00E096)),
                            ),
                          ),
                        ],
                      ),
                    ),
                };
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _UserCardWrapper extends StatelessWidget {
  final Widget child;
  final VoidCallback onTap;

  const _UserCardWrapper({required this.child, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: child,
        ),
      ),
    );
  }
}