import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:drivado_admin_app/app.dart';

void main() {
  testWidgets('App starts on splash with Drivado logo', (tester) async {
    await tester.pumpWidget(const DrivadoAdminApp());
    await tester.pump();
    expect(find.byType(Image), findsWidgets);
  });
}
