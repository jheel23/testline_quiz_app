class Quiz {
  final int id;
  final String? title;
  final String description;
  final String topic;
  final int questionsCount;
  final List<Question> questions;
  final double progress;

  Quiz({
    required this.id,
    this.title,
    required this.description,
    required this.topic,
    required this.questionsCount,
    required this.questions,
    required this.progress,
  });

  factory Quiz.fromJson(Map<String, dynamic> json) {
    return Quiz(
      id: json['id'] ?? 0,
      title: json['title'],
      description: json['description'] ?? '',
      topic: json['topic'] ?? '',
      questionsCount: json['questions_count'] ?? 0,
      questions:
          (json['questions'] as List).map((q) => Question.fromJson(q)).toList(),
      progress: json['progress']?.toDouble() ?? 0.0,
    );
  }
}

class Question {
  final int id;
  final String description;
  final String? detailedSolution;
  final List<Option> options;
  bool isAnswered;

  Question({
    required this.id,
    required this.description,
    this.detailedSolution,
    required this.options,
    this.isAnswered = false,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'] ?? 0,
      description: json['description'] ?? '',
      detailedSolution: json['detailed_solution'],
      options:
          (json['options'] as List).map((o) => Option.fromJson(o)).toList(),
    );
  }
}

class Option {
  final int id;
  final String description;
  final bool isCorrect;

  Option({
    required this.id,
    required this.description,
    required this.isCorrect,
  });

  factory Option.fromJson(Map<String, dynamic> json) {
    return Option(
      id: json['id'] ?? 0,
      description: json['description'] ?? '',
      isCorrect: json['is_correct'] ?? false,
    );
  }
}
