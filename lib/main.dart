import 'package:flutter/material.dart';
import 'package:trabalho_1/model/usuario.dart';
import 'package:trabalho_1/services/messaging_service.dart';
import 'package:trabalho_1/view/login_gui.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:trabalho_1/view/notification_gui.dart';
import 'firebase_options.dart';
import 'package:trabalho_1/services/notification_service.dart';
import 'package:trabalho_1/view/fractal_gui.dart';

final chaveDeNavegacao = GlobalKey<NavigatorState>();
final notificationService = NotificationService();

void main() async {
  // Inicia o Firebase
  WidgetsFlutterBinding.ensureInitialized();
  notificationService.initNotification();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform,);
  await MessagingService().initNotifications();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // Chama a tela de login
      home: LoginPage(),
      
      //Usamos a chave de navegação para que o gerenciadorpush faça o controle das rotas e não se preocupe com o contexto
      navigatorKey: chaveDeNavegacao,

      //Relaçao Chave/Tela para a navegação
      routes: {
        '/fractal': (context) => FractalPage(usuario: Usuario()),
        '/notification_screen':(context) => const NotificationPage(),
      },
    );
  }
}
