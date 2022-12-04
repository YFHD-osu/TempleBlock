import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode themeModeController = ThemeMode.system;

  ThemeProvider () {
    List<ThemeMode> themeModes = [ThemeMode.system, ThemeMode.light, ThemeMode.dark];
    loadPrefs().then((value) => themeModeController = themeModes[value]);
  }

  Future<int> loadPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt('themeMode') ?? 0;
  }

  Future<void> toggleTheme(int themeCode) async {
    WidgetsFlutterBinding.ensureInitialized();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    switch(themeCode){
      case 0:
        themeModeController = ThemeMode.system;
        await prefs.setInt('themeMode', 0);
        break;
      case 1:
        themeModeController = ThemeMode.light;
        await prefs.setInt('themeMode', 1);
        break;
      case 2 :
        themeModeController = ThemeMode.dark;
        await prefs.setInt('themeMode', 2);
        break;
    }
    // themeMode = isOn ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}

class ThemeDatas {
  static final darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: Colors.black,
    primaryColor: Colors.white,
    textTheme: const TextTheme(
      bodyMedium: TextStyle(color: Colors.white)
    ),
    inputDecorationTheme: InputDecorationTheme(
      fillColor: Colors.grey[800],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: Colors.green),
      )
    ),

    colorScheme: const ColorScheme.dark(),
    useMaterial3: true,
  );

  static final lightTheme = ThemeData(
    scaffoldBackgroundColor: Colors.grey[200],
    brightness: Brightness.light,
    primaryColor: Colors.black,
    textTheme: const TextTheme(
      bodyMedium: TextStyle(color: Colors.black)
    ),

    inputDecorationTheme: InputDecorationTheme(
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: Colors.green),
      )
    ),

    colorScheme: const ColorScheme.light(),
    useMaterial3: true,
  );

}