import 'package:ai_hairstyle_preview_app/providers/theme_provider.dart';
import 'package:ai_hairstyle_preview_app/screens/auth_wrapper.dart';
import 'package:ai_hairstyle_preview_app/screens/onboarding_screen.dart';
import 'package:ai_hairstyle_preview_app/screens/splash_screen.dart';
import 'package:ai_hairstyle_preview_app/utils/app_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ai_hairstyle_preview_app/firebase_options.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ai_hairstyle_preview_app/services/notification_service.dart';
import 'package:timezone/data/latest_all.dart' as tz;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  tz.initializeTimeZones();
  await NotificationService().initNotifications();
  await NotificationService().scheduleDailyTip();
  
  try {
     await Firebase.initializeApp(
       options: DefaultFirebaseOptions.currentPlatform,
     );
  } catch (e) {
    debugPrint("Firebase initialization failed: $e");
    runApp(MaterialApp(
      home: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text("Firebase Initialization Failed:\n$e", textAlign: TextAlign.center),
          ),
        ),
      ),
    ));
    return;
  }

  final prefs = await SharedPreferences.getInstance();
  final bool seenOnboarding = prefs.getBool('seenOnboarding') ?? false;

  runApp(ProviderScope(child: MyApp(seenOnboarding: seenOnboarding)));
}

class MyApp extends ConsumerWidget {
  final bool seenOnboarding;
  const MyApp({super.key, required this.seenOnboarding});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);

    return MaterialApp(
      title: 'StyleAI',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      home: SplashScreen(seenOnboarding: seenOnboarding),
    );
  }
}
