import 'package:firebase_core/firebase_core.dart';
import 'package:flaptron_3000/utils/shared_pref.dart';
import 'package:flutter/material.dart';

import 'homepage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalStorage.init();
  try {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyCUmjofuWwjaWG1ppbNnoMnYaVX4Ue6DoY",
            authDomain: "flaptron-3000.firebaseapp.com",
            projectId: "flaptron-3000",
            storageBucket: "flaptron-3000.appspot.com",
            messagingSenderId: "618144878531",
            appId: "1:618144878531:web:ffa11d9c2abffd3d01f776",
            measurementId: "G-QMLWRFW5DF"));
  } catch (e) {
    print("Firebase initialize error : $e");
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}
