import 'dart:async';
import 'dart:io';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotificationProvider {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  final messageStreamController = StreamController<String>.broadcast();
  Stream<String> get message => messageStreamController.stream;

  initNotifications() {
    // Permisos para utilizar notificaciones
    messaging.requestPermission();

    // Para obtener el token
    messaging.getToken().then((token) {
      print('Token $token');

      // fxb7arqURzaqqR8Ouftigt:APA91bHhTrjoU0mfJ9giQ9X-WNrqDTLBO_GkJBLPV1iadSQtcIVMh9ro5P5uSXdKiw6ONzEZ4Jb9HWCfWJFLpcmt20MK_SSTxSBcOpPShB1BO7R2z-8qQCXiOvDs81D6WGwBJi6ZCx4M
    });

    FirebaseMessaging.onMessage.listen((info) {
      print('===== On Message =====');
      print(info.data);

      String argument = 'no-data';

      if(Platform.isAndroid){
        argument = info.data['hola'] ?? argument;
      }

      messageStreamController.sink.add(argument);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((info) {
      print('===== On Resume =====');
      print(info.data);

      final noti = info.data['Hola'];
      messageStreamController.sink.add(noti);
    });

    FirebaseMessaging.instance.getInitialMessage().then((info) {
      print('===== On Launch =====');
      print(info?.data);
    });
  }

  dispose() {
    messageStreamController.close();
  }
}



class PushNotificationService {

  static FirebaseMessaging message = FirebaseMessaging.instance;
  static String? token;
  static final StreamController<String> _messageStreamController = StreamController.broadcast();
  static Stream<String> get messagesStream => _messageStreamController.stream;

  static Future _backgroundHandler(RemoteMessage message) async {
    // print('onBackground Handler ${message.messageId}');

    // AwesomeNotifications().createNotificationFromJsonData(message.data);
    _messageStreamController.add(message.notification?.title ?? 'No title');
  }

  static Future _onMessageHandler(RemoteMessage message) async {
    // print('onMessage Handler ${message.messageId}');

    _messageStreamController.add(message.notification?.title ?? 'No title');
  }

  static Future _onMessageOpenApp(RemoteMessage message) async {
    // print('onMessageOpenApp Handler ${message.messageId}');

    _messageStreamController.add(message.notification?.title ?? 'No title');
  }

  Future<void> localNotification() async{
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 1, 
        channelKey: 'test1',
        title: 'Flutter Local Notification',
        body: 'Body Flutter Notification'
      )
    );
  }

  static Future initializeApp() async {

    // Push Notification
    await Firebase.initializeApp();
    token = await FirebaseMessaging.instance.getToken();
    print('Token: $token');

    // Handler
    FirebaseMessaging.onBackgroundMessage(_backgroundHandler);
    FirebaseMessaging.onMessage.listen(_onMessageHandler);
    FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenApp);

    // Local Notification

  }

  static closeStreams(){
    _messageStreamController.close();
  }
}