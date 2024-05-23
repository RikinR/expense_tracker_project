import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  final Function(bool) onThemeChanged;
  final Function() deleteAllExpenses; 

  const SettingsPage({
    required this.onThemeChanged,
    required this.deleteAllExpenses, 
    Key? key,
  }) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _isDarkTheme = false;

  void changeTheme(bool isDark) {
    setState(() {
      _isDarkTheme = isDark;
    });
    widget.onThemeChanged(_isDarkTheme);
  }

  Future<void> _confirmResetData() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Data Deletion'),
          content: const Text('Are you sure you want to reset all data?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                widget.deleteAllExpenses();
                Navigator.of(context).pop();
              },
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    const Text(
                      'Change Theme:',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                    const Spacer(),
                    Switch(
                      value: _isDarkTheme,
                      onChanged: changeTheme,
                      activeColor: Colors.green,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    const Text(
                      'Reset Data',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: _confirmResetData,
                      icon: const Icon(
                        Icons.delete_forever,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
