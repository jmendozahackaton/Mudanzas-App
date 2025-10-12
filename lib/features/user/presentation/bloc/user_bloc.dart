import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_profile_usecase.dart';
import '../../domain/usecases/update_profile_usecase.dart';
import 'user_event.dart';
import 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final GetProfileUseCase getProfileUseCase;
  final UpdateProfileUseCase updateProfileUseCase;

  UserBloc({
    required this.getProfileUseCase,
    required this.updateProfileUseCase,
  }) : super(UserInitial()) {
    on<GetProfileEvent>(_onGetProfileEvent);
    on<UpdateProfileEvent>(_onUpdateProfileEvent);
  }

  Future<void> _onGetProfileEvent(
      GetProfileEvent event, Emitter<UserState> emit) async {
    print('🔄 UserBloc: Obteniendo perfil...');
    emit(UserLoading());

    final result = await getProfileUseCase();

    result.fold(
      (failure) {
        print('❌ UserBloc: Error obteniendo perfil - ${failure.message}');
        emit(UserError(message: failure.message));
      },
      (user) {
        print('✅ UserBloc: Perfil obtenido exitosamente - ${user.email}');
        print('✅ UserBloc: Emitiendo UserProfileLoaded');
        emit(UserProfileLoaded(user: user));
      },
    );
  }

  Future<void> _onUpdateProfileEvent(
      UpdateProfileEvent event, Emitter<UserState> emit) async {
    emit(UserLoading());

    final result = await updateProfileUseCase(UpdateProfileParams(
      nombre: event.nombre,
      apellido: event.apellido,
      email: event.email,
      telefono: event.telefono,
      password: event.password,
    ));

    result.fold(
      (failure) => emit(UserError(message: failure.message)),
      (user) => emit(UserProfileUpdated(user: user)),
    );
  }
}
