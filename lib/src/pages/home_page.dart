import 'package:flutter/material.dart';
import 'package:test_notification_push/src/provider/push_notification_provider.dart';

class HomePage extends StatelessWidget {
  HomePage({ Key? key }) : super(key: key);
  final value = PushNotificationService.message;
  final value1 = PushNotificationService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: const Center(
        child: Text('Home Page'),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            child: const Icon(Icons.subscriptions_rounded),
            onPressed: () async => await value.subscribeToTopic('Hola')
          ),
          const SizedBox(height: 10,),
          FloatingActionButton(
            child: const Icon(Icons.notification_important_rounded),
            onPressed: () async => await value1.localNotification()
          ),
          const SizedBox(height: 10,),
          FloatingActionButton(
            child: const Icon(Icons.unsubscribe_rounded),
            onPressed: () async => await value.unsubscribeFromTopic('Hola')
          ),
        ],
      )
    );
  }
}