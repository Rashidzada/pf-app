import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/main_shell.dart';
import 'screens/splash_screen.dart';
import 'services/storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );
  await StorageService.instance.init();
  runApp(const ProgrammingFundamentalsApp());
}

class ProgrammingFundamentalsApp extends StatefulWidget {
  const ProgrammingFundamentalsApp({super.key});

  @override
  State<ProgrammingFundamentalsApp> createState() =>
      _ProgrammingFundamentalsAppState();
}

class _ProgrammingFundamentalsAppState
    extends State<ProgrammingFundamentalsApp> {
  bool _showSplash = true;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PF C++ Guide - Rashid Zada',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0E395E),
          primary: const Color(0xFF0E395E),
          secondary: const Color(0xFF00ACC1),
        ),
        scaffoldBackgroundColor: const Color(0xFFF1F5F9),
      ),
      home: _showSplash
          ? SplashScreen(
              onFinish: () {
                if (mounted) {
                  setState(() => _showSplash = false);
                }
              },
            )
          : const MainShell(),
    );
  }
}
