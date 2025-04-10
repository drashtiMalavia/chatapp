
import 'package:chatapp/screens/Spelshscreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  InitialFirebase();
  runApp(MaterialApp(home: Spelshscreen(),debugShowCheckedModeBanner: false,));
}

InitialFirebase() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}
