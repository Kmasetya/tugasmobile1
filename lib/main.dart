import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

import 'constants/app_colors.dart';
import 'screens/intro_screen.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/main_screen.dart';
import 'screens/event_detail_screen.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; // UNCOMMENT THIS LATER AFTER RUNNING flutterfire configure

// Concert Ticket App - Refactored to use dynamic mock API and global AppState
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // UNCOMMENT LATER AFTER RUNNING flutterfire configure
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    debugPrint("Firebase init error: $e");
  }
  
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );
  runApp(const ConcertApp());
}

final GoRouter _router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const IntroScreen()),
    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
    GoRoute(path: '/signup', builder: (context, state) => const SignupScreen()),
    GoRoute(path: '/home', builder: (context, state) => const MainScreen()),
    GoRoute(
      path: '/event/:id',
      builder: (context, state) {
        final id = state.pathParameters['id'] ?? '1';
        return EventDetailScreen(eventId: id);
      },
    ),
  ],
);

class ConcertApp extends StatelessWidget {
  const ConcertApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Concert Ticket App',
      debugShowCheckedModeBanner: false,
      routerConfig: _router,
      theme: ThemeData(
        colorScheme: const ColorScheme.dark(
          primary: AppColors.primary,
          surface: AppColors.background,
        ),
        scaffoldBackgroundColor: AppColors.background,
        textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme),
        useMaterial3: true,
      ),
    );
  }
}
