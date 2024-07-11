import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {

    final message = ModalRoute.of(context)!.settings.arguments as RemoteMessage;

    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Text("Notificações",
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.w500, 
              ),
            ),
            SizedBox(width: 10),
          ],
        ),
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 40),
            Text(message.notification!.title.toString(),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 23,
              ),
            ),
            const SizedBox(height: 15),
            Text(message.notification!.body.toString(),
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 125),
            const Icon(
                  Icons.notifications_active_outlined,
                  size: 200,
                  color: Colors.amber,
            ),
          ],
        ),
      ),
    );
  }

}