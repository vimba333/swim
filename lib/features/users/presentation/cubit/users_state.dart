
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
  const UsersLoaded(this.users);
}

class UsersError extends UsersState {
  final String message;
  const UsersError(this.message);
}