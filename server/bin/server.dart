import 'dart:async';
import 'dart:convert';

import 'package:stomp_dart_client/stomp_dart_client.dart';

void onConnect(StompFrame frame) {
  stompClient.subscribe(
    destination: '/topic/test/subscription',
    callback: (frame) {
      List<dynamic>? result = json.decode(frame.body!);
      print(result);
    },
  );

  Timer.periodic(const Duration(seconds: 10), (_) {
    stompClient.send(
      destination: '/app/test/endpoints',
      body: json.encode({'a': 123}),
    );
  });
}

final stompClient = StompClient(
  config: StompConfig(
    url: 'ws://localhost:61614',
    onConnect: onConnect,
    beforeConnect: () async {
      print('waiting to connect...');
      await Future.delayed(const Duration(milliseconds: 200));
      print('connecting...');
    },
    onWebSocketError: (dynamic error) => print(error.toString()),
    // stompConnectHeaders: {'Authorization': 'Bearer yourToken'},
    // webSocketConnectHeaders: {'Authorization': 'Bearer yourToken'},
  ),
);

void main() {
  stompClient.activate();
}

// import 'dart:async';

// import 'package:dart_amqp/dart_amqp.dart';
// import 'package:server/server.dart' as server;

// void main(List<String> arguments) async {

//   Client client = Client();

//   Channel channel = await client.channel(); // auto-connect to localhost:5672 using guest credentials
//   Queue queue = await channel.queue("hello");
//   Consumer consumer = await queue.consume();
//   consumer.listen((AmqpMessage message) {
//     // Get the payload as a string
//     print(" [x] Received string: ${message.payloadAsString}");

//     // Or unserialize to json
//     print(" [x] Received json: ${message.payloadAsJson}");

//     // Or just get the raw data as a Uint8List
//     print(" [x] Received raw: ${message.payload}");

//     // The message object contains helper methods for
//     // replying, ack-ing and rejecting
//     message.reply("world");
//   });

//   print('Hello world: ${server.calculate()}!');
// }
