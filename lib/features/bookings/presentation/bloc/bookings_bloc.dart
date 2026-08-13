import 'package:drivado_admin_app/features/bookings/domain/entities/managed_booking.dart';
import 'package:drivado_admin_app/features/bookings/domain/repositories/bookings_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'bookings_event.dart';
part 'bookings_state.dart';

class BookingsBloc extends Bloc<BookingsEvent, BookingsState> {
  BookingsBloc(this._repository) : super(const BookingsInitial()) {
    on<BookingsStarted>(_onStarted);
    on<BookingsTabChanged>(_onTabChanged);
    on<BookingsSearchChanged>(_onSearchChanged);
    on<BookingsRefreshed>(_onRefreshed);
  }

  final BookingsRepository _repository;
  List<ManagedBooking> _all = const [];

  Future<void> _onStarted(
    BookingsStarted event,
    Emitter<BookingsState> emit,
  ) async {
    emit(const BookingsLoading());
    try {
      _all = await _repository.fetchBookings();
      emit(_filtered());
    } catch (e) {
      emit(BookingsFailure(e.toString()));
    }
  }

  void _onTabChanged(
    BookingsTabChanged event,
    Emitter<BookingsState> emit,
  ) {
    final current = state;
    if (current is! BookingsLoaded) return;
    emit(_filtered(tab: event.tab, query: current.query));
  }

  void _onSearchChanged(
    BookingsSearchChanged event,
    Emitter<BookingsState> emit,
  ) {
    final current = state;
    if (current is! BookingsLoaded) return;
    emit(_filtered(tab: current.tab, query: event.query));
  }

  Future<void> _onRefreshed(
    BookingsRefreshed event,
    Emitter<BookingsState> emit,
  ) async {
    final current = state;
    final tab = current is BookingsLoaded ? current.tab : BookingFilterTab.all;
    final query = current is BookingsLoaded ? current.query : '';
    try {
      _all = await _repository.fetchBookings();
      emit(_filtered(tab: tab, query: query));
    } catch (e) {
      emit(BookingsFailure(e.toString()));
    }
  }

  BookingsLoaded _filtered({
    BookingFilterTab tab = BookingFilterTab.all,
    String query = '',
  }) {
    final q = query.trim().toLowerCase();
    final items = _all.where((b) {
      if (!tab.matches(b)) return false;
      if (q.isEmpty) return true;
      return b.id.toLowerCase().contains(q) ||
          b.customer.toLowerCase().contains(q) ||
          b.pickup.toLowerCase().contains(q) ||
          b.dropoff.toLowerCase().contains(q) ||
          b.vehicle.toLowerCase().contains(q);
    }).toList();
    return BookingsLoaded(
      bookings: items,
      allBookings: List.unmodifiable(_all),
      tab: tab,
      query: query,
    );
  }
}
