import 'package:flutter/material.dart';
import '../models/quiz_model.dart';

class QuestionCard extends StatelessWidget {
  final Question question;
  final bool isAnswered;
  final int? selectedOptionId;
  final Function(int, int) onAnswerSelected;

  const QuestionCard({
    super.key,
    required this.question,
    required this.isAnswered,
    this.selectedOptionId,
    required this.onAnswerSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Text(
                question.description,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
            const SizedBox(height: 24),
            ...question.options.map((option) => Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: _OptionCard(
                    option: option,
                    onTap: () => onAnswerSelected(question.id, option.id),
                    isAnswered: isAnswered,
                    isSelected: selectedOptionId == option.id,
                  ),
                )),
            if (isAnswered && question.detailedSolution != null)
              _SolutionCard(solution: question.detailedSolution!),
          ],
        ),
      ),
    );
  }
}

class _OptionCard extends StatelessWidget {
  final Option option;
  final VoidCallback onTap;
  final bool isAnswered;
  final bool isSelected;

  const _OptionCard({
    super.key,
    required this.option,
    required this.onTap,
    required this.isAnswered,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 500),
      builder: (context, value, child) {
        return Transform.scale(
          scale: 0.9 + (0.1 * value),
          child: child,
        );
      },
      child: Material(
        color: _getBackgroundColor(isAnswered, isSelected, option.isCorrect),
        borderRadius: BorderRadius.circular(15),
        elevation: isSelected ? 4 : 2,
        child: InkWell(
          onTap: isAnswered ? null : onTap,
          borderRadius: BorderRadius.circular(15),
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    option.description,
                    style: TextStyle(
                      fontSize: 16,
                      color: isAnswered && (isSelected || option.isCorrect)
                          ? Colors.white
                          : Colors.black87,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
                if (isAnswered)
                  Icon(
                    option.isCorrect ? Icons.check_circle : Icons.cancel,
                    color: Colors.white,
                    size: 24,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getBackgroundColor(bool isAnswered, bool isSelected, bool isCorrect) {
    if (!isAnswered) {
      return isSelected ? Colors.orange.withOpacity(0.2) : Colors.white;
    }
    if (isCorrect) return Colors.green;
    if (isSelected) return Colors.red;
    return Colors.white;
  }
}

class _SolutionCard extends StatelessWidget {
  final String solution;

  const _SolutionCard({
    super.key,
    required this.solution,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: Theme.of(context).primaryColor.withOpacity(0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.lightbulb,
                color: Theme.of(context).primaryColor,
              ),
              const SizedBox(width: 8),
              Text(
                'Explanation',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            solution,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  height: 1.5,
                ),
          ),
        ],
      ),
    );
  }
}
