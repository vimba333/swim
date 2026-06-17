import 'package:swim/core/domain/entities/user_preview.dart';
import 'package:swim/features/users/domain/repositories/users_repository.dart';

class GetUsersUsecase {
  final UsersRepository repository;

  const GetUsersUsecase(this.repository);

  Future<List<UserPreview>> call() {
    return repository.getUsers();
  }
}