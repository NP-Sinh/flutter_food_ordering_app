import 'package:flutter/material.dart';
import 'package:food_ordering_app/pages/NguoiDung/nguoidung_page.dart';
import 'package:food_ordering_app/pages/Wellcome/wellcome_page.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WellcomPage(),
    );
  }
}
