import 'package:swim/core/domain/entities/user_preview.dart';
import 'package:swim/features/users/data/datasources/users_remote_datasource.dart';
import 'package:swim/features/users/domain/entities/user.dart';
import 'package:swim/features/users/domain/repositories/users_repository.dart';

class UsersRepositoryImpl implements UsersRepository {
  final UsersRemoteDatasource datasource;

  UsersRepositoryImpl(this.datasource);

  @override
  Future<List<UserPreview>> getUsers() async {
    final models = await datasource.getUsers();
    return models.map((e) => e.toEntity()).toList();
  }

   @override
  Future<User> getUserById(int id) async {
    final model = await datasource.getUserById(id);
    return model.toEntity();
  }
}