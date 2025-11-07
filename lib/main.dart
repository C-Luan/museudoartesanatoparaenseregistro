import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:registromap/routes/apuracao_page.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'routes/registro_page.dart';
import 'routes/feedback_page.dart';
import 'firebase_options.dart'; // gerado pelo comando `flutterfire configure`

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MuseuApp());
}

class MuseuApp extends StatelessWidget {
  const MuseuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Museu do Artesanato Paraense',
      theme: ThemeData(
        useSystemColors: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF667C73),
          background: const Color(0xFFEAEBEC),
        ),
        useMaterial3: false,
        fontFamily: 'Poppins',
      ),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      initialRoute: '/registro',
      routes: {
        '/apuracao': (context) => const ApuracaoPage(),
        '/registro': (context) => const RegistroPage(),
        '/feedback': (context) => const FeedbackPage(),
      },
    );
  }
}
