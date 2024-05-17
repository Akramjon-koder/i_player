import 'package:flutter/material.dart';
import 'package:i_player/i_player.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: IPlayer(
        title: 'Flutter Demo IPlayer',
        sourceUrl: 'https://live-par-2-cdn-alt.livepush.io/live/bigbuckbunnyclip/index.m3u8',
        screenSetOptions: ScreenSetOptions(
            unActiveDuration: 5,
            activeDuration: 1,
            maxOpasity: 1,
            minOpasity: 0.1,
            isScreenSecure: true,
            pauseWhenRecording: true,
            screenRecordedText: 'Don\'t record screen',
            logo: Text(
              'IPlayer',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            positions: [
              Alignment.topLeft,
              Alignment.topRight,
              Alignment.center,
              Alignment.bottomRight,
              Alignment.bottomLeft,
              Alignment.center,
            ]
        ),
      ),
    );
  }
}
