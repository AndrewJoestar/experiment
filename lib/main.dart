import 'package:flutter/material.dart';
import './Component/bottomnavbar.dart';
import './Component/bottomfloatingactionbutton.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo app',
      theme: ThemeData(
        colorScheme: .fromSeed(seedColor: Colors.amber),
      ),
      home: const MyHomePage(title: 'Home Page'),
      debugShowCheckedModeBanner: false,
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
  int _counter = 1;
  String halo = 'Hello World';

  void _incrementCounter() {
    setState(() {
      _counter*=2;
    });
  }

  void showText(){
    // String text = 'Hello World';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: ListView.builder(itemCount: 10,
        itemBuilder: (BuildContext context, int index){
        return ListTile(
          leading: const Icon(Icons.list),
          trailing: const Text("Done", style: TextStyle(fontSize: 15, color: Colors.green),
        ),
          title: Text("List item ${index+1}"),
        );
        },
      ),
      extendBody: true,//Optional
      floatingActionButton: MyFloatingActionButton(onPressed: _incrementCounter),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: MyBottomNavBar(),
    );
  }
}

