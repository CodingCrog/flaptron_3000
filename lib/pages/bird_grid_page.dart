import 'package:flaptron_3000/level/background_nft.dart';
import 'package:flaptron_3000/model/bird_card.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

final List<BirdCard> birds = [
  BirdCard(
    title: 'HatBird',
    subtitle:
        'Donned with a magical hat, this bird starts your journey with style.',
    imageUrl: 'https://raw.seadn.io/files/373c9268ffccf1fae459e7133c4ceca7.gif',
    // 'https://ipfs.io/ipfs/bafybeiefkakrj57ngw4ox3uubjhtvoyti6zb7d7cbyy5quxmqnvcejzzim/1',
    price: 15.99,
    nft:
        'https://opensea.io/assets/matic/0xa2c05e8ed26a14d0c5190c45e9b7e5c650bb6465/1',
  ),
  BirdCard(
    title: 'CoinBird',
    subtitle:
        'Gathers coins with a 1.5x multiplier, a treasure seeker’s best friend.',
    imageUrl: 'https://raw.seadn.io/files/60c51b39331af5c0efc2c4bbc1ea1119.gif',
    //  'https://ipfs.io/ipfs/bafybeigjtmdq4w2twwt4t63h2a6p3azomx7dh3y5llz722mabcnkprxv2e/4',
    price: 12.99,
    nft:
        'https://opensea.io/assets/matic/0xa2c05e8ed26a14d0c5190c45e9b7e5c650bb6465/4/',
  ),
  BirdCard(
    title: 'RedBird',
    subtitle: 'Fierce and fiery, shatters obstacles with unmatched fury.',
    imageUrl: 'https://raw.seadn.io/files/ecda7491a9792e7b5e9cfc88e869a9a0.gif',
    // 'https://ipfs.io/ipfs/bafybeid7zbj3iyj4ypjuo4wwshvkegf52fx45wajqwebgrzqyez77pgcf4/3',
    price: 18.99,
    nft:
        'https://opensea.io/assets/matic/0xa2c05e8ed26a14d0c5190c45e9b7e5c650bb6465/2/',
  ),
  BirdCard(
      title: 'SuperBird',
      subtitle:
          'Unrivalled speed, soaring through challenges at blazing velocities.',
      imageUrl:
          'https://raw.seadn.io/files/75114ecd57c85ef009257a3596238cf8.gif',
      //'https://ipfs.io/ipfs/bafybeigftziffeifqv4mmv4g2ki37hxp7g5yg2wrtmy36wrpmolh77y4jy/2',
      price: 16.99,
      nft:
          'https://opensea.io/assets/matic/0xa2c05e8ed26a14d0c5190c45e9b7e5c650bb6465/3/'),
];

class BirdGridPage extends StatelessWidget {
  BirdGridPage({super.key});

  Future<void> _launchUrl(String filePath) async {
    if (!await launchUrlString(filePath)) {
      throw Exception('Could not launch $filePath');
    }
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
          Column(
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
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(4),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 6,
                    mainAxisSpacing: 6,
                    childAspectRatio: 0.8,
                  ),
                  itemCount: birds.length,
                  itemBuilder: (context, index) {
                    return Stack(
                      children: [
                        Card(
                          elevation: 5,
                          shadowColor: Colors.black.withOpacity(0.5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              SizedBox(
                                height: 100,
                                width: 100,
                                child: Image.network(
                                  birds[index].imageUrl,
                                  fit: BoxFit.contain,
                                  loadingBuilder: (BuildContext context,
                                      Widget child,
                                      ImageChunkEvent? loadingProgress) {
                                    if (loadingProgress == null) {
                                      return child; // return the actual image when fully loaded
                                    } else {
                                      return Center(
                                        child: CircularProgressIndicator(
                                          value: loadingProgress
                                                      .expectedTotalBytes !=
                                                  null
                                              ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  loadingProgress
                                                      .expectedTotalBytes!
                                              : null, // shows actual progress if total size is known
                                        ),
                                      );
                                    }
                                  },
                                  errorBuilder: (context, error, stackTrace) =>
                                      const Center(
                                    child: Text('Failed to load image',
                                        style: TextStyle(color: Colors.red)),
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Center(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(birds[index].title,
                                          style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold)),
                                      const SizedBox(height: 6),
                                      Text(birds[index].subtitle,
                                          style: const TextStyle(fontSize: 14)),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: IconButton(
                            icon: const Icon(Icons.diamond_outlined,
                                color: Colors.pinkAccent),
                            onPressed: () async {
                              await _launchUrl(birds[index].nft);
                            },
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
