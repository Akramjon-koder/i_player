import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:i_player/i_player.dart';

class Example1 extends StatefulWidget {
  const Example1({super.key});

  @override
  State<Example1> createState() => _Example1State();
}

class _Example1State extends State<Example1> {
  double width = 1;
  ScreenSetOptions get options => const ScreenSetOptions(
    unActiveDuration: 4,
    activeDuration: 1,
    maxOpasity: 1,
    minOpasity: 0.5,
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
      null,
      null,
      null,
      null,
      null,
      Alignment.topLeft,
      Alignment.bottomRight,
      Alignment.center,
    ],
  );

  ValueNotifier<Orientation> orientationNotifier = ValueNotifier(Orientation.portrait);

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: ValueListenableBuilder(
        valueListenable: orientationNotifier,
        child: IPlayer(
          theme: const IplayerTheme(
            title: Text(
              'Video name',
              textAlign: TextAlign.center,
              maxLines: 2,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.white,
                fontSize: 16,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          onPositionChange: (position,duration){
            ///save position
          },
          tools: [
            GestureDetector(
              onTap: (){
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
                padding: const EdgeInsets.only(
                  left: 12,
                  right: 12,
                  bottom: 12,
                ),
                color: Colors.transparent,
                child: ValueListenableBuilder(
                  valueListenable: orientationNotifier,
                  builder: (context, orientation, child) => FaIcon(
                    orientation == Orientation.portrait
                        ? FontAwesomeIcons.expand
                        : FontAwesomeIcons.compress,
                    size: 26,
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
