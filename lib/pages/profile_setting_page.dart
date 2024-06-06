import 'package:flaptron_3000/model/player.dart';
import 'package:flaptron_3000/services/firestore_service.dart';
import 'package:flaptron_3000/utils/shared_pref.dart';
import 'package:flutter/material.dart';

class ProfileSettingsPage extends StatefulWidget {
  final PlayerM player;

  const ProfileSettingsPage({super.key, required this.player});

  @override
  _ProfileSettingsPageState createState() => _ProfileSettingsPageState();
}

class _ProfileSettingsPageState extends State<ProfileSettingsPage> {
  late String profileName;
  late int highScore;

  @override
  void initState() {
    super.initState();
    profileName = widget.player.username ?? 'Unknown';
    highScore = widget.player.highScore;
  }

  Future<void> _deleteProfile() async {
    setState(() {
      profileName = 'Unknown';
      highScore = 0;
    });
    FireStoreServiceM().deletePlayer(widget.player);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile deleted successfully')),
    );
    await LocalStorage.removePlayerId();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Center(
              child: CircleAvatar(
                radius: 50,
                child: ClipOval(
                  child: ListenableBuilder(
                    listenable: widget.player,
                    builder: (context, _) => Image.network(
                      widget.player.bird.gifPath,
                      width: 100,
                      height: 100,
                    ),
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
