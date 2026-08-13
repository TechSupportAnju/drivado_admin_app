part of 'dashboard_bloc.dart';

sealed class DashboardState extends Equatable {
  const DashboardState();

  @override
  List<Object?> get props => [];
}

final class DashboardInitial extends DashboardState {
  const DashboardInitial();
}

final class DashboardLoading extends DashboardState {
  const DashboardLoading();
}

final class DashboardLoaded extends DashboardState {
  const DashboardLoaded(this.snapshot);

  final DashboardSnapshot snapshot;

  @override
  List<Object?> get props => [snapshot];
}

final class DashboardFailure extends DashboardState {
  const DashboardFailure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
