import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flaptron_3000/utils/shared_pref.dart';

class FireStoreService {

  static Future<void> addUser(String name, String email, int? highScore) async {
    CollectionReference users =
        FirebaseFirestore.instance.collection('players');
    highScore ??= 0;
    try {
      await users.add({
        'name': name,
        'email': email,
        'highScore': highScore,
      });
      print("User added successfully!");
    } catch (error) {
      print("Failed to add user: $error");
    }
  }

  static Future<void> fetchUsers() async {
    CollectionReference users =
        FirebaseFirestore.instance.collection('players');
    try {
      QuerySnapshot snapshot = await users.get();
      snapshot.docs.forEach((doc) {
        print('${doc.id} => ${doc.data()}');
      });
    } catch (error) {
      print("Failed to fetch users: $error");
    }
  }

  static Future<void> updateHighScore(
      String? playerName, String newHighScore) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('players')
          .where('name', isEqualTo: playerName)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        for (final docSnapshot in querySnapshot.docs) {
          final docRef = FirebaseFirestore.instance
              .collection('players')
              .doc(docSnapshot.id);
          await docRef.update({'highScore': newHighScore});
          print("High score updated successfully for player $playerName");
        }
      } else {
        print("No player found with the name $playerName");
      }
    } catch (error) {
      print("Error updating high score: $error");
    }
  }

  static Future<void> deleteUser() async {

    try {
      String? playerName = LocalStorage.getDisplayName();
      if(playerName == null) {
        print("No player found");
        return;
      }
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('players')
          .where('name', isEqualTo: playerName)
          .get(); //TODO: What if user have same name?
      if (querySnapshot.docs.isNotEmpty) {
        for (final docSnapshot in querySnapshot.docs) {
          final docRef = FirebaseFirestore.instance
              .collection('players')
              .doc(docSnapshot.id);
          await docRef.delete();
          print("Player $playerName deleted successfully");
        }
      } else {
        print("No player found with the name $playerName");
      }
    } catch (error) {
      print("Error deleting player: $error");
    }
  }
}
