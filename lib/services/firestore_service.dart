import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flaptron_3000/model/player.dart';
import 'package:flutter/foundation.dart';
import 'package:webon_kit_dart/webon_kit_dart.dart';

// class FireStoreService {
//   static Future<void> fetchUser() async {
//     final userId = LocalStorage.getPlayerId();
//     final isUserRegistered = userId.isNotEmpty;
//     CollectionReference users =
//         FirebaseFirestore.instance.collection('players');
//     if (isUserRegistered) {
//       final player = await users.where('id', isEqualTo: userId).get();
//     }
//   }

//   static Future<void> addUser(String name, String email, int? highScore) async {
//     CollectionReference users =
//         FirebaseFirestore.instance.collection('players');
//     highScore ??= 0;
//     try {
//       await users.add({
//         'name': name,
//         'email': email,
//         'highScore': highScore,
//       });
//       debugPrint("User added successfully!");
//     } catch (error) {
//       debugPrint("Failed to add user: $error");
//     }
//   }

//   static Future<void> fetchUsers() async {
//     CollectionReference users =
//         FirebaseFirestore.instance.collection('players');
//     try {
//       QuerySnapshot snapshot = await users.get();
//       snapshot.docs.forEach((doc) {
//         debugPrint('${doc.id} => ${doc.data()}');
//       });
//     } catch (error) {
//       debugPrint("Failed to fetch users: $error");
//     }
//   }

//   static Future<void> updateHighScore(
//       String? playerName, String newHighScore) async {
//     try {
//       QuerySnapshot querySnapshot = await FirebaseFirestore.instance
//           .collection('players')
//           .where('name', isEqualTo: playerName)
//           .get();
//       if (querySnapshot.docs.isNotEmpty) {
//         for (final docSnapshot in querySnapshot.docs) {
//           final docRef = FirebaseFirestore.instance
//               .collection('players')
//               .doc(docSnapshot.id);
//           await docRef.update({'highScore': newHighScore});
//           debugPrint("High score updated successfully for player $playerName");
//         }
//       } else {
//         debugPrint("No player found with the name $playerName");
//       }
//     } catch (error) {
//       debugPrint("Error updating high score: $error");
//     }
//   }

//   static Future<void> deleteUser() async {
//     try {
//       String? playerName = LocalStorage.getDisplayName();
//       if (playerName == null) {
//         debugPrint("No player found");
//         return;
//       }
//       QuerySnapshot querySnapshot = await FirebaseFirestore.instance
//           .collection('players')
//           .where('name', isEqualTo: playerName)
//           .get(); //TODO: What if user have same name?
//       if (querySnapshot.docs.isNotEmpty) {
//         for (final docSnapshot in querySnapshot.docs) {
//           final docRef = FirebaseFirestore.instance
//               .collection('players')
//               .doc(docSnapshot.id);
//           await docRef.delete();
//           debugPrint("Player $playerName deleted successfully");
//         }
//       } else {
//         debugPrint("No player found with the name $playerName");
//       }
//     } catch (error) {
//       debugPrint("Error deleting player: $error");
//     }
//   }
// }

abstract class FireStorePlayerService {
  Future<PlayerM?> getPlayer(String playerId);
  Future<PlayerM?> addPlayer({required String username, String? email});
  Future<void> updateHighScore(PlayerM player, int newHighScore);
  Future<bool> deletePlayer(PlayerM player);
}

class FireStoreServiceM implements FireStorePlayerService {
  @override
  Future<PlayerM?> addPlayer({required String username, String? email}) async {
    CollectionReference users =
        FirebaseFirestore.instance.collection('players');
    const highscore = 0;
    final ethAddress = await WebonKitDart.getEvmAddress();
    final usermap = {
      'username': username,
      'email': email,
      'highScore': highscore,
      'birdPath': 'https://ipfs.io/ipfs/bafybeiefkakrj57ngw4ox3uubjhtvoyti6zb7d7cbyy5quxmqnvcejzzim/1',
      if (ethAddress.startsWith('0x')) 'ethAddress': ethAddress,
    };
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
}
