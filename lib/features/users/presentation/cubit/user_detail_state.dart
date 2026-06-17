import 'package:swim/features/users/domain/entities/user.dart';

sealed class UserDetailState {
  const UserDetailState();
}

class UserDetailInitial extends UserDetailState {
  const UserDetailInitial();
}

class UserDetailLoading extends UserDetailState {
  const UserDetailLoading();
}

class UserDetailLoaded extends UserDetailState {
  final User user;
  const UserDetailLoaded(this.user);
}

class UserDetailError extends UserDetailState {
  final String message;
  final bool isNetwork;

  const UserDetailError(this.message, {this.isNetwork = false});
}
