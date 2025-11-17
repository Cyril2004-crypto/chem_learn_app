import 'package:flutter/widgets.dart';
import '../screens/splash_screen.dart';
import '../screens/login_screen.dart';
import '../screens/signup_screen.dart';
import '../screens/home_screen.dart';
import '../screens/lessons_screen.dart';
import '../screens/quiz_screen.dart';
import '../screens/molecule_viewer_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/settings_screen.dart';

final Map<String, WidgetBuilder> appRoutes = {
  '/': (_) => const SplashScreen(),
  '/login': (_) => const LoginScreen(),
  '/signup': (_) => const SignupScreen(),
  '/home': (_) => const HomeScreen(),
  '/lessons': (_) => const LessonsScreen(),
  '/quiz': (_) => const QuizScreen(),
  '/molecule': (_) => const MoleculeViewerScreen(),
  '/profile': (_) => const ProfileScreen(),
  '/settings': (_) => const SettingsScreen(),
};