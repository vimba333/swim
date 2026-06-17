import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class UsersPage extends StatelessWidget {
  const UsersPage({super.key});

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
      ),
      body: const Center(
        child: Text('Users Page'),
      ),
      
    );
  }
}
