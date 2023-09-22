import 'package:flutter/material.dart';

import '../blocs/structure.dart';
import '../pages/test.dart';

class QuizTabContent extends StatelessWidget {
  final List<Quiz> quizzes;
  final String userId;

  const QuizTabContent(
      {super.key, required this.userId, required this.quizzes});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: quizzes.length,
      itemBuilder: (context, index) {
        final quiz = quizzes[index];
        return ListTile(
          title: Text(quiz.title),
          subtitle: Text(quiz.description),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TestPage(
                    userId: userId, id: quiz.title, questions: quiz.questions),
              ),
            );
          },
        );
      },
    );
  }
}
