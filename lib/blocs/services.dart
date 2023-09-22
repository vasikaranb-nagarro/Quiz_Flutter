import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quiz_app/blocs/structure.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

Future<List<Quiz>> getQuizzes() async {
  final snapshot = await FirebaseFirestore.instance.collection('quizzes').get();
  return snapshot.docs.map((doc) {
    List<Question> questions = (doc.data()['questions'] as List<dynamic>)
        .map((questionData) => Question(
              questionText: questionData['questionText'],
              options: List<String>.from(questionData['options']),
              correctAnswer: questionData['correctAnswer'],
            ))
        .toList();

    return Quiz(
      id: doc.id,
      title: doc.data()['title'],
      description: doc.data()['description'],
      questions: questions,
    );
  }).toList();
}

Future<List<QuizResult>> getQuizResults() async {
  User? currentUser = FirebaseAuth.instance.currentUser;
  if (currentUser == null) {
    // If no user is logged in, return an empty list
    return [];
  }

  final snapshot = await FirebaseFirestore.instance
      .collection('quiz_results')
      .where('userId', isEqualTo: currentUser.uid) // Filter results by user ID
      .get();

  return snapshot.docs.map((doc) {
    return QuizResult(
      userId: doc['userId'],
      quizId: doc['quizId'],
      quizName: doc['quizName'], // Add the 'quizName' field
      totalQuestions: doc['totalQuestions'], // Add the 'totalQuestions' field
      correctAnswers: doc['correctAnswers'], // Add the 'correctAnswers' field
      wrongAnswers: doc['wrongAnswers'], // Add the 'wrongAnswers' field
      score: doc['score'],
      date: (doc['date'] as Timestamp).toDate(),
    );
  }).toList();
}

Future<String?> fetchProfilePictureUrlFromFirebase(String userEmail) async {
  try {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userEmail)
          .get();
      final String? downloadUrl = snapshot['profilePictureUrl'];
      return downloadUrl;
    }
    return null;
  } catch (e) {
    print('Error fetching profile picture URL: $e');
    return null;
  }
}

Future<void> updateUserProfilePicture(String userId, String imagePath) async {
  try {
    final firebase_storage.Reference storageRef = firebase_storage
        .FirebaseStorage.instance
        .ref()
        .child('profile_pictures/$userId.jpg');

    // Upload the image to Firebase Storage
    await storageRef.putFile(File(imagePath));

    // Once the image is uploaded, get the download URL and update the user's profile picture URL in the database
    final String downloadUrl = await storageRef.getDownloadURL();
    // Add logic to update the user's profile picture URL in the database, for example:
    await FirebaseFirestore.instance.collection('users').doc(userId).set({
      'profilePictureUrl': downloadUrl,
    }, SetOptions(merge: true));
  } catch (e) {
    print('Error updating profile picture: $e');
  }
}

Future<void> saveQuizResultToFirebase(QuizResult quizResult) async {
  try {
    await FirebaseFirestore.instance
        .collection('quiz_results')
        .add(quizResult.toMap());
  } catch (e) {
    print('Error saving quiz result to Firebase: $e');
    // Handle the error as per your requirement (e.g., show a message to the user)
  }
}
