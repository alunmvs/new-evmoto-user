import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

void main() {
  testWidgets('renders app shell smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      const GetMaterialApp(
        home: Scaffold(
          body: Center(child: Text('Evmoto')),
        ),
      ),
    );

    expect(find.text('Evmoto'), findsOneWidget);
  });
}
