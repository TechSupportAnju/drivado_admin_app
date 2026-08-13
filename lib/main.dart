import 'package:drivado_admin_app/app.dart';
import 'package:drivado_admin_app/core/session/session_store.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SessionStore.instance.init();
  runApp(const DrivadoAdminApp());
}
