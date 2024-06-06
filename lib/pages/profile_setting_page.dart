import 'package:flaptron_3000/model/nft_model.dart';
import 'package:flaptron_3000/model/player.dart';
import 'package:flaptron_3000/services/firestore_service.dart';
import 'package:flaptron_3000/services/nft_service.dart';
import 'package:flaptron_3000/utils/shared_pref.dart';
import 'package:flaptron_3000/widgets/bouncable.dart';
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
            if (widget.player.ethAddress != null) ...[
              FutureBuilder<List<NFTModel>?>(
                  future: NFTService.fetchNFTsByETHAddress(
                      widget.player.ethAddress!),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const SizedBox(
                          height: 100,
                          width: double.infinity,
                          child: Center(child: CircularProgressIndicator()));
                    } else if (snapshot.hasError) {
                      return const Center(child: Text('Error'));
                    }
                    final nfts = snapshot.data;
                    final count =
                        MediaQuery.of(context).size.width ~/ NFTWidget.width;
                    return GridView.count(
                        primary: false,
                        crossAxisCount: count,
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        children: nfts
                                ?.map(
                                  (e) => NFTWidget(
                                    nft: e,
                                    player: widget.player,
                                  ),
                                )
                                .toList() ??
                            []);
                  }),
              const SizedBox(height: 30),
            ],
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

class NFTWidget extends StatelessWidget {
  const NFTWidget({super.key, required this.nft, required this.player});

  final NFTModel nft;
  final PlayerM player;
  static double width = 150;
  static double height = 150;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
        listenable: player,
        builder: (context, _) {
          final isSelected = nft.image_url == player.bird.gifPath;
          return Bounceable(
            onTap: () {
              if (isSelected) return;
              player.updateBird(nft.image_url);
            },
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                      width: 1.5,
                      color: isSelected
                          ? Colors.orangeAccent
                          : Colors.transparent)),
              height: height,
              width: width,
              child: Column(
                children: [
                  Expanded(
                    child: Image.network(
                      nft.image_url,
                      width: 80,
                      height: 80,
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    nft.name,
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(
                    height: 2.5,
                  ),
                  Text(nft.description),
                ],
              ),
            ),
          );
        });
  }
}
