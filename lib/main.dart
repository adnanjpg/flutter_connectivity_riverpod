import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}

var connectionProvider = StateProvider((ref) => false);

class MyApp extends ConsumerWidget {
  MyApp({Key? key}) : super(key: key);

  bool inited = false;

  initListener(WidgetRef ref) {
    if (!inited) {
      inited = true;
      Connectivity().onConnectivityChanged.listen(
        (ConnectivityResult result) {
          debugPrint('changed');
          ref.read(connectionProvider.notifier).state =
              result != ConnectivityResult.none;
        },
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    initListener(ref);

    final isConnected = ref.watch(connectionProvider);

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Builder(
            builder: (context) {
              final data = isConnected ? 'connected' : 'disconnected';
              return Text(data);
            },
          ),
        ),
      ),
    );
  }
}
