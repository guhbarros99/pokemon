import 'package:flutter/material.dart';
import 'package:pokemon/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:pokemon/pokedexpage.dart';
import 'package:pokemon/profilePage.dart';
import 'package:pokemon/services/notifications_services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Inicializa o Firebase (Obrigatório para Login e Notificações)
  await Firebase.initializeApp();

  // 2. Inicializa as notificações (se houver configuração de FCM, deve ser após o Firebase)
  await NotificationService.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      // TELA INICIAL DO APP
      home: const Login(),

      // AQUI VOCÊ PODE DEFINIR ROTAS SE QUISER
       routes: {
         '/pokedex': (context) => const PokedexPage(),
         '/login': (context) => const Login(),
         '/profile': (context) => const ProfilePage(),
       },
    );
  }
}