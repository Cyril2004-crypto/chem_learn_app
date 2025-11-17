import 'package:flutter/material.dart';
import '../widgets/custom_app_bar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Chemistry Home'),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/lessons'),
              child: const Text('Lessons')),
          ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/molecule'),
              child: const Text('Molecule Viewer')),
          ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/quiz'),
              child: const Text('Quizzes')),
          ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/profile'),
              child: const Text('Profile')),
          ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/settings'),
              child: const Text('Settings')),
        ],
      ),
    );
  }
}