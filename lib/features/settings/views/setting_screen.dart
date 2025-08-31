import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restoranapp/features/settings/viewmodels/reminder_view_model.dart';
import 'package:restoranapp/features/theme/viewmodel/theme_view_model.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Consumer<ThemeViewModel>(
            builder: (context, themeViewModel, child) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Pilih Tema',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  RadioListTile<ThemeMode>(
                    title: const Text('Ikuti Sistem'),
                    value: ThemeMode.system,
                    groupValue: themeViewModel.themeMode,
                    onChanged: (value) {
                      if (value != null) {
                        themeViewModel.setThemeMode(value);
                      }
                    },
                  ),
                  RadioListTile<ThemeMode>(
                    title: const Text('Light Mode'),
                    value: ThemeMode.light,
                    groupValue: themeViewModel.themeMode,
                    onChanged: (value) {
                      if (value != null) {
                        themeViewModel.setThemeMode(value);
                      }
                    },
                  ),
                  RadioListTile<ThemeMode>(
                    title: const Text('Dark Mode'),
                    value: ThemeMode.dark,
                    groupValue: themeViewModel.themeMode,
                    onChanged: (value) {
                      if (value != null) {
                        themeViewModel.setThemeMode(value);
                      }
                    },
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 24),
          Consumer<ReminderViewModel>(
            builder: (context, reminderViewModel, child) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SwitchListTile(
                    title: Text(
                      "Daily Reminder (${reminderViewModel.hour.toString().padLeft(2, '0')}:${reminderViewModel.minute.toString().padLeft(2, '0')})",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    value: reminderViewModel.isReminderOn,
                    onChanged: (value) async {
                      await reminderViewModel.toggleReminder(value);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            value
                                ? "Daily reminder aktif ✅"
                                : "Daily reminder dimatikan ❌",
                          ),
                        ),
                      );
                    },
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      final picked = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay(
                          hour: reminderViewModel.hour,
                          minute: reminderViewModel.minute,
                        ),
                      );
                      if (picked != null) {
                        await reminderViewModel.setReminderTime(picked);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              "Reminder diatur ke ${picked.hour}:${picked.minute.toString().padLeft(2, '0')}",
                            ),
                          ),
                        );
                      }
                    },
                    child: const Text("Atur Jam Reminder"),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
