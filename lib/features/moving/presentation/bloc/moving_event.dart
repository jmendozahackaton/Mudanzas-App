import 'package:equatable/equatable.dart';

abstract class MovingEvent extends Equatable {
  const MovingEvent();

  @override
  List<Object> get props => [];
}

class CreateMovingRequestEvent extends MovingEvent {
  final Map<String, dynamic> requestData;

  const CreateMovingRequestEvent(this.requestData);

  @override
  List<Object> get props => [requestData];
}

class GetClientRequestsEvent extends MovingEvent {
  final int page;
  final int limit;

  const GetClientRequestsEvent({this.page = 1, this.limit = 10});

  @override
  List<Object> get props => [page, limit];
}

class GetAllRequestsEvent extends MovingEvent {
  final int page;
  final int limit;
  final String? estado;

  const GetAllRequestsEvent({this.page = 1, this.limit = 10, this.estado});

  @override
  List<Object> get props => [page, limit, estado ?? ''];
}

class GetClientMovingsEvent extends MovingEvent {
  final int page;
  final int limit;

  const GetClientMovingsEvent({this.page = 1, this.limit = 10});

  @override
  List<Object> get props => [page, limit];
}

class GetProviderMovingsEvent extends MovingEvent {
  final int page;
  final int limit;

  const GetProviderMovingsEvent({this.page = 1, this.limit = 10});

  @override
  List<Object> get props => [page, limit];
}

class UpdateMovingStatusEvent extends MovingEvent {
  final int mudanzaId;
  final String estado;

  const UpdateMovingStatusEvent({
    required this.mudanzaId,
    required this.estado,
  });

  @override
  List<Object> get props => [mudanzaId, estado];
}

class AssignProviderEvent extends MovingEvent {
  final Map<String, dynamic> assignData;

  const AssignProviderEvent(this.assignData);

  @override
  List<Object> get props => [assignData];
}

class RefreshMovingDataEvent extends MovingEvent {}
