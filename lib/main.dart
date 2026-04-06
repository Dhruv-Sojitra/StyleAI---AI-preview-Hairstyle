import 'package:ai_hairstyle_preview_app/firebase_options.dart';
import 'package:ai_hairstyle_preview_app/providers/theme_provider.dart';
import 'package:ai_hairstyle_preview_app/screens/splash_screen.dart';
import 'package:ai_hairstyle_preview_app/services/notification_service.dart';
import 'package:ai_hairstyle_preview_app/utils/app_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest_all.dart' as tz;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    tz.initializeTimeZones();
    await NotificationService().initNotifications();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    debugPrint("Early initialization error: $e");
  }

  runApp(const ProviderScope(child: StyleAIApp()));
}

class StyleAIApp extends ConsumerWidget {
  const StyleAIApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);

    return MaterialApp(
      title: 'StyleAI',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      home: const InitializationWrapper(),
    );
  }
}

class InitializationWrapper extends StatefulWidget {
  const InitializationWrapper({super.key});

  @override
  State<InitializationWrapper> createState() => _InitializationWrapperState();
}

class _InitializationWrapperState extends State<InitializationWrapper> {
  String _status = "Starting StyleAI...";
  bool _hasError = false;
  String _errorMessage = "";

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));

      setState(() => _status = "Checking Services...");

      if (Firebase.apps.isEmpty) {
        await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        ).timeout(const Duration(seconds: 10));
      }

      setState(() => _status = "Loading Preferences...");
      final prefs = await SharedPreferences.getInstance();
      final bool seenOnboarding = prefs.getBool('seenOnboarding') ?? false;

      if (!mounted) return;

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => SplashScreen(seenOnboarding: seenOnboarding),
        ),
      );
    } catch (e) {
      if (mounted) {
        setState(() {
          _hasError = true;
          _errorMessage = e.toString();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_hasError) {
      return Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  color: Colors.redAccent,
                  size: 80,
                ),
                const SizedBox(height: 24),
                const Text(
                  "Startup Failed",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Text(
                  _errorMessage,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.redAccent),
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () => _initialize(),
                  child: const Text("Retry"),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(color: Colors.blueAccent),
            const SizedBox(height: 24),
            Text(
              _status,
              style: const TextStyle(fontSize: 18, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
