// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stopwatch/main.dart';

void main() {
  testWidgets('Stopwatch tester not started', (WidgetTester tester) async {
    /// Build our app and trigger a frame.
    await tester.pumpWidget(MyApp());
    expect(find.text('00:00.000'), findsOneWidget);
    expect(find.bySemanticsLabel("0 minutes 0 seconds 0 milliseconds"),
        findsOneWidget);
  });

  testWidgets('Stopwatch tester started and stopped',
      (WidgetTester tester) async {
    /// Build our app and trigger a frame.
    await tester.pumpWidget(MyApp());

    /// Tap the '▶️' icon and wait then press '⏹'.
    await tester.tap(find.byIcon(Icons.play_arrow));
    await tester.pumpAndSettle(const Duration(milliseconds: 1000));
    await tester.tap(find.byIcon(Icons.stop));
    await tester.pumpAndSettle(const Duration(milliseconds: 100));
    expect(find.text('00:00.000'), findsNothing);
  });

  test("Time calculation", () {
    expect(calculateElapsed(0), equals('00:00.000'));
    expect(calculateElapsed(1), equals('00:00.001'));
    expect(calculateElapsed(10), equals('00:00.010'));
    expect(calculateElapsed(100), equals('00:00.100'));
    expect(calculateElapsed(1000), equals('00:01.000'));
    expect(calculateElapsed(10000), equals('00:10.000'));
    expect(calculateElapsed(60000), equals('01:00.000'));
  });

  test("timerInText for semantics label ", () {
    expect(semanticTimeConversion('00:00.000'),
        equals('0 minutes 0 seconds 0 milliseconds'));
    expect(semanticTimeConversion('00:00.001'),
        equals('0 minutes 0 seconds 1 milliseconds'));
    expect(semanticTimeConversion('00:00.010'),
        equals('0 minutes 0 seconds 10 milliseconds'));
    expect(semanticTimeConversion('00:00.100'),
        equals('0 minutes 0 seconds 100 milliseconds'));
    expect(semanticTimeConversion('00:01.000'),
        equals('0 minutes 1 seconds 0 milliseconds'));
    expect(semanticTimeConversion('00:10.000'),
        equals('0 minutes 10 seconds 0 milliseconds'));
    expect(semanticTimeConversion('01:00.000'),
        equals('1 minutes 0 seconds 0 milliseconds'));
  });

  testWidgets('Stopwatch after stop tapped twice', (WidgetTester tester) async {
    /// Build our app and trigger a frame.
    await tester.pumpWidget(MyApp());
    // Tap the '⏹' icon twice.
    await tester.pumpAndSettle(const Duration(milliseconds: 100));
    await tester.tap(find.byIcon(Icons.stop));
    await tester.pumpAndSettle(const Duration(milliseconds: 100));
    expect(find.text('00:00.000'), findsOneWidget);
  });

  testWidgets('Accessibility testing', (WidgetTester tester) async {
    final SemanticsHandle handle = tester.ensureSemantics();
    await tester.pumpWidget(MyApp());

    // Checks that tappable nodes have a minimum size of 48 by 48 pixels
    // for Android.
    await expectLater(tester, meetsGuideline(androidTapTargetGuideline));

    // Checks that tappable nodes have a minimum size of 44 by 44 pixels
    // for iOS.
    await expectLater(tester, meetsGuideline(iOSTapTargetGuideline));

    // Checks that touch targets with a tap or long press action are labeled.
    await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));

    // Checks whether semantic nodes meet the minimum text contrast levels.
    // The recommended text contrast is 3:1 for larger text
    // (18 point and above regular).
    await expectLater(tester, meetsGuideline(textContrastGuideline));
    handle.dispose();
  });
}
