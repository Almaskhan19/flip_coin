import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flip_coin/main.dart';

void main() {
  testWidgets('Coin flip shows the matching side when the animation finishes', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const CoinFlipApp());

    expect(find.text('Flip a Coin'), findsOneWidget);
    expect(find.text('Tap to Flip!'), findsOneWidget);
    expect(find.text('HEADS'), findsOneWidget);
    expect(find.text('Flip Now'), findsOneWidget);

    await tester.tap(find.text('Flip Now'));
    await tester.pump();

    expect(find.text('Flipping...'), findsOneWidget);
    expect(tester.widget<ElevatedButton>(find.byType(ElevatedButton)).onPressed, isNull);

    await tester.pump(const Duration(milliseconds: 1100));
    await tester.pumpAndSettle();

    final headsWon = find.text('Heads!').evaluate().isNotEmpty;
    expect(headsWon || find.text('Tails!').evaluate().isNotEmpty, isTrue);
    expect(find.text(headsWon ? 'HEADS' : 'TAILS'), findsOneWidget);
    expect(tester.widget<ElevatedButton>(find.byType(ElevatedButton)).onPressed, isNotNull);
  });
}
