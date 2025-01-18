import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/quiz_model.dart';

class QuizState {
  final AsyncValue<Quiz> quiz;
  final int currentQuestionIndex;
  final Map<int, int> userAnswers; // questionId -> selectedOptionId
  final bool isCompleted;

  QuizState({
    this.quiz = const AsyncValue.loading(),
    this.currentQuestionIndex = 0,
    this.userAnswers = const {},
    this.isCompleted = false,
  });

  QuizState copyWith({
    AsyncValue<Quiz>? quiz,
    int? currentQuestionIndex,
    Map<int, int>? userAnswers,
    bool? isCompleted,
  }) {
    return QuizState(
      quiz: quiz ?? this.quiz,
      currentQuestionIndex: currentQuestionIndex ?? this.currentQuestionIndex,
      userAnswers: userAnswers ?? this.userAnswers,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  int get correctAnswers {
    int count = 0;
    quiz.whenData((quizData) {
      userAnswers.forEach((questionId, optionId) {
        final question =
            quizData.questions.firstWhere((q) => q.id == questionId);
        final selectedOption =
            question.options.firstWhere((o) => o.id == optionId);
        if (selectedOption.isCorrect) count++;
      });
    });
    return count;
  }

  double get accuracy {
    if (userAnswers.isEmpty) return 0.0;
    return (correctAnswers / userAnswers.length) * 100;
  }
}

final quizProvider = StateNotifierProvider<QuizNotifier, QuizState>((ref) {
  return QuizNotifier();
});

class QuizNotifier extends StateNotifier<QuizState> {
  QuizNotifier() : super(QuizState()) {
    fetchQuiz();
  }

  Future<void> fetchQuiz() async {
    try {
      state = state.copyWith(quiz: const AsyncValue.loading());
      final response =
          await http.get(Uri.parse('https://api.jsonserve.com/Uw5CrX'));

      if (response.statusCode == 200) {
        final quizData = json.decode(response.body);
        final quiz = Quiz.fromJson(quizData);
        state = state.copyWith(quiz: AsyncValue.data(quiz));
      } else {
        throw Exception('Failed to load quiz');
      }
    } catch (e) {
      state = state.copyWith(
        quiz: AsyncValue.error(e, StackTrace.current),
      );
    }
  }

  void answerQuestion(int questionId, int optionId) {
    if (state.userAnswers.containsKey(questionId)) return;

    final newAnswers = Map<int, int>.from(state.userAnswers)
      ..[questionId] = optionId;

    state.quiz.whenData((quiz) {
      state = state.copyWith(
        userAnswers: newAnswers,
        isCompleted: newAnswers.length == quiz.questions.length,
      );
    });
  }

  void moveToNextQuestion() {
    state.quiz.whenData((quiz) {
      if (state.currentQuestionIndex < quiz.questions.length - 1) {
        state = state.copyWith(
          currentQuestionIndex: state.currentQuestionIndex + 1,
        );
      } else {
        state = state.copyWith(isCompleted: true);
      }
    });
  }

  void restartQuiz() {
    state = QuizState(quiz: state.quiz);
    fetchQuiz();
  }
}
