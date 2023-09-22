import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/user_bloc.dart';
import '../main.dart';

class AppDrawer extends StatelessWidget {
  final String userEmail;
  final String? profilePictureUrl;
  final VoidCallback onProfilePictureTap;

  const AppDrawer(
      this.userEmail, this.profilePictureUrl, this.onProfilePictureTap,
      {super.key});
  @override
  Widget build(BuildContext context) {
    imageCache.clear();
    imageCache.clearLiveImages();
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.amber,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: onProfilePictureTap,
                  child: profilePictureUrl != ""
                      ? ClipOval(
                          child: Image.network(
                            profilePictureUrl!,
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                            loadingBuilder: (BuildContext context, Widget child,
                                ImageChunkEvent? loadingProgress) {
                              if (loadingProgress == null) {
                                return child;
                              }
                              return Center(
                                child: CircularProgressIndicator(
                                  color: Colors.grey,
                                  value: loadingProgress.expectedTotalBytes !=
                                          null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                      : null,
                                ),
                              );
                            },
                          ),
                        )
                      : const Icon(
                          Icons.account_circle,
                          size: 60,
                          color: Colors.grey,
                        ),
                ),
                const SizedBox(height: 8),
                Text(
                  userEmail,
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.contacts),
            title: const Text('Contact Us'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('About Us'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text('Logout'),
            onTap: () {
              BlocProvider.of<UserBloc>(context).add(UserLogout());
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const AuthScreen()),
                (route) => false,
              );
            },
          ),
        ],
      ),
    );
  }
}
