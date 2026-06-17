
import 'package:swim/core/domain/entities/user_preview.dart';
import 'package:swim/features/users/domain/entities/user.dart';

abstract interface class UsersRepository {
  Future<List<UserPreview>> getUsers();
  Future<User> getUserById(int id);
}