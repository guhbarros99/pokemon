import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:pokemon/main.dart';

void main() {
  testWidgets('App renders Pokédex', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: PokedexPage(),
      ),
    );

    // Verifica se o título da Pokédex aparece
    expect(find.text("Pokédex"), findsOneWidget);
  });
}
