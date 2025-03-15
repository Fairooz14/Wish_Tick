import 'package:flutter/material.dart';
import 'pages/wish_input_page.dart';
import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final initialTheme = await AppTheme.loadTheme();
  runApp(MyApp(initialTheme: initialTheme));
}

class MyApp extends StatelessWidget {
  final String initialTheme;

  MyApp({required this.initialTheme});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Wish Tracker',
      theme: initialTheme == 'neonPurple' ? AppTheme.neonPurpleTheme : AppTheme.darkBlueTheme,
      home: WishInputPage(),
    );
  }
}