import 'package:swim/features/users/domain/entities/user.dart';
import 'package:swim/features/users/domain/repositories/users_repository.dart';

class GetUserUsecase {
  final UsersRepository repository;

  const GetUserUsecase(this.repository);

  Future<User> call(int id) {
    return repository.getUserById(id);
  }
}