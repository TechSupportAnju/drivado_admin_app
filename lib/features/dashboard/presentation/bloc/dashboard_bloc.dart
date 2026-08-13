import 'package:drivado_admin_app/features/dashboard/domain/entities/dashboard_entities.dart';
import 'package:drivado_admin_app/features/dashboard/domain/repositories/dashboard_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  DashboardBloc(this._repository) : super(const DashboardInitial()) {
    on<DashboardStarted>(_onStarted);
    on<DashboardRefreshed>(_onRefreshed);
  }

  final DashboardRepository _repository;

  Future<void> _onStarted(
    DashboardStarted event,
    Emitter<DashboardState> emit,
  ) async {
    emit(const DashboardLoading());
    try {
      final snapshot = await _repository.fetchDashboard();
      emit(DashboardLoaded(snapshot));
    } catch (error) {
      emit(DashboardFailure(error.toString()));
    }
  }

  Future<void> _onRefreshed(
    DashboardRefreshed event,
    Emitter<DashboardState> emit,
  ) async {
    try {
      final snapshot = await _repository.fetchDashboard();
      emit(DashboardLoaded(snapshot));
    } catch (error) {
      emit(DashboardFailure(error.toString()));
    }
  }
}
