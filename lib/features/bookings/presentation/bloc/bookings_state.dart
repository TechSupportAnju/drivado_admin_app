part of 'bookings_bloc.dart';

sealed class BookingsState extends Equatable {
  const BookingsState();

  @override
  List<Object?> get props => [];
}

final class BookingsInitial extends BookingsState {
  const BookingsInitial();
}

final class BookingsLoading extends BookingsState {
  const BookingsLoading();
}

final class BookingsLoaded extends BookingsState {
  const BookingsLoaded({
    required this.bookings,
    required this.allBookings,
    required this.tab,
    required this.query,
  });

  final List<ManagedBooking> bookings;
  final List<ManagedBooking> allBookings;
  final BookingFilterTab tab;
  final String query;

  @override
  List<Object?> get props => [bookings, allBookings, tab, query];
}

final class BookingsFailure extends BookingsState {
  const BookingsFailure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
