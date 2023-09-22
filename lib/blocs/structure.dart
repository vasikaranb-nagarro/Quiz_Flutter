class Quiz {
  final String id;
  final String title;
  final String description;
  final List<Question> questions;

  Quiz({
    required this.id,
    required this.title,
    required this.description,
    required this.questions,
  });
}

class Question {
  final String questionText;
  final List<String> options;
  final String correctAnswer;
  String? selectedOption;

  Question({
    required this.questionText,
    required this.options,
    required this.correctAnswer,
    this.selectedOption,
  });
}

class QuizResult {
  final String userId;
  final String quizId;
  final String quizName;
  final int totalQuestions;
  final int correctAnswers;
  final int wrongAnswers;
  final String score;
  final DateTime date;

  QuizResult({
    required this.userId,
    required this.quizId,
    required this.quizName,
    required this.totalQuestions,
    required this.correctAnswers,
    required this.wrongAnswers,
    required this.score,
    required this.date,
  });

  // Add the toMap method here to convert QuizResult to a map
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'quizId': quizId,
      'quizName': quizName,
      'totalQuestions': totalQuestions,
      'correctAnswers': correctAnswers,
      'wrongAnswers': wrongAnswers,
      'score': score,
      'date': date,
    };
  }
}

