import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/theme/theme_provider.dart';

class DrawerPage extends StatefulWidget {
  const DrawerPage({super.key});

  @override
  State<DrawerPage> createState() => _DrawerPageState();
}

class _DrawerPageState extends State<DrawerPage> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    bool switchVal = themeProvider.isDarkMode;
    bool useSystemTheme = themeProvider.useSystemTheme;

    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topRight: Radius.circular(8.0),
        bottomRight: Radius.circular(8.0),
      ),
      child: Drawer(
        backgroundColor: Theme.of(context).colorScheme.surface,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 50),
              Text(
                "Settings",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const Divider(),
              const SizedBox(height: 8),
              Row(
                children: [
                  Text(
                    "Dark Theme",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  const Spacer(),
                  Switch(
                    value: switchVal,
                    activeTrackColor: Colors.white,
                    activeColor: Colors.black,
                    onChanged: useSystemTheme
                        ? null
                        : (value) {
                            themeProvider.toggleTheme();
                          },
                  ),
                ],
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}
