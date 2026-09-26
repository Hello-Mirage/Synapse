import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'client.dart';
import 'screens/dashboard_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeClient();
  runApp(const SynapseApp());
}

class SynapseApp extends StatelessWidget {
  const SynapseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Synapse Dashboard',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0F172A),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF3B82F6),
          brightness: Brightness.dark,
        ),
        textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme),
      ),
      home: const DashboardScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
