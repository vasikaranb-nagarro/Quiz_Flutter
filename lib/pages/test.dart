import 'package:flutter/material.dart';
import '../blocs/services.dart';
import '../blocs/structure.dart';

class TestPage extends StatefulWidget {
  final List<Question> questions;
  final String id;
  final String userId;

  const TestPage(
      {super.key,
      required this.userId,
      required this.id,
      required this.questions});

  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  int currentQuestionIndex = 0;

  void _selectOption(String option) {
    setState(() {
      widget.questions[currentQuestionIndex].selectedOption = option;
    });
  }

  void _goToPreviousQuestion() {
    setState(() {
      if (currentQuestionIndex > 0) {
        currentQuestionIndex--;
      }
    });
  }

  void _goToNextQuestion() {
    setState(() {
      if (currentQuestionIndex < widget.questions.length - 1) {
        currentQuestionIndex++;
      }
    });
  }

  void _submitTest() {
    int totalQuestions = widget.questions.length;
    int correctAnswers = 0;
    int wrongAnswers = 0;

    for (var question in widget.questions) {
      if (question.selectedOption != null && question.selectedOption == question.correctAnswer) {
        correctAnswers++;
      } else if(question.selectedOption != null){
        wrongAnswers++;
      }
      question.selectedOption= null;
    }

    double finalScore = (correctAnswers * 1) - (wrongAnswers * 0.25);
    finalScore = finalScore < 0 ? 0 : finalScore;
    finalScore = (finalScore / totalQuestions) * 100;

    QuizResult quizResult = QuizResult(
      userId: widget.userId,
      quizId: widget.id,
      quizName: widget.id, // Add the quizName to the QuizResult object
      totalQuestions: totalQuestions,
      correctAnswers: correctAnswers,
      wrongAnswers: wrongAnswers,
      score: finalScore.toStringAsFixed(2),
      date: DateTime.now(),
    );

    saveQuizResultToFirebase(quizResult);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Test Submitted'),
          content: const Text('Access your scores in results page'),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    final question = widget.questions[currentQuestionIndex];
    final isLastQuestion = currentQuestionIndex == widget.questions.length - 1;
    final isFirstQuestion = currentQuestionIndex == 0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Test'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              question.questionText,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            // Options
            for (String option in question.options)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: ElevatedButton(
                  onPressed: () {
                    _selectOption(option);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: question.selectedOption == option
                        ? Colors.blue
                        : Colors.blueGrey,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                  child: Text(
                    option,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (!isFirstQuestion)
                  ElevatedButton(
                    onPressed: _goToPreviousQuestion,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amberAccent,
                    ),
                    child: const Text('Previous'),
                  ),
                if (!isFirstQuestion && !isLastQuestion)
                  const SizedBox(width: 10),
                if (!isLastQuestion)
                  ElevatedButton(
                    onPressed: _goToNextQuestion,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amberAccent,
                    ),
                    child: const Text('Next'),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _submitTest,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.cyan,
              ),
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
