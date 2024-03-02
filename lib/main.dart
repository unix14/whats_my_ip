import 'package:dart_ipify/dart_ipify.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'What\'s My IP?',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'What\'s My IP?'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String currentIp = "N/A";

  @override
  void initState() {
    _calculateIp();
    super.initState();
  }

  _calculateIp() async {
    var ipv4 = await Ipify.ipv64();
    setState(() {
      currentIp = ipv4;
    });
  }

  @override
  Widget build(BuildContext context) {
    //todo add ads here
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.onTertiaryFixed,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Your IP address is:',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            Text(
              currentIp,
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 18),
              child: IconButton.outlined(
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: currentIp));
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("IP was copied"),
                  ));
                },
                icon: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(Icons.copy),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}