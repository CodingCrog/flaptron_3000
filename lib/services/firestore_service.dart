import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flaptron_3000/model/player.dart';
import 'package:flutter/foundation.dart';

import '../webon_kit_stub.dart'
    if (dart.library.js) 'package:webon_kit_dart/webon_kit_dart.dart';

abstract class FireStorePlayerService {
  Future<PlayerM?> getPlayer(String playerId);

  Future<PlayerM?> addPlayer({required String username, String? email});

  Future<void> updateHighScore(PlayerM player, int newHighScore);

  Future<bool> deletePlayer(PlayerM player);

  Future<List<PlayerM>> getTopPlayers();
}

class FireStoreServiceM implements FireStorePlayerService {
  @override
  Future<PlayerM?> addPlayer({required String username, String? email}) async {
    CollectionReference users =
        FirebaseFirestore.instance.collection('players');
    const highscore = 0;
    String ethAddress = '';
    if (kIsWeb) {
      ethAddress = await WebonKitDart.getEvmAddress();
    }
    final usermap = {
      'username': username,
      'email': email,
      'highScore': highscore,
      'birdPath':
          'https://ipfs.io/ipfs/bafybeiefkakrj57ngw4ox3uubjhtvoyti6zb7d7cbyy5quxmqnvcejzzim/1',
      if (ethAddress.startsWith('0x')) 'ethAddress': ethAddress,
    };

    // Check if user with same ethAddress already exists
    final QuerySnapshot result =
        await users.where('ethAddress', isEqualTo: ethAddress).limit(1).get();
    final List<DocumentSnapshot> documents = result.docs;
    if (documents.length == 1) {
      debugPrint('User with same ethAddress already exists');
      final playerData = documents.first.data() as Map<String, dynamic>;
      playerData.putIfAbsent('id', () => documents.first.id);
      return PlayerM.fromJson(playerData);
    }

    try {
      final res = await users.add(usermap);
      debugPrint(res.id);
      final player = await getPlayer(res.id);
      return player;
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }

  @override
  Future<bool> deletePlayer(PlayerM player) async {
    CollectionReference users =
        FirebaseFirestore.instance.collection('players');
    try {
      await users.doc(player.id).delete();
      return true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  @override
  Future<PlayerM?> getPlayer(String playerId) async {
    CollectionReference users =
        FirebaseFirestore.instance.collection('players');
    try {
      final res = await users.doc(playerId).get();
      final player = res.data();
      Map<String, dynamic> playerMap = player as Map<String, dynamic>;
      playerMap.putIfAbsent('id', () => playerId);
      final playerModel = PlayerM.fromJson(playerMap);
      return playerModel;
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }

  @override
  Future<void> updateHighScore(PlayerM player, int newHighScore) async {
    CollectionReference users =
        FirebaseFirestore.instance.collection('players');
    try {
      await users.doc(player.id).update({
        'highScore': newHighScore,
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> updateBird(PlayerM player, String birdPath) async {
    CollectionReference users =
        FirebaseFirestore.instance.collection('players');
    try {
      await users.doc(player.id).update({
        'birdPath': birdPath,
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Future<List<PlayerM>> getTopPlayers() async {
    CollectionReference users =
        FirebaseFirestore.instance.collection('players');
    List<PlayerM> topPlayers = [];

    final QuerySnapshot result =
        await users.orderBy('highScore', descending: true).limit(100).get();

    for (var doc in result.docs) {
      final playerData = doc.data() as Map<String, dynamic>;
      playerData.putIfAbsent('id', () => doc.id);

      if (playerData
          case {
            'highScore': int _,
            'username': String _,
            'birdPath': String _,
          }) {
        topPlayers.add(PlayerM.fromJson(playerData));
      }
    }

    return topPlayers;
  }

  Future<int> getHighScore(String playerId) async {
    CollectionReference users =
        FirebaseFirestore.instance.collection('players');
    try {
      final res = await users.doc(playerId).get();
      final playerData = res.data() as Map<String, dynamic>;
      return playerData['highScore'] ?? 0;
    } catch (e) {
      debugPrint(e.toString());
      return 0;
    }
  }
}
