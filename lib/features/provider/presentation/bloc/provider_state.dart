import 'package:equatable/equatable.dart';
import '../../domain/entities/provider_entities.dart';

abstract class ProviderState extends Equatable {
  const ProviderState();

  @override
  List<Object> get props => [];
}

class ProviderInitial extends ProviderState {}

class ProviderLoading extends ProviderState {}

class ProviderProfileLoaded extends ProviderState {
  final ProviderEntity provider;

  const ProviderProfileLoaded({required this.provider});

  @override
  List<Object> get props => [provider];
}

class ProviderProfileUpdated extends ProviderState {
  final ProviderEntity provider;

  const ProviderProfileUpdated({required this.provider});

  @override
  List<Object> get props => [provider];
}

class ProviderRegistered extends ProviderState {
  final ProviderEntity provider;

  const ProviderRegistered({required this.provider});

  @override
  List<Object> get props => [provider];
}

class ProviderConverted extends ProviderState {
  final ProviderEntity provider;

  const ProviderConverted({required this.provider});

  @override
  List<Object> get props => [provider];
}

class ProviderAvailabilityUpdated extends ProviderState {
  final bool disponible;
  final bool modoOcupado;

  const ProviderAvailabilityUpdated({
    required this.disponible,
    required this.modoOcupado,
  });

  @override
  List<Object> get props => [disponible, modoOcupado];
}

class ProviderLocationUpdated extends ProviderState {}

class ProviderStatisticsLoaded extends ProviderState {
  final ProviderStatisticsEntity statistics;

  const ProviderStatisticsLoaded({required this.statistics});

  @override
  List<Object> get props => [statistics];
}

class ProvidersLoaded extends ProviderState {
  final List<ProviderEntity> providers;

  const ProvidersLoaded({required this.providers});

  @override
  List<Object> get props => [providers];
}

class ProvidersSearched extends ProviderState {
  final List<ProviderEntity> providers;
  final double lat;
  final double lng;
  final double radius;

  const ProvidersSearched({
    required this.providers,
    required this.lat,
    required this.lng,
    required this.radius,
  });

  @override
  List<Object> get props => [providers, lat, lng, radius];
}

class ProviderError extends ProviderState {
  final String message;

  const ProviderError({required this.message});

  @override
  List<Object> get props => [message];
}

class ProviderDashboardLoaded extends ProviderState {
  final ProviderEntity provider;
  final ProviderStatisticsEntity statistics;

  const ProviderDashboardLoaded({
    required this.provider,
    required this.statistics,
  });

  @override
  List<Object> get props => [provider, statistics];
}
