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
      emit(UsersLoaded(users: users, filtered: users));
    } catch (e) {
      emit(UsersError(e.toString()));
    }
  }

  void search(String query) {
    final state = this.state;
    if (state is! UsersLoaded) return;

    if (query.isEmpty) {
      emit(UsersLoaded(users: state.users, filtered: state.users));
      return;
    }

    final filtered = state.users.where((u) {
      return u.name.toLowerCase().contains(query.toLowerCase()) ||
          u.email.toLowerCase().contains(query.toLowerCase());
    }).toList();

    emit(UsersLoaded(users: state.users, filtered: filtered));
  }
}