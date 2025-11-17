import 'package:flutter/material.dart';
import '../providers/lesson_provider.dart';
import 'package:provider/provider.dart';
import '../widgets/lesson_card.dart';

class LessonsScreen extends StatelessWidget {
  const LessonsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final lessons = context.watch<LessonProvider>().lessons;
    return Scaffold(
      appBar: AppBar(title: const Text('Lessons')),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: lessons.length,
        itemBuilder: (ctx, i) => LessonCard(lesson: lessons[i]),
      ),
    );
  }
}