import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../blocs/services.dart';
import '../blocs/structure.dart';
import '../pages/result_detail.dart';

class ResultsTabContent extends StatelessWidget {
  const ResultsTabContent({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<QuizResult>>(
      future: getQuizResults(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('Error fetching results'));
        } else {
          final results = snapshot.data;
          if (results == null || results.isEmpty) {
            return const Center(child: Text('No results available'));
          } else {
            return ListView.builder(
              itemCount: results.length,
              itemBuilder: (context, index) {
                final result = results[index];
                return ListTile(
                  title: Text('Quiz ID: ${result.quizId}'),
                  subtitle:
                      Text('Score: ${result.score}, Date: ${result.date}'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ResultDetailsPage(
                            score: result.score,
                            totalQuestions: 5,
                            quizName: result.quizId,
                            testDate:
                                DateFormat('yyyy-MM-dd').format(result.date),
                            correctAnswers : result.correctAnswers,
                            wrongAnswers: result.wrongAnswers,
                        )
                      ),
                    );
                  },
                );
              },
            );
          }
        }
      },
    );
  }
}
