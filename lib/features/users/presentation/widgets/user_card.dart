import 'package:flutter/material.dart';
import 'package:swim/core/domain/entities/user_preview.dart';

class UserCard extends StatelessWidget {
  final UserPreview user;

  const UserCard({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          child: Text(user.name[0]),
        ),
        title: Text(user.name),
        subtitle: Text(user.email),
        trailing: Text(user.phone, style: Theme.of(context).textTheme.bodySmall),
      ),
    );
  }
}