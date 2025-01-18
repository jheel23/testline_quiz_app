import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/quiz_provider.dart';
import '../widgets/question_card.dart';
import '../widgets/progress_bar.dart';
import 'results_screen.dart';

class QuizScreen extends ConsumerStatefulWidget {
  const QuizScreen({super.key});

  @override
  ConsumerState<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends ConsumerState<QuizScreen> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final quizState = ref.watch(quizProvider);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).primaryColor.withOpacity(0.1),
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: quizState.quiz.when(
            loading: () => const Center(
              child: CircularProgressIndicator(),
            ),
            error: (error, stack) => Center(
              child: Text('Error: $error'),
            ),
            data: (quiz) {
              if (quizState.isCompleted) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (_) => const ResultsScreen(),
                    ),
                  );
                });
              }

              return Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Text(
                              quiz.title ?? 'Quiz',
                              style: Theme.of(context).textTheme.titleLarge,
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              quiz.topic,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color: Colors.grey[600],
                                  ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      ProgressBar(
                        progress:
                            quizState.userAnswers.length / quiz.questionsCount,
                        total: quiz.questionsCount,
                      ),
                      Expanded(
                        child: PageView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          controller: _pageController,
                          itemCount: quiz.questions.length,
                          itemBuilder: (context, index) {
                            final question = quiz.questions[index];
                            final isAnswered =
                                quizState.userAnswers.containsKey(question.id);
                            return QuestionCard(
                              question: question,
                              isAnswered: isAnswered,
                              selectedOptionId:
                                  quizState.userAnswers[question.id],
                              onAnswerSelected: (questionId, optionId) {
                                ref.read(quizProvider.notifier).answerQuestion(
                                      questionId,
                                      optionId,
                                    );
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  if (quizState.userAnswers.containsKey(
                      quiz.questions[quizState.currentQuestionIndex].id))
                    GestureDetector(
                      onTap: () {
                        ref.read(quizProvider.notifier).moveToNextQuestion();
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      },
                      child: Container(
                          margin: const EdgeInsets.fromLTRB(0, 0, 30, 30),
                          padding: const EdgeInsets.all(15),
                          decoration: const BoxDecoration(boxShadow: [
                            BoxShadow(
                              color: Colors.black38,
                              blurRadius: 10,
                              offset: Offset(0, 0),
                            ),
                          ], color: Colors.orange, shape: BoxShape.circle),
                          child: const Icon(
                            Icons.arrow_forward,
                            color: Colors.white,
                            size: 35,
                          )),
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
