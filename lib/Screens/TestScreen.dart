import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unify/FireService.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({Key? key}) : super(key: key);

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  @override
  Widget build(BuildContext context) {
    var fireService = Provider.of<FireService>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Testing Screen"),
      ),
      body: Column(
        children: [
          ElevatedButton(
              onPressed: () {
                fireService.testGet();
              },
              child: Text("Test Get"))
        ],
      ),
    );
  }
}
