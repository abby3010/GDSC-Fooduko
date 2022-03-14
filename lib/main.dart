import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fooduko/pages/homepage.dart';
import 'package:fooduko/pages/loginpage.dart';
import 'package:provider/provider.dart';

import 'modules/authentication/firebaseAuthService.dart';
// import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<FirebaseAuthService>(create: (_) => FirebaseAuthService()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Fooduko',
        home: const LoginPage(),
        routes: {
          "/": (context) => const LoginPage(),
          "/home" : (context) => const HomePage(),
          // "/myProfile": (context) => MyProfileScreen(),
          // "/addRecipe": (context) => AddRecipe(),
          // "/myRecipes": (context) => MyRecipes(),
        },
      ),
    );
  }
}
