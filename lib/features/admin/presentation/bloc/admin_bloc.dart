import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_users_usecase.dart';
import '../../domain/usecases/update_user_status_usecase.dart';
import '../../domain/usecases/update_user_role_usecase.dart';
import '../../domain/usecases/search_users_usecase.dart';
import '../../domain/usecases/get_user_by_id_usecase.dart';
import '../../domain/usecases/update_user_profile_usecase.dart';
import 'admin_event.dart';
import 'admin_state.dart';

class AdminBloc extends Bloc<AdminEvent, AdminState> {
  final GetUsersUseCase getUsersUseCase;
  final UpdateUserStatusUseCase updateUserStatusUseCase;
  final UpdateUserRoleUseCase updateUserRoleUseCase;
  final SearchUsersUseCase searchUsersUseCase;
  final GetUserByIdUseCase getUserByIdUseCase;
  final UpdateUserProfileUseCase updateUserProfileUseCase;

  AdminBloc({
    required this.getUsersUseCase,
    required this.updateUserStatusUseCase,
    required this.updateUserRoleUseCase,
    required this.searchUsersUseCase,
    required this.getUserByIdUseCase,
    required this.updateUserProfileUseCase,
  }) : super(AdminInitial()) {
    on<GetUsersEvent>(_onGetUsersEvent);
    on<UpdateUserStatusEvent>(_onUpdateUserStatusEvent);
    on<UpdateUserRoleEvent>(_onUpdateUserRoleEvent);
    on<RefreshUsersEvent>(_onRefreshUsersEvent);
    on<SearchUsersEvent>(_onSearchUsersEvent);
    on<GetUserByIdEvent>(_onGetUserByIdEvent);
    on<UpdateUserProfileEvent>(_onUpdateUserProfileEvent);
  }

  Future<void> _onGetUsersEvent(
      GetUsersEvent event, Emitter<AdminState> emit) async {
    print(
        '🔄 AdminBloc: Obteniendo usuarios - page: ${event.page}, limit: ${event.limit}');
    emit(AdminLoading());

    final result = await getUsersUseCase(GetUsersParams(
      page: event.page,
      limit: event.limit,
    ));

    result.fold(
      (failure) {
        print('❌ AdminBloc: Error obteniendo usuarios - ${failure.message}');
        emit(AdminError(message: failure.message));
      },
      (userList) {
        print(
            '✅ AdminBloc: Usuarios obtenidos - ${userList.users.length} usuarios');
        emit(UsersLoaded(userList: userList));
      },
    );
  }

  Future<void> _onUpdateUserStatusEvent(
      UpdateUserStatusEvent event, Emitter<AdminState> emit) async {
    final result = await updateUserStatusUseCase(UpdateUserStatusParams(
      userId: event.userId,
      status: event.status,
    ));

    result.fold(
      (failure) => emit(AdminError(message: failure.message)),
      (_) => emit(
          UserStatusUpdated(userId: event.userId, newStatus: event.status)),
    );
  }

  Future<void> _onUpdateUserRoleEvent(
      UpdateUserRoleEvent event, Emitter<AdminState> emit) async {
    final result = await updateUserRoleUseCase(UpdateUserRoleParams(
      userId: event.userId,
      role: event.role,
    ));

    result.fold(
      (failure) => emit(AdminError(message: failure.message)),
      (_) => emit(UserRoleUpdated(userId: event.userId, newRole: event.role)),
    );
  }

  Future<void> _onRefreshUsersEvent(
      RefreshUsersEvent event, Emitter<AdminState> emit) async {
    // Re-fetch users to get updated data
    add(const GetUsersEvent());
  }

  Future<void> _onSearchUsersEvent(
      SearchUsersEvent event, Emitter<AdminState> emit) async {
    emit(AdminLoading());

    final result = await searchUsersUseCase(SearchUsersParams(
      query: event.query,
      page: event.page,
      limit: event.limit,
    ));

    result.fold(
      (failure) => emit(AdminError(message: failure.message)),
      (userList) => emit(UsersSearchLoaded(
        userList: userList,
        searchQuery: event.query,
      )),
    );
  }

  Future<void> _onGetUserByIdEvent(
      GetUserByIdEvent event, Emitter<AdminState> emit) async {
    emit(AdminLoading());

    final result = await getUserByIdUseCase(GetUserByIdParams(
      userId: event.userId,
    ));

    result.fold(
      (failure) => emit(AdminError(message: failure.message)),
      (user) => emit(UserProfileLoaded(user: user)),
    );
  }

  Future<void> _onUpdateUserProfileEvent(
      UpdateUserProfileEvent event, Emitter<AdminState> emit) async {
    emit(AdminLoading());

    final result = await updateUserProfileUseCase(UpdateUserProfileParams(
      user: event.user,
    ));

    result.fold(
      (failure) => emit(AdminError(message: failure.message)),
      (updatedUser) => emit(UserProfileUpdated(user: updatedUser)),
    );
  }
}
