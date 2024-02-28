import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeProvider._();

  static ThemeProvider? _instance;
  static ThemeProvider get instance {
    _instance ??= ThemeProvider._();
    return _instance!;
  }

  ThemeMode theme = ThemeMode.system;

  Future<ThemeMode> initialize() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int index = prefs.getInt('themeMode') ?? 0;
    theme = ThemeMode.values[index];
    return theme;
  }

  Future<void> toggle(ThemeMode themeMode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('themeMode', themeMode.index);
    theme = themeMode;
    notifyListeners();
  }
}

class ThemePack {
  static final dark = ThemeData(
    useMaterial3: true,
    // scaffoldBackgroundColor: Colors.grey[1000],
    
    primaryColor: Colors.white,
    textTheme: const TextTheme(
      bodySmall: TextStyle(color: Colors.white),
      bodyMedium: TextStyle(color: Colors.white),
      bodyLarge: TextStyle(color: Colors.white),
      labelSmall: TextStyle(color: Colors.white),
      labelMedium: TextStyle(color: Colors.white),
      labelLarge: TextStyle(color: Colors.white),
      titleSmall: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      titleMedium: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      titleLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      isDense: true,
      isCollapsed: false,
      border: OutlineInputBorder(
        borderSide: BorderSide.none,
        borderRadius: BorderRadius.circular(10),
      ),
      fillColor: const Color.fromRGBO(44, 44, 46, 1),
      contentPadding: const EdgeInsets.all(7),
      labelStyle: const TextStyle(color: Colors.white),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.grey.shade800 
    ),
    colorScheme: ColorScheme(
      brightness: Brightness.dark, // The overall brightness of this color scheme.
      primary: Colors.white, // The color displayed most frequently across your app’s screens and components. (Floating button)
      onPrimary: Colors.white, // A color that's clearly legible when drawn on primary. (App bar)
      background: Colors.black, // A color that typically appears behind scrollable content.
      onBackground: Colors.white,
      surface: Colors.blue, // Status bar
      onSurface: Colors.white, // Icons color
      error: Colors.grey.shade300, 
      onError: Colors.grey.shade300,
      secondary: Colors.blue, 
      onSecondary: Colors.blue,
      primaryContainer: const Color.fromRGBO(28, 28, 30, 1)
    ),
    listTileTheme: ListTileThemeData(
      iconColor: Colors.white,
      tileColor: const Color.fromRGBO(28, 28, 30, 1),
      shape: RoundedRectangleBorder( //<-- SEE HERE
        borderRadius: BorderRadius.circular(10)
      )
    ),
    dropdownMenuTheme: DropdownMenuThemeData(
      textStyle: const TextStyle(fontSize: 18),
      menuStyle: MenuStyle(
        backgroundColor: MaterialStatePropertyAll(Colors.grey.shade900)
      )
    ),
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(
          Colors.blue
        ),
        padding: MaterialStateProperty.all(
          const EdgeInsets.symmetric(horizontal: 10)
        ),
        textStyle: const MaterialStatePropertyAll(TextStyle(color: Colors.white, fontSize: 19, fontWeight: FontWeight.bold))
      )
    ),
    switchTheme: SwitchThemeData(
      thumbColor: MaterialStateProperty.resolveWith((states) => 
        states.contains(MaterialState.disabled) ? Colors.grey.shade100 : Colors.white),
      trackColor: MaterialStateProperty.resolveWith((states) =>
        states.contains(MaterialState.selected) ? Colors.blue : Colors.grey)
    ),
    iconTheme: const IconThemeData(
      size: 20,
      weight: 8,
      color: Colors.white,
    ),
    appBarTheme: const AppBarTheme(
      color: Colors.transparent,
      surfaceTintColor: Colors.transparent
    ),
    cupertinoOverrideTheme: MaterialBasedCupertinoThemeData(
      materialTheme: ThemeData(
        primaryColor: Colors.blue
      )
    )
  );

  static final light = ThemeData(
    useMaterial3: true,
    primaryColor: Colors.black,
    scaffoldBackgroundColor: const Color.fromRGBO(242, 242, 247, 1),
    textTheme: const TextTheme(
      bodySmall: TextStyle(color: Colors.black),
      bodyMedium: TextStyle(color: Colors.black, fontSize: 19),
      bodyLarge: TextStyle(color: Colors.black, fontSize: 25),
      labelSmall: TextStyle(color: Colors.black),
      labelMedium: TextStyle(color: Colors.black, fontSize: 19),
      labelLarge: TextStyle(color: Colors.black, fontSize: 25),
      titleSmall: TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.bold),
      titleMedium: TextStyle(color: Colors.black, fontSize: 28, fontWeight: FontWeight.bold),
      titleLarge: TextStyle(color: Colors.black, fontSize: 34, fontWeight: FontWeight.bold),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      isCollapsed: true,
      fillColor: const Color.fromRGBO(227, 227, 233, 1),
      hintStyle: const TextStyle(color: Colors.grey,fontSize: 18),
      labelStyle: const TextStyle(color: Colors.black, fontSize: 18),
      contentPadding: const EdgeInsets.all(10),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: Colors.blue),
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.grey.shade200 
    ),
    colorScheme: const ColorScheme(
      brightness: Brightness.dark, // The overall brightness of this color scheme.
      background: Color.fromRGBO(242, 242, 247, 1), // A color that typically appears behind scrollable content.
      primary: Colors.black, // The color displayed most frequently across your app’s screens and components. (Floating button)
      onPrimary: Colors.black, // A color that's clearly legible when drawn on primary. (App bar)
      onBackground: Colors.black,
      surface: Colors.blue, // Status bar
      onSurface: Colors.black, // Icons color
      error: Color.fromRGBO(242, 242, 247, 1), 
      onError: Color.fromRGBO(242, 242, 247, 1), 
      secondary: Colors.blue, 
      onSecondary: Colors.blue,
      primaryContainer: Colors.white
    ),
    listTileTheme: ListTileThemeData(
      iconColor: Colors.black,
      tileColor: Colors.white,
      shape: RoundedRectangleBorder( //<-- SEE HERE
        borderRadius: BorderRadius.circular(10)
      )
    ),
    dropdownMenuTheme: DropdownMenuThemeData(
      textStyle: const TextStyle(fontSize: 18),
      menuStyle: MenuStyle(
        backgroundColor: MaterialStatePropertyAll(Colors.grey.shade900)
      )
    ),
    iconTheme: const IconThemeData(
      color: Colors.black
    ),
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(
          Colors.blue
        ),
        padding: MaterialStateProperty.all(
          const EdgeInsets.symmetric(horizontal: 10)
        )
      )
    ),
    switchTheme: SwitchThemeData(
      // thumbColor: MaterialStateProperty.all(primary),
      trackColor: MaterialStateProperty.resolveWith((states) =>
      states.contains(MaterialState.selected) ? Colors.blue : Colors.grey)
    )
  );

}