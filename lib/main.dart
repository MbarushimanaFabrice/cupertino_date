import 'package:flutter/material.dart';

import 'cupertino_date_picker_page.dart';
import 'employee_schedule_page.dart';

/// Starts the demo with the date-picker examples as the initial screen.
void main() => runApp(const DatePickerPresentationApp());

class DatePickerPresentationApp extends StatelessWidget {
  const DatePickerPresentationApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Cupertino Date Picker',
    theme: ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: const Color(0xFFF6F8FC),
      colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF5865F2)),
      fontFamily: 'Arial',
    ),
    home: const PresentationShell(),
  );
}

// Keeps the default Flutter test harness compatible with this presentation app.
class MyApp extends DatePickerPresentationApp {
  const MyApp({super.key});
}

/// Provides navigation between the picker examples and the schedule demo.
class PresentationShell extends StatefulWidget {
  const PresentationShell({super.key});

  @override
  State<PresentationShell> createState() => _PresentationShellState();
}

class _PresentationShellState extends State<PresentationShell> {
  // The selected tab is kept here so both pages remain mounted by the shell.
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: index == 0
            ? const PickerBasicsPage()
            : const EmployeeFilterPage(),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        onDestinationSelected: (value) => setState(() => index = value),
        destinations: const [
          NavigationDestination(
            icon: SizedBox.shrink(),
            selectedIcon: SizedBox.shrink(),
            label: 'How it works',
          ),
          NavigationDestination(
            icon: SizedBox.shrink(),
            selectedIcon: SizedBox.shrink(),
            label: 'Implementation',
          ),
        ],
      ),
    );
  }
}
