import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'screens/memo_screen.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://ejfdrulkppfnzynipkab.supabase.co',
    anonKey: 'sb_publishable_0dcegxSd0bbxswV2gRiJcw_jXiuSH7V',
  );

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Memo/Catatan App',
      theme: ThemeData(useMaterial3: true),
      home: const MemoScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
