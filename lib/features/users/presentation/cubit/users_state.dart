
import 'package:swim/core/domain/entities/user_preview.dart';

sealed class UsersState {
  const UsersState();
}

class UsersInitial extends UsersState {
  const UsersInitial();
}

class UsersLoading extends UsersState {
  const UsersLoading();
}

class UsersLoaded extends UsersState {
  final List<UserPreview> users;
  final List<UserPreview> filtered;

  const UsersLoaded({required this.users, required this.filtered});
}

class UsersError extends UsersState {
  final String message;
  final bool isNetwork;

  const UsersError(this.message, {this.isNetwork = false});
}