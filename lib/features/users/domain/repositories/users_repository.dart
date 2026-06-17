import 'package:swim/core/domain/entities/user_preview.dart';

abstract interface class UsersRepository {
  Future<List<UserPreview>> getUsers();
}