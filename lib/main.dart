import 'package:flutter/material.dart';
import '../pages/layout.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
void main() {
  runApp(const ProviderScope(child:  MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'The Movie Catalogue',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: const AppLayout(),
      debugShowCheckedModeBanner: false,
    );
  }
}
