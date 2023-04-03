import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mvvm_blackjack/viewmodels/game_viewmodel.dart';
import 'package:mvvm_blackjack/views/game_view.dart';

// ----------------------------------------------------------------------------

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => GameViewModel(),
        ),
      ],
      child: const MainApp(),
    ),
  );
}

// ----------------------------------------------------------------------------

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Blackjack MVVM Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Scaffold(
        body: GameView(),
      ),
    );
  }
}
