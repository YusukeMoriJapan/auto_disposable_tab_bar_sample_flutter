import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'auto_disposable_tab_bar_view_impl.dart';

const tabSize = 3;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AutoDisposableTabBar Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends HookConsumerWidget {
  const MyHomePage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tabController = useTabController(initialLength: 3);
    final tabs = List.generate(
      tabSize,
      (index) => Text(
        'tab$index',
        style: const TextStyle(fontSize: 24, color: Colors.black),
      ),
    );

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              color: Colors.amberAccent,
              child: TabBar(
                controller: tabController,
                tabs: tabs,
              ),
            ),
            Expanded(
              child: AutoDisposableTabBarViewImpl(controller: tabController),
            ),
          ],
        ),
      ),
    );
  }
}
