import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:personal_space/screens/auth/login_screen.dart';
import 'package:personal_space/screens/main/main_screen.dart';

class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) => StreamBuilder<User>(
        stream: FirebaseAuth.instance.authStateChanges(),
        initialData: FirebaseAuth.instance.currentUser,
        builder: (_, snapshot) {
          /* show waiting when connection state is waiting */
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(
              child: CircularProgressIndicator(),
            );

          /* if firebase user is found, open the main screen */
          if (snapshot.hasData) return MainScreen();

          /* if no user is found, open the login screen */
          return LoginScreen();
        },
      );
}
