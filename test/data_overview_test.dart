import 'package:flutter_test/flutter_test.dart';
import 'package:recycling/app.dart';

void main() {
  testWidgets('Overview smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      const App(),
    );

    // Finish async init
    await tester.pumpAndSettle();

    // If everything works as intended, no errors have occurred and no test data was found
    expect(find.textContaining("error occurred"), findsNothing);
    expect(find.textContaining("Ein Fehler ist"), findsNothing);
    expect(find.textContaining('SingleTest'), findsNothing);
  });
}
