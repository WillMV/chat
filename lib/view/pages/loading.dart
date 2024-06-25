import 'package:flutter/material.dart';

class LoadingPage extends StatelessWidget {
  const LoadingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.primaryColor,
      body: Center(
          child: CircularProgressIndicator(
        backgroundColor: theme.primaryColor,
        color: Colors.white,
      )),
    );
  }
}
