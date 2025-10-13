import 'package:equatable/equatable.dart';

import '../../domain/entities/admin_entities.dart';

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

class SearchUsersEvent extends AdminEvent {
  final String query;
  final int page;
  final int limit;

  const SearchUsersEvent({
    required this.query,
    this.page = 1,
    this.limit = 10,
  });

  @override
  List<Object> get props => [query, page, limit];
}

class GetUserByIdEvent extends AdminEvent {
  final int userId;

  const GetUserByIdEvent({required this.userId});

  @override
  List<Object> get props => [userId];
}

class UpdateUserProfileEvent extends AdminEvent {
  final UserEntity user;

  const UpdateUserProfileEvent({required this.user});

  @override
  List<Object> get props => [user];
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
