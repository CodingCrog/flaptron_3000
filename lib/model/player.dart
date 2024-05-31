import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flaptron_3000/model/bird.dart';
import 'package:flaptron_3000/utils/shared_pref.dart';

class Player {
  String name;
  int score;
  Bird bird;
  int highScore;

  Player({required this.name, required this.score, required this.bird})
      : highScore = LocalStorage.getHighScore();

  void increasementScore() {
    score++;
  }

  void decreaseScore() {
    score--;
  }

  void resetScore() {
    score = 0;
  }

  void incresase(int value) {
    score += value;
  }

  void setHighscore(String playerName) async {
    if (score > highScore) {
      highScore = score;
      LocalStorage.setHighScore(highScore);
      await updateHighScore(playerName, "$highScore");
    }
  }

  Future<void> addUser(String name, String email, int? highScore) {
    CollectionReference users = FirebaseFirestore.instance.collection('players');
    highScore ??= 0;
    return users.add({
      'name': name,
      'email': email,
      'highScore': highScore
    })
        .then((value) => print("User added successfully!"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  Future<void> fetchUsers() {
    CollectionReference users = FirebaseFirestore.instance.collection('players');

    return users.get()
        .then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((doc) {
        print('${doc.id} => ${doc.data()}');
      });
    })
        .catchError((error) => print("Failed to fetch users: $error"));
  }

  Future<void> updateHighScore(String playerName, String newHighScore) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('players')
        .where('name', isEqualTo: playerName)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      for (final docSnapshot in querySnapshot.docs) {
        final docRef = FirebaseFirestore.instance.collection('players').doc(docSnapshot.id);
        await docRef.update({'highScore': newHighScore});
        print("High score updated successfully for player $playerName");
      }
    } else {
      print("No player found with the name $playerName");
    }
  }

  Future<void> deleteUser(String playerName) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('players')
        .where('name', isEqualTo: playerName)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      for (final docSnapshot in querySnapshot.docs) {
        final docRef = FirebaseFirestore.instance.collection('players').doc(docSnapshot.id);
        await docRef.delete();
        print("Player $playerName deleted successfully");
      }
    } else {
      print("No player found with the name $playerName");
    }
  }
}
