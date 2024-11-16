import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:pokeapp/features/shared/app_shell/app_shell.dart';


class SplashScreen extends StatelessWidget {
  final ValueNotifier<bool> _isTimeElapsed = ValueNotifier(false);
  SplashScreen({super.key}) {
    Future.delayed(const Duration(seconds: 3), () {
      _isTimeElapsed.value = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: _isTimeElapsed,
      builder: (context, isTimeElapsed, child) {
        if (isTimeElapsed) {
          Future.microtask(() {
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                transitionDuration: Duration(milliseconds: 800),
                pageBuilder: (_, __, ___) => const AppShell(),
                transitionsBuilder: (_, animation, __, child) {
                  return FadeTransition(
                    opacity: animation,
                    child: child,
                  );
                },
              ),
            );
          });
        }

        return Scaffold(
          backgroundColor: Colors.white,
          body: Center(
            child: Lottie.asset(
              'assets/lotties/pokeball-lottie.json',
              width: 200,
              height: 200,
              fit: BoxFit.contain,
            ),
          ),
        );
      },
    );
  }
}
