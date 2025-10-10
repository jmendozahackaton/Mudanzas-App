import 'package:equatable/equatable.dart';
import '../../domain/entities/admin_entities.dart';

abstract class AdminState extends Equatable {
  const AdminState();

  @override
  List<Object> get props => [];
}

class AdminInitial extends AdminState {}

class AdminLoading extends AdminState {}

class UsersLoaded extends AdminState {
  final UserListEntity userList;

  const UsersLoaded({required this.userList});

  @override
  List<Object> get props => [userList];
}

class UserStatusUpdated extends AdminState {
  final int userId;
  final String newStatus;

  const UserStatusUpdated({
    required this.userId,
    required this.newStatus,
  });

  @override
  List<Object> get props => [userId, newStatus];
}

class UserRoleUpdated extends AdminState {
  final int userId;
  final String newRole;

  const UserRoleUpdated({
    required this.userId,
    required this.newRole,
  });

  @override
  List<Object> get props => [userId, newRole];
}

class AdminError extends AdminState {
  final String message;

  const AdminError({required this.message});

  @override
  List<Object> get props => [message];
}
