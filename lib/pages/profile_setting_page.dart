import 'package:flaptron_3000/model/bird.dart';
import 'package:flaptron_3000/services/firestore_service.dart';
import 'package:flaptron_3000/utils/shared_pref.dart';
import 'package:flutter/material.dart';
import 'package:gif_view/gif_view.dart';
import 'package:shared_preferences/shared_preferences.dart';


class ProfileSettingsPage extends StatefulWidget {
  final Bird bird;
   const ProfileSettingsPage({super.key, required this.bird});

  @override
  _ProfileSettingsPageState createState() => _ProfileSettingsPageState();
}

class _ProfileSettingsPageState extends State<ProfileSettingsPage> {
  late String profileName;
  late int highScore;


  @override
  void initState() {
    super.initState();
    profileName = LocalStorage.getDisplayName() ?? 'Unknown';
    highScore = LocalStorage.getHighScore();
  }

  Future<void> _deleteProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('displayName');
    await prefs.remove('email');
    await prefs.remove('highScore');
    setState(() {
      profileName = 'Unknown';
      highScore = 0;
    });
    FireStoreService.deleteUser();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile deleted successfully')),
    );
    await LocalStorage.setBool('isLoggedIn', false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Center(
              child: CircleAvatar(
                radius: 50,
                child: ClipOval(
                  child: GifView.asset(
                    widget.bird.gifPath,
                    width: 100,
                    height: 100,
                    frameRate: 10,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Profile Name: $profileName',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'High Score: $highScore',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: _deleteProfile,
              icon: const Icon(Icons.delete),
              label: const Text('Delete Profile'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
