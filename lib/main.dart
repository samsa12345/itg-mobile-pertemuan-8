import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/product_providers.dart';
import 'providers/favorite_providers.dart';
import 'pages/home_page.dart';

// Nama  : Samsa Faridah
// NIM   : 2306139
// Tugas Praktikum Pertemuan 8


void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => FavoriteProvider()),
      ],
      child: MaterialApp(
        title: 'Sams Shopping',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6C63FF)),
          useMaterial3: true,
          fontFamily: 'Roboto',
        ),
        home: const HomePage(),
      ),
    );
  }
}