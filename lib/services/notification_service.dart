import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:trabalho_1/control/usuario_controller.dart';
import 'package:trabalho_1/main.dart';
import 'package:trabalho_1/model/usuario.dart';

class NotificationService {
  final UsuarioController _usuarioController = UsuarioController();
  final FlutterLocalNotificationsPlugin notificationsPlugin = FlutterLocalNotificationsPlugin();
  bool isNotificationEnabled = false; // Add this line
  Usuario user = Usuario();

  void setUser(Usuario _user) {
    user = _user;
    schedulePeriodicNotifications();
  }

  void toggleNotifications(bool enable) {
    isNotificationEnabled = enable;
    print(enable);
    schedulePeriodicNotifications();
  }

  void executarResposta(NotificationResponse notificationResponse) async {
    print('Response: ${notificationResponse.payload}');
    Usuario usuario = (await _usuarioController.consultarUsuarioPorNome(notificationResponse.payload!))!;

    chaveDeNavegacao.currentState?.pushNamed('/fractal', arguments: usuario);
  }
  
  Future<void> initNotification() async {
      AndroidInitializationSettings initializationSettingsAndroid = const AndroidInitializationSettings('@mipmap/ic_launcher');   

      var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid
      );
      await notificationsPlugin.initialize(initializationSettings,
          onDidReceiveNotificationResponse: (payload) => executarResposta(payload)
      );
    }

  notificationDetails() {
    return const NotificationDetails(
        android: AndroidNotificationDetails('channelId', 'channelName', importance: Importance.max)
    );
  }

  Future<void> schedulePeriodicNotifications() async {
    const title = 'Lembrete';
    var body = 'Não se esqueça de suas tarefas ${user.nome}!';
    if (isNotificationEnabled) {
      print('Notificações adicionadas');
      await notificationsPlugin.periodicallyShow(
        0,
        title,
        body,
        RepeatInterval.everyMinute,
        await notificationDetails(),
        payload: user.usuario, //teste inutil
        androidAllowWhileIdle: true,
      );
      return notificationsPlugin.show(
        0, 
        title,
        body, 
        await notificationDetails(), 
        payload: user.usuario, //teste inutil
      );
    } else {
      print('Notificações Removidas');
      await notificationsPlugin.cancel(0);
    }
  }

}