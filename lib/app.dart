import 'package:drivado_admin_app/core/theme/app_theme.dart';
import 'package:drivado_admin_app/features/auth/presentation/pages/splash_page.dart';
import 'package:drivado_admin_app/features/bookings/data/repositories/mock_bookings_repository.dart';
import 'package:drivado_admin_app/features/bookings/presentation/bloc/bookings_bloc.dart';
import 'package:drivado_admin_app/features/dashboard/data/repositories/mock_dashboard_repository.dart';
import 'package:drivado_admin_app/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DrivadoAdminApp extends StatelessWidget {
  const DrivadoAdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => DashboardBloc(MockDashboardRepository())
            ..add(const DashboardStarted()),
        ),
        BlocProvider(
          create: (_) => BookingsBloc(MockBookingsRepository())
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
    );
  }
}
