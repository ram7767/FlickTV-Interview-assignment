import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ram/main.dart';

void main() {
  testWidgets('app starts without errors', (tester) async {
    await tester.pumpWidget(const FlickTvAssignmentApp());
    await tester.pump();
    expect(tester.takeException(), isNull);
    await tester.pump(const Duration(seconds: 5));
    await tester.pumpAndSettle();
  });

  testWidgets('app renders a Scaffold on launch', (tester) async {
    await tester.pumpWidget(const FlickTvAssignmentApp());
    await tester.pump();
    expect(find.byType(Scaffold), findsOneWidget);
    await tester.pump(const Duration(seconds: 5));
    await tester.pumpAndSettle();
  });
}
