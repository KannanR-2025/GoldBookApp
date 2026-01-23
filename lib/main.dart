import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goldbook_desktop/config/router.dart';
import 'package:goldbook_desktop/config/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Note: Seeder cannot run on web platform (dart:ffi not available)
  // final db = getDatabaseInstance();
  // await SeederService(db).seedData();

  runApp(const ProviderScope(child: GoldBookApp()));
}

class GoldBookApp extends StatelessWidget {
  const GoldBookApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'GoldBook Desktop',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routerConfig: router,
    );
  }
}
