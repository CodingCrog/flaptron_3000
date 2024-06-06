import 'package:flaptron_3000/level/background_ranking.dart';
import 'package:flutter/material.dart';
import 'package:flaptron_3000/model/player.dart';
import 'package:flaptron_3000/services/firestore_service.dart';

class RankingPage extends StatefulWidget {
  final String currentUserId;

  const RankingPage({required this.currentUserId, Key? key}) : super(key: key);

  @override
  RankingPageState createState() => RankingPageState();
}

class RankingPageState extends State<RankingPage> {
  late Future<List<PlayerM>> _playersFuture;

  @override
  void initState() {
    super.initState();
    _playersFuture = FireStoreServiceM().getTopPlayers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ranking',
            style: TextStyle(
                color: Colors.black54,
                fontSize: 30.0,
                fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.white70,
      ),
      body: FutureBuilder<List<PlayerM>>(
        future: _playersFuture,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return const Center(child: CircularProgressIndicator());
            case ConnectionState.done:
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }
              return _buildPlayerList(snapshot.data!);
            default:
              return const BackgroundRanking();
          }
        },
      ),
    );
  }

  Widget _buildPlayerList(List<PlayerM> players) {
    return Stack(
      children: [
        const BackgroundRanking(),
        ListView.separated(
          itemCount: players.length,
          separatorBuilder: (context, index) => const Divider(
            thickness: 0.6,
          ),
          itemBuilder: (context, index) {
            final player = players[index];
            return Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal:  16.0),
              child: Container(
                color: player.id == widget.currentUserId
                    ? Colors.yellow[200]
                    : null,
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 2.0, vertical: 2.0),
                  leading: CircleAvatar(
                    backgroundColor: Colors.white,
                    backgroundImage: NetworkImage(player.bird.gifPath),
                    radius: 30.0,
                  ),
                  title: Row(
                    children: [
                      if (index == 0)
                        const Icon(Icons.emoji_events, color: Colors.yellow),
                      Text(
                        player.username,
                        style: const TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black54),
                      ),
                    ],
                  ),
                  subtitle: Text(
                    'Highscore: ${player.highScore}',
                    style: const TextStyle(fontSize: 16.0),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '#${index + 1}',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: index < 3
                              ? Colors.orange.shade500
                              : Colors.blueGrey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
