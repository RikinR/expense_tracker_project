import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  final Function(bool) onThemeChanged;

  const SettingsPage({
    required this.onThemeChanged,
    Key? key,
  }) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _isDarkTheme = false;

  void changeTheme() {
    setState(() {
      _isDarkTheme = !_isDarkTheme;
    });
    widget.onThemeChanged(_isDarkTheme);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Text('Change Theme:',
                    style: TextStyle(
                        fontSize: 18,
                        color: _isDarkTheme ? Colors.white : Colors.black)),
                const Spacer(),
                IconButton(
                  onPressed: changeTheme,
                  icon: _isDarkTheme
                      ? const Icon(
                          Icons.circle,
                          color: Colors.green,
                        )
                      : const Icon(
                          Icons.circle_outlined,
                          color: Colors.green,
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
