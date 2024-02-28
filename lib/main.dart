import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'provider/theme.dart';

import 'package:templeblock/home.dart';
import 'package:templeblock/database.dart';


void main() async {
  await Settings.instance.initialize();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ThemeProvider.instance,
      builder: (context, _) {
        final themeProvider = Provider.of<ThemeProvider>(context);
        return MaterialApp(
          title: '木魚',
          home: const HomePage(),
          theme: ThemePack.light,
          darkTheme: ThemePack.dark,
          themeMode: themeProvider.theme,
          debugShowCheckedModeBanner: false,
          builder: (context, child) {
            final mediaQueryData = MediaQuery.of(context);
            return MediaQuery(
              data: mediaQueryData,
              child: child!
            );
          }
        );
      }
    );
  }
}