import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:i_player/i_player.dart';

class Example2 extends StatelessWidget {
  const Example2({super.key});
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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(
              builder: (context) => IPlayer(
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
                  back: IconSourceData(
                    // svgAsset: 'assets/icons/back.svg',
                    //imageAsset: 'assets/images/back.png',
                    icon: Icons.arrow_back,
                  ),
                ),
                onPositionChange: (position,duration){
                  ///save position
                },
                onBack: (position,duration){
                  ///do some thing
                },
                sourceUrl: 'https://demo.unified-streaming.com/k8s/features/stable/video/tears-of-steel/tears-of-steel.ism/.m3u8',
                screenSetOptions: options,
              ),
            ));
          },
          child: const Text(
              'Navigate to full screen player'
          ),
        ),
      ),
    );
  }
}

