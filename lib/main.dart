import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart'; 
import 'package:web_socket_channel/web_socket_channel.dart'; 

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mouse Controller',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: MouseController(),
    );
  }
}

class MouseController extends StatefulWidget {
  @override
  _MouseControllerState createState() => _MouseControllerState();
}

class _MouseControllerState extends State<MouseController> {
  WebSocketChannel? _webSocketChannel;

  @override
  void initState() {
    super.initState();
    _connectWebSocket();
    _listenGyroscope();
  }

  void _connectWebSocket() {
    _webSocketChannel = WebSocketChannel.connect(
      Uri.parse('ws://192.168.1.101:8080'), // Substitua pelo IP e porta do servidor
    );
  }

  void _listenGyroscope() {
    // Usando o método gyroscopeEventStream()
    gyroscopeEventStream(samplingPeriod: Duration(milliseconds: 100)).listen((GyroscopeEvent event) {
      if (_webSocketChannel != null) {
        String message = 'x:${event.x},y:${event.y},z:${event.z}';
        _webSocketChannel!.sink.add(message);
      }
    });
  }

  @override
  void dispose() {
    _webSocketChannel?.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Mouse Controller')),
      body: Center(child: Text('Move seu celular para controlar o mouse')),
    );
  }
}
