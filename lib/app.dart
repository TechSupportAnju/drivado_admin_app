import 'package:drivado_admin_app/core/theme/app_theme.dart';
import 'package:drivado_admin_app/features/affiliates/data/repositories/mock_affiliates_repository.dart';
import 'package:drivado_admin_app/features/affiliates/domain/repositories/affiliates_repository.dart';
import 'package:drivado_admin_app/features/auth/presentation/pages/splash_page.dart';
import 'package:drivado_admin_app/features/bookings/data/repositories/mock_bookings_repository.dart';
import 'package:drivado_admin_app/features/bookings/domain/repositories/bookings_repository.dart';
import 'package:drivado_admin_app/features/bookings/presentation/bloc/bookings_bloc.dart';
import 'package:drivado_admin_app/features/coupons/data/repositories/mock_coupons_repository.dart';
import 'package:drivado_admin_app/features/coupons/domain/repositories/coupons_repository.dart';
import 'package:drivado_admin_app/features/dashboard/data/repositories/mock_dashboard_repository.dart';
import 'package:drivado_admin_app/features/dashboard/domain/repositories/dashboard_repository.dart';
import 'package:drivado_admin_app/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:drivado_admin_app/features/events/data/repositories/mock_events_repository.dart';
import 'package:drivado_admin_app/features/events/domain/repositories/events_repository.dart';
import 'package:drivado_admin_app/features/new_booking/data/repositories/mock_booking_catalog_repository.dart';
import 'package:drivado_admin_app/features/new_booking/domain/repositories/booking_catalog_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DrivadoAdminApp extends StatelessWidget {
  const DrivadoAdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<DashboardRepository>(
          create: (_) => MockDashboardRepository(),
        ),
        RepositoryProvider<BookingsRepository>(
          create: (_) => MockBookingsRepository(),
        ),
        RepositoryProvider<AffiliatesRepository>(
          create: (_) => MockAffiliatesRepository(),
        ),
        RepositoryProvider<CouponsRepository>(
          create: (_) => MockCouponsRepository(),
        ),
        RepositoryProvider<EventsRepository>(
          create: (_) => MockEventsRepository(),
        ),
        RepositoryProvider<BookingCatalogRepository>(
          create: (_) => MockBookingCatalogRepository(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) =>
                DashboardBloc(context.read<DashboardRepository>())
                  ..add(const DashboardStarted()),
          ),
          BlocProvider(
            create: (context) =>
                BookingsBloc(context.read<BookingsRepository>())
                  ..add(const BookingsStarted()),
          ),
        ],
        child: MaterialApp(
          title: 'Drivado Admin',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          builder: (context, child) {
            return DefaultTextStyle(
              style: Theme.of(context).textTheme.bodyMedium!,
              child: child ?? const SizedBox.shrink(),
            );
          },
          home: const SplashPage(),
        ),
      ),
    );
  }
}
