
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swim/features/users/domain/use_cases/get_user_usecase.dart';
import 'package:swim/features/users/presentation/cubit/user_detail_state.dart';

class UserDetailCubit extends Cubit<UserDetailState> {
  final GetUserUsecase _getUserUsecase;

  UserDetailCubit(this._getUserUsecase) : super(const UserDetailInitial());

  Future<void> getUser(int id) async {
    try {
      emit(const UserDetailLoading());
      final user = await _getUserUsecase(id);
      emit(UserDetailLoaded(user));
    } catch (e) {
      emit(UserDetailError(e.toString()));
    }
  }
}