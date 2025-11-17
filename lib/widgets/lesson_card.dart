import 'package:flutter/material.dart';
import '../models/lesson.dart';
import '../screens/lesson_detail_screen.dart';

class LessonCard extends StatelessWidget {
  final Lesson lesson;
  const LessonCard({super.key, required this.lesson});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(lesson.title),
        subtitle: Text(lesson.displayType()),
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => LessonDetailScreen(lesson: lesson))),
      ),
    );
  }
}