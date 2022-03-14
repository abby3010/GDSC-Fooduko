import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../modules/authentication/firebaseAuthService.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Fooduko",
            style: TextStyle(fontSize: 20),
            textAlign: TextAlign.center,
          ),
          Image.asset("/images/cooking.png"),
          GestureDetector(
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(
                    color: Theme.of(context).primaryColor,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(50)),
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "images/google_logo.png",
                    height: 30,
                    width: 30,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    "Login with Google",
                    style: TextStyle(
                        color: Theme.of(context).primaryColor, fontSize: 16),
                  ),
                ],
              ),
            ),
            onTap: () async {
              setState(() {
                _isLoading = true;
              });
              final authServiceProvider =
                  Provider.of<FirebaseAuthService>(context, listen: false);
              await authServiceProvider.signInWithGoogle(context);

              setState(() {
                _isLoading = false;
              });

              Navigator.pushNamedAndRemoveUntil(
                  context, "/home", (route) => false);
            },
          ),
        ],
      ),
    );
  }
}
