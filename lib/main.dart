import 'package:flutter/material.dart';
import 'screens/dns_changer_home_page.dart';

void main() {
  runApp(const DnsChangerApp());
}

/// اپلیکیشن اصلی DNS Changer
class DnsChangerApp extends StatelessWidget {
  const DnsChangerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DNS Changer',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(centerTitle: true, elevation: 0),
        cardTheme: CardThemeData(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
        ),
      ),
      home: const DnsChangerHomePage(title: 'DNS Changer'),
      debugShowCheckedModeBanner: false,
    );
  }
}
