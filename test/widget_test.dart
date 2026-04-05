import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ai_hairstyle_preview_app/main.dart';

void main() {
  testWidgets('Core initialization smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ProviderScope(child: StyleAIApp()));

    // Verify that the InitializationWrapper is displayed.
    expect(find.byType(InitializationWrapper), findsOneWidget);
    
    // Check for diagnostic status
    expect(find.textContaining('Starting StyleAI...'), findsOneWidget);
    
    // Check for branded elements
    expect(find.text('StyleAI'), findsOneWidget);
    expect(find.text('Smart Hairstyle Preview'), findsOneWidget);
    expect(find.text('AI Powered Hair Transformation'), findsOneWidget);

    // Pump to settle the timer and navigation
    await tester.pump(const Duration(seconds: 4));
    await tester.pumpAndSettle();
  });
}
