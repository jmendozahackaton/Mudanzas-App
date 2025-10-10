import 'package:equatable/equatable.dart';
import '../../domain/entities/user_profile_entity.dart';

abstract class UserState extends Equatable {
  const UserState();

  @override
  List<Object> get props => [];
}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserProfileLoaded extends UserState {
  final UserProfileEntity user;

  const UserProfileLoaded({required this.user});

  @override
  List<Object> get props => [user];
}

class UserProfileUpdated extends UserState {
  final UserProfileEntity user;

  const UserProfileUpdated({required this.user});

  @override
  List<Object> get props => [user];
}

class UserError extends UserState {
  final String message;

  const UserError({required this.message});

  @override
  List<Object> get props => [message];
}
