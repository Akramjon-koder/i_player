import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:i_player/i_player.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  double width = 1;
  ScreenSetOptions get options => const ScreenSetOptions(
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
    ],
  );

  ValueNotifier<Orientation> orientationNotifier = ValueNotifier(Orientation.portrait);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    return MaterialApp(
      home: ValueListenableBuilder(
        valueListenable: orientationNotifier,
        child: IPlayer(
          title: 'Video name',
          onPositionChange: (position){
            ///save position
          },
          tools: [
            GestureDetector(
              onTap: (){
                print('object');
                SystemChrome.setPreferredOrientations(
                    orientationNotifier.value == Orientation.portrait ? [
                  DeviceOrientation.landscapeRight,
                  DeviceOrientation.landscapeLeft
                ] : [
                  DeviceOrientation.portraitDown,
                  DeviceOrientation.portraitUp
                ]);
                orientationNotifier.value =
                orientationNotifier.value == Orientation.portrait
                    ? Orientation.landscape
                    : Orientation.portrait;
              },
              child: Container(
                padding: EdgeInsets.only(
                  left: 10.o,
                  right: 10.o,
                  bottom: 10.o,
                ),
                color: Colors.transparent,
                child: ValueListenableBuilder(
                  valueListenable: orientationNotifier,
                  builder: (context, orientation, child) => FaIcon(
                    orientation == Orientation.portrait
                        ? FontAwesomeIcons.expand
                        : FontAwesomeIcons.compress,
                    size: 22.o,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
          sourceUrl: 'https://demo.unified-streaming.com/k8s/features/stable/video/tears-of-steel/tears-of-steel.ism/.m3u8',
          screenSetOptions: options,
        ),
        builder: (context, orientation, child) {
          print('orientation: $orientation');
          if(orientation == Orientation.landscape){
            return child!;
          }
          return Center(
            child: SizedBox(
              width: width,
              height: width * 9 / 16,
              child: child,
            ),
          );
        },
      ),
    );
  }
}
