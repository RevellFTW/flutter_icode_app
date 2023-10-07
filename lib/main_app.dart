import 'package:flutter/material.dart';

import 'pages/onboarding.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.from(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromRGBO(32, 63, 129, 1.0),
        ),
      ),
      home: OnboardingPage(
        pages: [
          OnboardingPageModel(
            title: 'Fast, Fluid and Secure',
            description:
                'Enjoy the best of the world in the palm of your hands.',
            image: 'assets/image0.png',
            bgColor: Colors.indigo,
          ),
          OnboardingPageModel(
            title: 'Connect with your friends.',
            description: 'Connect with your friends anytime anywhere.',
            image: 'assets/image1.png',
            bgColor: const Color(0xff1eb090),
          ),
          OnboardingPageModel(
            title: 'Follow creators',
            description: 'Follow your favourite creators to stay in the loop.',
            image: 'assets/image3.png',
            bgColor: Colors.purple,
          ),
        ],
      ),
    );
  }
}
