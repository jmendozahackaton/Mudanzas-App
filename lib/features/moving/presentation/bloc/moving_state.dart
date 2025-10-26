import 'package:equatable/equatable.dart';
import '../../domain/entities/moving_entities.dart';

abstract class MovingState extends Equatable {
  const MovingState();

  @override
  List<Object> get props => [];
}

class MovingInitial extends MovingState {}

class MovingLoading extends MovingState {}

class MovingRequestCreated extends MovingState {
  final MovingRequestEntity request;

  const MovingRequestCreated({required this.request});

  @override
  List<Object> get props => [request];
}

class ClientRequestsLoaded extends MovingState {
  final MovingRequestListEntity requests;

  const ClientRequestsLoaded({required this.requests});

  @override
  List<Object> get props => [requests];
}

class AllRequestsLoaded extends MovingState {
  final MovingRequestListEntity requests;

  const AllRequestsLoaded({required this.requests});

  @override
  List<Object> get props => [requests];
}

class ClientMovingsLoaded extends MovingState {
  final MovingListEntity movings;

  const ClientMovingsLoaded({required this.movings});

  @override
  List<Object> get props => [movings];
}

class ProviderMovingsLoaded extends MovingState {
  final MovingListEntity movings;

  const ProviderMovingsLoaded({required this.movings});

  @override
  List<Object> get props => [movings];
}

class MovingStatusUpdated extends MovingState {
  final MovingEntity moving;

  const MovingStatusUpdated({required this.moving});

  @override
  List<Object> get props => [moving];
}

class ProviderAssigned extends MovingState {
  final MovingEntity moving;

  const ProviderAssigned({required this.moving});

  @override
  List<Object> get props => [moving];
}

class MovingError extends MovingState {
  final String message;

  const MovingError({required this.message});

  @override
  List<Object> get props => [message];
}
