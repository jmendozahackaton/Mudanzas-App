import 'package:equatable/equatable.dart';

abstract class AdminEvent extends Equatable {
  const AdminEvent();

  @override
  List<Object> get props => [];
}

class GetUsersEvent extends AdminEvent {
  final int page;
  final int limit;

  const GetUsersEvent({this.page = 1, this.limit = 10});

  @override
  List<Object> get props => [page, limit];
}

class UpdateUserStatusEvent extends AdminEvent {
  final int userId;
  final String status;

  const UpdateUserStatusEvent({
    required this.userId,
    required this.status,
  });

  @override
  List<Object> get props => [userId, status];
}

class UpdateUserRoleEvent extends AdminEvent {
  final int userId;
  final String role;

  const UpdateUserRoleEvent({
    required this.userId,
    required this.role,
  });

  @override
  List<Object> get props => [userId, role];
}

class RefreshUsersEvent extends AdminEvent {}
