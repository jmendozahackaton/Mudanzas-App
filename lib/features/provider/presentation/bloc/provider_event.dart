import 'package:equatable/equatable.dart';

abstract class ProviderEvent extends Equatable {
  const ProviderEvent();

  @override
  List<Object> get props => [];
}

class RegisterProviderEvent extends ProviderEvent {
  final Map<String, dynamic> providerData;

  const RegisterProviderEvent(this.providerData);

  @override
  List<Object> get props => [providerData];
}

class ConvertToProviderEvent extends ProviderEvent {
  final Map<String, dynamic> providerData;

  const ConvertToProviderEvent(this.providerData);

  @override
  List<Object> get props => [providerData];
}

class GetProviderProfileEvent extends ProviderEvent {}

class UpdateProviderProfileEvent extends ProviderEvent {
  final Map<String, dynamic> updateData;

  const UpdateProviderProfileEvent(this.updateData);

  @override
  List<Object> get props => [updateData];
}

class UpdateProviderAvailabilityEvent extends ProviderEvent {
  final bool disponible;
  final bool modoOcupado;

  const UpdateProviderAvailabilityEvent({
    required this.disponible,
    required this.modoOcupado,
  });

  @override
  List<Object> get props => [disponible, modoOcupado];
}

class UpdateProviderLocationEvent extends ProviderEvent {
  final double lat;
  final double lng;

  const UpdateProviderLocationEvent({
    required this.lat,
    required this.lng,
  });

  @override
  List<Object> get props => [lat, lng];
}

class GetProviderStatisticsEvent extends ProviderEvent {}

class GetProvidersEvent extends ProviderEvent {
  final int page;
  final int limit;

  const GetProvidersEvent({this.page = 1, this.limit = 10});

  @override
  List<Object> get props => [page, limit];
}

class SearchProvidersByLocationEvent extends ProviderEvent {
  final double lat;
  final double lng;
  final double radius;
  final int limit;

  const SearchProvidersByLocationEvent({
    required this.lat,
    required this.lng,
    this.radius = 10,
    this.limit = 10,
  });

  @override
  List<Object> get props => [lat, lng, radius, limit];
}
