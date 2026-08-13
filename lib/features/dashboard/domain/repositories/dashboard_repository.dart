import 'package:drivado_admin_app/features/dashboard/domain/entities/dashboard_entities.dart';

abstract class DashboardRepository {
  Future<DashboardSnapshot> fetchDashboard();
}
