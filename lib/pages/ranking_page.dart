import 'package:flutter/material.dart';
import 'package:flaptron_3000/model/player.dart';
import 'package:flaptron_3000/services/firestore_service.dart';

class RankingPage extends StatefulWidget {
  final String currentUserId;

  const RankingPage({required this.currentUserId, super.key});

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
        title: const Text('Ranking', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blueGrey,
      ),
      body: FutureBuilder<List<PlayerM>>(
        future: _playersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final players = snapshot.data!;

            return Padding(
              padding: const EdgeInsets.only(left: 16.0,right: 16.0),
              child: ListView.separated(
                itemCount: players.length,
                separatorBuilder: (context, index) => const Divider(),
                itemBuilder: (context, index) {
                  final player = players[index];
                  return Container(
                    color: player.id == widget.currentUserId ? Colors.orange[200] : null,
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(player.bird.gifPath),
                        radius: 30.0,
                      ),
                      title: Text(
                        player.username,
                        style: const TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        'Highscore: ${player.highScore}',
                        style: const TextStyle(fontSize: 16.0),
                      ),
                      trailing: Text(
                        '#${index + 1}',
                        style: const TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueGrey,
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }
}