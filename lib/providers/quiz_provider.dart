import 'package:flutter/material.dart';
import '../models/quiz.dart';

class QuizProvider extends ChangeNotifier {
  List<QuizQuestion> _questions = [];
  int _currentIndex = 0;
  int _score = 0;

  List<QuizQuestion> get questions => _questions;
  int get currentIndex => _currentIndex;
  int get score => _score;

  void loadQuestions(List<QuizQuestion> qs) {
    _questions = qs;
    _currentIndex = 0;
    _score = 0;
    notifyListeners();
  }

  void loadSampleQuestions() {
    final samples = <QuizQuestion>[
      QuizQuestion(
        id: 'q1',
        question: 'Which subatomic particle has a positive charge?',
        options: ['Electron', 'Proton', 'Neutron', 'Photon'],
        answerIndex: 1,
      ),
      QuizQuestion(
        id: 'q2',
        question: 'What is the chemical formula for water?',
        options: ['H2O', 'CO2', 'O2', 'NaCl'],
        answerIndex: 0,
      ),
      QuizQuestion(
        id: 'q3',
        question: 'Which bond is strongest typically?',
        options: ['Ionic', 'Covalent', 'Hydrogen', 'Van der Waals'],
        answerIndex: 1,
      ),
    ];
    loadQuestions(samples);
  }

  void answer(int selectedIndex) {
    if (_questions.isEmpty) return;
    if (_questions[_currentIndex].answerIndex == selectedIndex) _score++;
    _currentIndex++;
    notifyListeners();
  }

  bool get isFinished => _currentIndex >= _questions.length;
  void reset() {
    _currentIndex = 0;
    _score = 0;
    notifyListeners();
  }
}