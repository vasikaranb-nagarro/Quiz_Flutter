import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class ResultDetailsPage extends StatelessWidget {
  final String score;
  final int totalQuestions;
  final String quizName;
  final String testDate;
  final int correctAnswers;
  final int wrongAnswers;

  const ResultDetailsPage({
    super.key,
    required this.score,
    required this.totalQuestions,
    required this.quizName,
    required this.testDate,
    required this.correctAnswers,
    required this.wrongAnswers
  });

  @override
  Widget build(BuildContext context) {
    int attempted = correctAnswers + wrongAnswers;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Result Details'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 16),
              Card(
                elevation: 4,
                color: Colors.amber,
                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text(
                        'Quiz Name: $quizName',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Test Date: $testDate',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: 200,
                height: 200,
                child: PieChart(
                  PieChartData(
                    sectionsSpace: 2,
                    sections: [
                      PieChartSectionData(
                        value: correctAnswers.toDouble(),
                        color: Colors.green,
                        title: '$correctAnswers',
                      ),
                      PieChartSectionData(
                        value: (totalQuestions - correctAnswers).toDouble(),
                        color: Colors.red,
                        title: '$wrongAnswers',
                      ),
                      PieChartSectionData(
                        value: (totalQuestions - correctAnswers).toDouble(),
                        color: Colors.grey,
                        title: '${totalQuestions - attempted}',
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Score: $score%',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              Text(
                'Total Questions: $totalQuestions',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              Text(
                'Questions Attempted: $attempted',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              Text(
                'Correct Answers: $correctAnswers',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              Text(
                'Wrong Answers: $wrongAnswers',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
