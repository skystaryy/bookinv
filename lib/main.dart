import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'book_page.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://lhwizbmtikuiiydekvhg.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imxod2l6Ym10aWt1aWl5ZGVrdmhnIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzY1Nzc1NjMsImV4cCI6MjA1MjE1MzU2M30.SMQqu6PrMHj8qCrcCB0zobHE0lenXrFM8ZBnyurgf8g',
  );
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: BookListScreen(),
      debugShowCheckedModeBanner: false
    );
  }
}