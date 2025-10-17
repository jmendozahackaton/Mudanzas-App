import 'package:flutter_bloc/flutter_bloc.dart';
import 'provider_event.dart';
import 'provider_state.dart';
import '../../domain/usecases/register_provider_usecase.dart';
import '../../domain/usecases/get_provider_profile_usecase.dart';
import '../../domain/usecases/update_provider_profile_usecase.dart';
import '../../domain/usecases/update_provider_availability_usecase.dart';
import '../../domain/usecases/update_provider_location_usecase.dart';
import '../../domain/usecases/get_provider_statistics_usecase.dart';
import '../../domain/usecases/search_providers_location_usecase.dart';

class ProviderBloc extends Bloc<ProviderEvent, ProviderState> {
  final RegisterProviderUseCase registerProviderUseCase;
  final GetProviderProfileUseCase getProviderProfileUseCase;
  final UpdateProviderProfileUseCase updateProviderProfileUseCase;
  final UpdateProviderAvailabilityUseCase updateProviderAvailabilityUseCase;
  final UpdateProviderLocationUseCase updateProviderLocationUseCase;
  final GetProviderStatisticsUseCase getProviderStatisticsUseCase;
  final SearchProvidersLocationUseCase searchProvidersLocationUseCase;

  ProviderBloc({
    required this.registerProviderUseCase,
    required this.getProviderProfileUseCase,
    required this.updateProviderProfileUseCase,
    required this.updateProviderAvailabilityUseCase,
    required this.updateProviderLocationUseCase,
    required this.getProviderStatisticsUseCase,
    required this.searchProvidersLocationUseCase,
  }) : super(ProviderInitial()) {
    on<RegisterProviderEvent>(_onRegisterProvider);
    on<GetProviderProfileEvent>(_onGetProviderProfile);
    on<UpdateProviderProfileEvent>(_onUpdateProviderProfile);
    on<UpdateProviderAvailabilityEvent>(_onUpdateProviderAvailability);
    on<UpdateProviderLocationEvent>(_onUpdateProviderLocation);
    on<GetProviderStatisticsEvent>(_onGetProviderStatistics);
    on<SearchProvidersByLocationEvent>(_onSearchProvidersByLocation);
  }

  Future<void> _onRegisterProvider(
    RegisterProviderEvent event,
    Emitter<ProviderState> emit,
  ) async {
    emit(ProviderLoading());

    final result = await registerProviderUseCase(event.providerData);

    result.fold(
      (failure) => emit(ProviderError(message: failure.toString())),
      (provider) => emit(ProviderRegistered(provider: provider)),
    );
  }

  Future<void> _onGetProviderProfile(
    GetProviderProfileEvent event,
    Emitter<ProviderState> emit,
  ) async {
    emit(ProviderLoading());

    final result = await getProviderProfileUseCase();

    result.fold(
      (failure) => emit(ProviderError(message: failure.toString())),
      (provider) => emit(ProviderProfileLoaded(provider: provider)),
    );
  }

  Future<void> _onUpdateProviderProfile(
    UpdateProviderProfileEvent event,
    Emitter<ProviderState> emit,
  ) async {
    emit(ProviderLoading());

    final result = await updateProviderProfileUseCase(event.updateData);

    result.fold(
      (failure) => emit(ProviderError(message: failure.toString())),
      (provider) => emit(ProviderProfileUpdated(provider: provider)),
    );
  }

  Future<void> _onUpdateProviderAvailability(
    UpdateProviderAvailabilityEvent event,
    Emitter<ProviderState> emit,
  ) async {
    emit(ProviderLoading());

    final result = await updateProviderAvailabilityUseCase(
      event.disponible,
      event.modoOcupado,
    );

    result.fold(
      (failure) => emit(ProviderError(message: failure.toString())),
      (_) => emit(ProviderAvailabilityUpdated(
        disponible: event.disponible,
        modoOcupado: event.modoOcupado,
      )),
    );
  }

  Future<void> _onUpdateProviderLocation(
    UpdateProviderLocationEvent event,
    Emitter<ProviderState> emit,
  ) async {
    emit(ProviderLoading());

    final result = await updateProviderLocationUseCase(event.lat, event.lng);

    result.fold(
      (failure) => emit(ProviderError(message: failure.toString())),
      (_) => emit(ProviderLocationUpdated()),
    );
  }

  Future<void> _onGetProviderStatistics(
    GetProviderStatisticsEvent event,
    Emitter<ProviderState> emit,
  ) async {
    emit(ProviderLoading());

    final result = await getProviderStatisticsUseCase();

    result.fold(
      (failure) => emit(ProviderError(message: failure.toString())),
      (statistics) => emit(ProviderStatisticsLoaded(statistics: statistics)),
    );
  }

  Future<void> _onSearchProvidersByLocation(
    SearchProvidersByLocationEvent event,
    Emitter<ProviderState> emit,
  ) async {
    emit(ProviderLoading());

    final result = await searchProvidersLocationUseCase(
      lat: event.lat,
      lng: event.lng,
      radius: event.radius,
      limit: event.limit,
    );

    result.fold(
      (failure) => emit(ProviderError(message: failure.toString())),
      (providers) => emit(ProvidersSearched(
        providers: providers,
        lat: event.lat,
        lng: event.lng,
        radius: event.radius,
      )),
    );
  }
}
