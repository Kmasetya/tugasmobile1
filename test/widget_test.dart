import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:concert_ticket_app/main.dart';

void main() {
  testWidgets('Test dasar: memastikan framework berjalan', (WidgetTester tester) async {
    // Membangun widget sederhana untuk memastikan test runner berjalan tanpa error
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Text('Hello Test'),
        ),
      ),
    );

    // Memverifikasi bahwa teks ditemukan
    expect(find.text('Hello Test'), findsOneWidget);
  });
}
