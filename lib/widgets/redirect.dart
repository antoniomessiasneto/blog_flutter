import 'package:flutter/material.dart';

class Redirect extends StatelessWidget {
  const Redirect({super.key});

  @override
  Widget build(BuildContext context) {
    // Redireciona imediatamente para a tela de Home
    Future.delayed(Duration.zero, () {
      Navigator.pushReplacementNamed(context, '/');
    });

    return const Scaffold(
      body: Center(
        child:
            CircularProgressIndicator(), 
      ),
    );
  }
}
