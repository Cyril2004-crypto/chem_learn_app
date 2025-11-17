import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/quiz_provider.dart';

class QuizScreen extends StatelessWidget {
  const QuizScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final qProv = context.watch<QuizProvider>();
    if (qProv.questions.isEmpty) {
      return const Scaffold(body: Center(child: Text('No quiz loaded')));
    }
    if (qProv.isFinished) {
      return Scaffold(
        appBar: AppBar(title: const Text('Quiz finished')),
        body: Center(child: Text('Score: ${qProv.score}/${qProv.questions.length}')),
      );
    }
    final q = qProv.questions[qProv.currentIndex];
    return Scaffold(
      appBar: AppBar(title: Text('Quiz ${qProv.currentIndex + 1}/${qProv.questions.length}')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(q.question),
            const SizedBox(height: 12),
            ...List.generate(q.options.length, (i) {
              return ElevatedButton(onPressed: () => qProv.answer(i), child: Text(q.options[i]));
            })
          ],
        ),
      ),
    );
  }
}