part of 'bookings_bloc.dart';

sealed class BookingsEvent extends Equatable {
  const BookingsEvent();

  @override
  List<Object?> get props => [];
}

final class BookingsStarted extends BookingsEvent {
  const BookingsStarted();
}

final class BookingsRefreshed extends BookingsEvent {
  const BookingsRefreshed();
}

final class BookingsTabChanged extends BookingsEvent {
  const BookingsTabChanged(this.tab);

  final BookingFilterTab tab;

  @override
  List<Object?> get props => [tab];
}

final class BookingsSearchChanged extends BookingsEvent {
  const BookingsSearchChanged(this.query);

  final String query;

  @override
  List<Object?> get props => [query];
}
