import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'services/cache_service.dart';
import 'services/auth_service.dart';
import 'services/chemistry_api_service.dart';
import 'providers/auth_provider.dart';
import 'providers/lesson_provider.dart';
import 'providers/quiz_provider.dart';
import 'providers/api_provider.dart';
import 'utils/routes.dart';
import 'utils/theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Firebase removed — not initializing here
  await CacheService.init();
  runApp(const ChemLearnApp());
}

class ChemLearnApp extends StatelessWidget {
  const ChemLearnApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider(AuthService())),
        ChangeNotifierProvider(create: (_) {
          final lp = LessonProvider();
          lp.seedSampleLessons();
          return lp;
        }),
        ChangeNotifierProvider(create: (_) {
          final qp = QuizProvider();
          qp.loadSampleQuestions();
          return qp;
        }),
        ChangeNotifierProvider(create: (_) => ApiProvider(ChemistryApiService())),
      ],
      child: MaterialApp(
        title: 'chem_learn_app',
        theme: appTheme,
        routes: appRoutes,
        initialRoute: '/home',
      ),
    );
  }
}
