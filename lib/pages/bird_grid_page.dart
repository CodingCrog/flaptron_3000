import 'package:flaptron_3000/level/background_nft.dart';
import 'package:flaptron_3000/model/nft_model.dart';
import 'package:flaptron_3000/model/player.dart';
import 'package:flaptron_3000/services/game_handler.dart';
import 'package:flaptron_3000/services/nft_service.dart';
import 'package:flaptron_3000/widgets/bouncable.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

final defaultBird = NFTModel(
  name: 'Default Bird',
  description: '',
  contract: '',
  image_url: 'assets/gifs/bird.gif',
  opensea_url: '',
  identifier: '',
  collection: '',
  token_standard: '',
);

extension NFTModelExt on NFTModel {
  bool get isDefault => image_url == defaultBird.image_url;
}

class BirdGridPage extends StatelessWidget {
  const BirdGridPage({super.key, required this.gameHandler});
  final GameHandler gameHandler;

  Future<Map<NFTModel, bool>> _fetchNFTs() async {
    if (gameHandler.player.ethAddress == null) return {};
    final nfts =
        await NFTService.fetchNFTsByETHAddress(gameHandler.player.ethAddress!);
    final allNfts = await NFTService.fetchAllNfts();
    Map<NFTModel, bool> nftMap = {};
    nftMap.putIfAbsent(defaultBird, () => true);
    for (final nft in allNfts ?? []) {
      if (nfts?.any((e) => e.identifier == nft.identifier) == true) {
        nftMap.putIfAbsent(nft, () => true);
      } else {
        nftMap.putIfAbsent(nft, () => false);
      }
    }
    return nftMap;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NFT Bird Gallery'),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          const BackgroundNFT(),
          SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    "Invest in unique NFT Birds! Each bird not only looks great but also offers unique benefits in the Flaptron 3000 universe. Secure your digital asset today.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.blueGrey[900],
                      // Adjust the color to match your theme
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                FutureBuilder<Map<NFTModel, bool>>(
                    future: _fetchNFTs(),
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
                      final count = MediaQuery.of(context).size.width ~/
                          BirdCardWidget.width;
                      final children = nfts?.entries.map((e) {
                        final nft = e.key;
                        final isOwned = e.value;
                        return BirdCardWidget(
                          nft: nft,
                          isOwned: isOwned,
                          player: gameHandler.player,
                        );
                      }).toList();
                      return GridView.count(
                          primary: false,
                          crossAxisCount: count,
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          children: children ?? []);
                    }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class BirdCardWidget extends StatelessWidget {
  const BirdCardWidget({
    super.key,
    required this.nft,
    required this.isOwned,
    required this.player,
  });

  final NFTModel nft;
  final bool isOwned;
  final PlayerM player;
  static double width = 200;
  static double height = 200;

  Future<void> _launchUrl(String filePath) async {
    if (!await launchUrlString(nft.opensea_url)) {
      throw Exception('Could not launch $filePath');
    }
  }

  @override
  Widget build(BuildContext context) {
    final Widget image;
    if (nft.isDefault) {
      image = Image.asset(nft.image_url);
    } else {
      image = Image.network(nft.image_url);
    }
    return ListenableBuilder(
        listenable: player,
        builder: (context, _) {
          final isSelected = nft.image_url == player.bird.gifPath;
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Bounceable(
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white54,
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                        offset: Offset(0, 0),
                      ),
                    ],
                    border: Border.all(
                        width: 2,
                        color: isSelected
                            ? Colors.orangeAccent
                            : Colors.transparent)),
                height: height,
                width: width,
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Expanded(child: image),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(nft.name,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(nft.description, style: const TextStyle(fontSize: 14)),
                    const SizedBox(height: 4),
                    Bounceable(
                      onTap: () {
                        if (isOwned) {
                          if (isSelected) return;
                          player.updateBird(nft.image_url);
                        } else {
                          _launchUrl(nft.opensea_url);
                        }
                      },
                      child: Container(
                        width: double.infinity,
                        height: 30,
                        decoration: BoxDecoration(
                            color: isSelected ? Colors.blueGrey : Colors.amber,
                            borderRadius: BorderRadius.circular(10)),
                        child: Center(
                          child: Text(
                            isOwned
                                ? isSelected
                                    ? 'Selected'
                                    : 'Select'
                                : 'Buy',
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }
}

extension WidgetExt on Widget {
  Widget wrapIf(bool condition, Widget Function(Widget child) builder) {
    return condition ? builder(this) : this;
  }
}
