import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:rickmorty/providers/api_provider.dart';
import 'package:rickmorty/screens/character_screen.dart';
import 'package:rickmorty/screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

final GoRouter _goRouter = GoRouter(
  routes: [
    GoRoute(
      path: "/",
      builder: (context, state) {
        return HomeScreen();
      },
      routes: [
        GoRoute(
          path: '/character',
          builder: (context, state) {
            return const CharacterScreen();
          },
        ),
      ],
    ),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ApiProvider(),
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(brightness: Brightness.dark, useMaterial3: true),
        routerConfig: _goRouter,
      ),
    );
  }
}
