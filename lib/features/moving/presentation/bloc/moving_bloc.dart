import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/create_moving_request_usecase.dart';
import '../../domain/usecases/get_client_requests_usecase.dart';
import '../../domain/usecases/get_all_requests_usecase.dart';
import '../../domain/usecases/get_client_movings_usecase.dart';
import '../../domain/usecases/update_moving_status_usecase.dart';
import '../../domain/usecases/assign_provider_usecase.dart';
import 'moving_event.dart';
import 'moving_state.dart';

class MovingBloc extends Bloc<MovingEvent, MovingState> {
  final CreateMovingRequestUseCase createMovingRequestUseCase;
  final GetClientRequestsUseCase getClientRequestsUseCase;
  final GetAllRequestsUseCase getAllRequestsUseCase;
  final GetClientMovingsUseCase getClientMovingsUseCase;
  final UpdateMovingStatusUseCase updateMovingStatusUseCase;
  final AssignProviderUseCase assignProviderUseCase;

  MovingBloc({
    required this.createMovingRequestUseCase,
    required this.getClientRequestsUseCase,
    required this.getAllRequestsUseCase,
    required this.getClientMovingsUseCase,
    required this.updateMovingStatusUseCase,
    required this.assignProviderUseCase,
  }) : super(MovingInitial()) {
    on<CreateMovingRequestEvent>(_onCreateMovingRequest);
    on<GetClientRequestsEvent>(_onGetClientRequests);
    on<GetAllRequestsEvent>(_onGetAllRequests);
    on<GetClientMovingsEvent>(_onGetClientMovings);
    on<UpdateMovingStatusEvent>(_onUpdateMovingStatus);
    on<AssignProviderEvent>(_onAssignProvider);
    on<RefreshMovingDataEvent>(_onRefreshMovingData);
  }

  Future<void> _onCreateMovingRequest(
    CreateMovingRequestEvent event,
    Emitter<MovingState> emit,
  ) async {
    emit(MovingLoading());

    final result = await createMovingRequestUseCase(event.requestData);

    result.fold(
      (failure) => emit(MovingError(message: failure.toString())),
      (request) => emit(MovingRequestCreated(request: request)),
    );
  }

  Future<void> _onGetClientRequests(
    GetClientRequestsEvent event,
    Emitter<MovingState> emit,
  ) async {
    emit(MovingLoading());

    final result = await getClientRequestsUseCase(
      page: event.page,
      limit: event.limit,
    );

    result.fold(
      (failure) => emit(MovingError(message: failure.toString())),
      (requests) => emit(ClientRequestsLoaded(requests: requests)),
    );
  }

  Future<void> _onGetAllRequests(
    GetAllRequestsEvent event,
    Emitter<MovingState> emit,
  ) async {
    emit(MovingLoading());

    final result = await getAllRequestsUseCase(
      page: event.page,
      limit: event.limit,
      estado: event.estado,
    );

    result.fold(
      (failure) => emit(MovingError(message: failure.toString())),
      (requests) => emit(AllRequestsLoaded(requests: requests)),
    );
  }

  Future<void> _onGetClientMovings(
    GetClientMovingsEvent event,
    Emitter<MovingState> emit,
  ) async {
    emit(MovingLoading());

    final result = await getClientMovingsUseCase(
      page: event.page,
      limit: event.limit,
    );

    result.fold(
      (failure) => emit(MovingError(message: failure.toString())),
      (movings) => emit(ClientMovingsLoaded(movings: movings)),
    );
  }

  Future<void> _onUpdateMovingStatus(
    UpdateMovingStatusEvent event,
    Emitter<MovingState> emit,
  ) async {
    emit(MovingLoading());

    final result = await updateMovingStatusUseCase(
      event.mudanzaId,
      event.estado,
    );

    result.fold(
      (failure) => emit(MovingError(message: failure.toString())),
      (moving) => emit(MovingStatusUpdated(moving: moving)),
    );
  }

  Future<void> _onAssignProvider(
    AssignProviderEvent event,
    Emitter<MovingState> emit,
  ) async {
    emit(MovingLoading());

    final result = await assignProviderUseCase(event.assignData);

    result.fold(
      (failure) => emit(MovingError(message: failure.toString())),
      (moving) => emit(ProviderAssigned(moving: moving)),
    );
  }

  Future<void> _onRefreshMovingData(
    RefreshMovingDataEvent event,
    Emitter<MovingState> emit,
  ) async {
    // Re-fetch data
    add(const GetClientRequestsEvent());
    add(const GetClientMovingsEvent());
  }
}
