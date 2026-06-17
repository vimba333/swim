import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swim/core/presentation/cubit/current_user_state.dart';
import 'package:swim/core/domain/entities/user_preview.dart';

class CurrentUserCubit extends Cubit<CurrentUserState> {
  CurrentUserCubit() : super(CurrentUserState(
    /// TODO: Replace with actual user data
    const UserPreview(
      id: 1,
      name: 'Leanne Graham',
      email: 'Sincere@april.biz',
      phone: '1-770-736-8031 x56442',
    ),
  ));
}