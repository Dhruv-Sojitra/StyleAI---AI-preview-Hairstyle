import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ai_hairstyle_preview_app/main.dart';

void main() {
  testWidgets('Core initialization smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: StyleAIApp()));

    expect(find.byType(InitializationWrapper), findsOneWidget);

    expect(find.textContaining('Starting StyleAI...'), findsOneWidget);

    // Wait for InitializationWrapper to complete (500ms delay + navigation)
    await tester.pump(const Duration(milliseconds: 600));
    await tester.pumpAndSettle();

    expect(find.text('StyleAI'), findsOneWidget);
    expect(find.text('Smart Hairstyle Preview'), findsOneWidget);
    expect(find.text('AI Powered Hair Transformation'), findsOneWidget);

    await tester.pump(const Duration(seconds: 4));
    await tester.pumpAndSettle();
  });
}
