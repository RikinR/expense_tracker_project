
import 'package:expense_tracker/pages/expenses.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyClass());
}

class MyClass extends StatefulWidget {
  const MyClass({Key? key}) : super(key: key);

  @override
  State<MyClass> createState() => _MyClassState();
}

class _MyClassState extends State<MyClass> {
  late bool _isDarkTheme =false;

  @override
  void initState() {
    super.initState();
    _fetchTheme();
  }

  Future<void> _fetchTheme() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkTheme = prefs.getBool('isDarkTheme') ?? false;
    });
  }

  Future<void> _saveTheme(bool isDark) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkTheme', isDark);
  }

  void toggleTheme(bool isDark) {
    setState(() {
      _isDarkTheme = isDark;
    });
    _saveTheme(isDark);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: _isDarkTheme
          ? ThemeData.dark().copyWith(
              primaryColor: const Color.fromARGB(255, 58, 74, 105),
              drawerTheme: const DrawerThemeData(
                  backgroundColor: Color.fromARGB(255, 23, 23, 23)),
              bottomSheetTheme: const BottomSheetThemeData(
                  backgroundColor: Color.fromARGB(255, 58, 74, 105)),
              appBarTheme: const AppBarTheme(
                  foregroundColor: Colors.white,
                  backgroundColor: Color.fromARGB(255, 58, 74, 105)),
              cardTheme:
                  const CardTheme(color: Color.fromARGB(255, 58, 74, 105)),
              textTheme: const TextTheme(
                  bodySmall:
                      TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
                  bodyMedium:
                      TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
                  bodyLarge:
                      TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
                  titleLarge:
                      TextStyle(color: Color.fromARGB(255, 255, 255, 255))))
          : ThemeData.light().copyWith(
              primaryColor: const Color.fromARGB(255, 58, 74, 105),
              bottomSheetTheme: const BottomSheetThemeData(
                  backgroundColor: Color.fromARGB(255, 58, 74, 105)),
              appBarTheme: const AppBarTheme(
                  foregroundColor: Colors.white,
                  backgroundColor: Color.fromARGB(255, 58, 74, 105)),
              cardTheme:
                  const CardTheme(color: Color.fromARGB(255, 58, 74, 105)),
              textTheme: const TextTheme(
                  bodySmall:
                      TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
                  bodyMedium:
                      TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
                  bodyLarge:
                      TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
                  titleLarge:
                      TextStyle(color: Color.fromARGB(255, 255, 255, 255)))),
      home: Expenses(
        changeTheme: toggleTheme,
      ),
    );
  }
}
