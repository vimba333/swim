import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swim/features/users/domain/use_cases/get_users_usecase.dart';
import 'package:swim/features/users/presentation/cubit/users_state.dart';


class UsersCubit extends Cubit<UsersState> {
  final GetUsersUsecase _getUsersUsecase;

  UsersCubit(this._getUsersUsecase) : super(const UsersInitial());

  Future<void> getUsers() async {
    try {
      emit(const UsersLoading());
      final users = await _getUsersUsecase();
      emit(UsersLoaded(users));
    } catch (e) {
      emit(UsersError(e.toString()));
    }
  }
}