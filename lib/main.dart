import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:test_notification_push/src/pages/home_page.dart';
import 'package:test_notification_push/src/pages/message_page.dart';
import 'package:test_notification_push/src/provider/push_notification_provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();

//   runApp(const MyApp());
// }

// class MyApp extends StatefulWidget {
//   const MyApp({Key? key}) : super(key: key);

//   @override
//   State<MyApp> createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {

//   final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

//   @override
//   void initState() {
//     super.initState();

//     final pushProvider = PushNotificationProvider();
//     pushProvider.initNotifications();

//     pushProvider.message.listen((data) {
//       print('Argumento de notificacion');
//       print(data);

//       navigatorKey.currentState?.pushNamed('message', arguments: data);
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       navigatorKey: navigatorKey,
//       initialRoute: 'home',
//       routes: {
//         'home':(context) => const HomePage(),
//         'message':(context) => const MessagePage()
//       },
//     ); 
//   }
// }



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PushNotificationService.initializeApp();
  AwesomeNotifications().initialize(
    null,
    [
      NotificationChannel(
        channelKey: 'test1', 
        channelName: 'Test 1', 
        channelDescription: 'Test notification',
        locked: true,
        importance: NotificationImportance.High,
        channelShowBadge: true,
        playSound: true,
        enableVibration: true,
        enableLights: true,
        ledColor: Colors.yellow,
        defaultPrivacy: NotificationPrivacy.Public
      )
    ]
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({ Key? key }) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();

    PushNotificationService.messagesStream.listen((message) {
      print('MyApp: $message');

      navigatorKey.currentState?.pushNamed('message', arguments: message);
    });

    AwesomeNotifications().actionStream.listen((message) {
      navigatorKey.currentState?.pushNamed('message', arguments: message.body);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, 
      navigatorKey: navigatorKey,
      initialRoute: 'home',
      routes: {
        'home':(context) => HomePage(),
        'message':(context) => const MessagePage()
      },
    ); 
  }
}




// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   AwesomeNotifications().initialize(
//       null,
//       [
//         NotificationChannel(
//             channelKey: 'basic_channel',
//             channelName: 'Basic notifications',
//             channelDescription: 'Notification channel for basic tests',
//             defaultColor: Color(0xFF9D50DD),
//             ledColor: Colors.white
//         )
//       ]
//   );

//   FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);


//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: MyHomePage(title: 'Flutter Demo Home Page'),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   MyHomePage({Key? key, required this.title}) : super(key: key);

//   final String title;

//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {

//   @override
//   Widget build(BuildContext context) {

//     return Scaffold(
//       appBar: AppBar(

//         title: Text(widget.title),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             ElevatedButton(onPressed: (){
//               //local notification 
//                Notify();
//             }, child: const Text("Notify"))
//           ],
//         ),
//       ),
//     );
//   }
// }

// void Notify() async{
//   // local notification
//   AwesomeNotifications().createNotification(
//       content: NotificationContent(
//           id: 10,
//           channelKey: 'basic_channel',
//           title: 'Simple Notification',
//           body: 'Simple body',
//           bigPicture:'assets://images/protocoderlogo.png'
//       )
//   );

// }


// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {

//   print("Handling a background message: ${message.messageId}");

//   //firebase push notification
//   AwesomeNotifications().createNotificationFromJsonData(message.data);
// }