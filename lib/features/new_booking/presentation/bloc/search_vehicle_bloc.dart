import 'package:drivado_admin_app/features/new_booking/domain/booking_models.dart';
import 'package:drivado_admin_app/features/new_booking/domain/repositories/booking_catalog_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchVehicleRequest extends Equatable {
  const SearchVehicleRequest({
    required this.isOneway,
    required this.currency,
    required this.pickup,
    this.dropoff,
    this.duration,
  });

  final bool isOneway;
  final String currency;
  final String pickup;
  final String? dropoff;
  final String? duration;

  @override
  List<Object?> get props => [isOneway, currency, pickup, dropoff, duration];
}

abstract class SearchVehicleEvent extends Equatable {
  const SearchVehicleEvent();

  @override
  List<Object?> get props => [];
}

class SearchVehicleRequested extends SearchVehicleEvent {
  const SearchVehicleRequested(this.request);

  final SearchVehicleRequest request;

  @override
  List<Object?> get props => [request];
}

abstract class SearchVehicleState extends Equatable {
  const SearchVehicleState();

  @override
  List<Object?> get props => [];
}

class SearchVehicleInitial extends SearchVehicleState {
  const SearchVehicleInitial();
}

class SearchVehicleLoading extends SearchVehicleState {
  const SearchVehicleLoading();
}

class SearchVehicleLoaded extends SearchVehicleState {
  const SearchVehicleLoaded({
    required this.vehicles,
    this.bookingSearchId = 'mock-search',
  });

  final List<VehicleOption> vehicles;
  final String bookingSearchId;

  @override
  List<Object?> get props => [vehicles, bookingSearchId];
}

class SearchVehicleFailure extends SearchVehicleState {
  const SearchVehicleFailure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

class SearchVehicleBloc extends Bloc<SearchVehicleEvent, SearchVehicleState> {
  SearchVehicleBloc({required this.repository})
      : super(const SearchVehicleInitial()) {
    on<SearchVehicleRequested>(_onSearch);
  }

  final BookingCatalogRepository repository;

  Future<void> _onSearch(
    SearchVehicleRequested event,
    Emitter<SearchVehicleState> emit,
  ) async {
    emit(const SearchVehicleLoading());
    try {
      final request = event.request;
      final vehicles = await repository.searchVehicles(
        isOneway: request.isOneway,
        currency: request.currency,
        pickup: request.pickup,
        dropoff: request.dropoff,
        duration: request.duration,
      );
      emit(SearchVehicleLoaded(vehicles: vehicles));
    } catch (e) {
      emit(SearchVehicleFailure(e.toString().replaceFirst('Exception: ', '')));
    }
  }
}
