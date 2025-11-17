class QuizQuestion {
  final String id;
  final String question;
  final List<String> options;
  final int answerIndex;

  QuizQuestion({required this.id, required this.question, required this.options, required this.answerIndex});

  Map<String, dynamic> toMap() => {'id': id, 'question': question, 'options': options, 'answerIndex': answerIndex};
}