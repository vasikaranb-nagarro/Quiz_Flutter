import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quiz_app/components/quiz.dart';
import 'package:quiz_app/components/results.dart';

import '../blocs/services.dart';
import '../blocs/structure.dart';
import '../components/drawer.dart';

class HomeScreen extends StatefulWidget {
  late final String userEmail;
  String profilePictureUrl;
  String userId;

  HomeScreen(this.userId, this.userEmail, this.profilePictureUrl, {super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Quiz> quizzes = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    fetchQuizzes();
  }

  void updateProfilePicture(String newUrl) {
    setState(() {
      widget.profilePictureUrl = newUrl;
    });
  }

  Future<void> _handleProfilePictureTap() async {
    final ImagePicker picker = ImagePicker();

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from Gallery'),
              onTap: () async {
                Navigator.pop(context);
                final XFile? pickedFile =
                    await picker.pickImage(source: ImageSource.gallery);
                if (pickedFile != null) {
                  await updateUserProfilePicture(
                      widget.userEmail, pickedFile.path);
                  var url = await fetchProfilePictureUrlFromFirebase(widget.userEmail);
                  updateProfilePicture("");
                  updateProfilePicture(url ?? "");
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Take a Photo'),
              onTap: () async {
                Navigator.pop(context);
                final XFile? pickedFile =
                    await picker.pickImage(source: ImageSource.camera);
                if (pickedFile != null) {
                  await updateUserProfilePicture(
                      widget.userEmail, pickedFile.path);
                  var url = await fetchProfilePictureUrlFromFirebase(widget.userEmail);
                  updateProfilePicture("");
                  updateProfilePicture(url ?? "");
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> fetchQuizzes() async {
    List<Quiz> fetchedQuizzes = await getQuizzes();
    setState(() {
      quizzes = fetchedQuizzes;
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz App Home'),
      ),
      drawer: AppDrawer(
        widget.userEmail,
        widget.profilePictureUrl,
        _handleProfilePictureTap,
      ),
      body: Column(
        children: [
          TabBar(
            controller: _tabController,
            labelColor: Colors.orange,
            labelStyle: const TextStyle(fontWeight: FontWeight.bold),
            tabs: const [
              Tab(text: 'Quiz'),
              Tab(text: 'Results'),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Quiz Tab Content
                QuizTabContent(userId: widget.userId, quizzes: quizzes),
                // Results Tab Content
                const ResultsTabContent(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
