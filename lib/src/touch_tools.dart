import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:i_player/src/player.dart';
import 'package:screen_brightness/screen_brightness.dart';
import 'package:video_player/video_player.dart';

import 'player_notifier.dart';

/// ekranni bosib turishni boshqaruvchi widgetlar
/// video o'ng yoki chap tomonini uzoq bosib tursa faollashadi
class TouchTools extends StatefulWidget {
  final double height;
  final VideoPlayerController playerController;
  const TouchTools({
    super.key,
    this.height = 100,
    required this.playerController,
  });

  @override
  State<TouchTools> createState() => _TouchToolsState();
}

class _TouchToolsState extends State<TouchTools> {
  bool? isLeftAnimating;
  Timer? timer;
  final StreamController<int> leftController = StreamController<int>();
  final StreamController<int> rightController = StreamController<int>();
  int tick = 0;
  double brightness = 0.5, volume = 0.7;
  final screenBrightness = ScreenBrightness();
  bool brightnessSetting = false, volumeSetting = false;

  @override
  void dispose() {
    cancelTimer();
    super.dispose();
  }

  @override
  void initState() {
    try {
      volume = widget.playerController.value.volume;
      screenBrightness.current.then((value) => brightness = value);
    } catch (e) {
      print(e);
      throw 'Failed to get current brightness';
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        GestureDetector(
          onLongPressStart: (details) => startTimer(true),
          onLongPressEnd: (details) => cancelAnimating(),
          onVerticalDragStart: (details){
            brightnessSetting = true;
          },
          onVerticalDragEnd: (details){
            brightnessSetting = false;
            rightController.sink.add(1);
          },
          onVerticalDragCancel: (){
            brightnessSetting = false;
            rightController.sink.add(1);
          },
          onVerticalDragUpdate: (details) {
            setBrightness(details.primaryDelta ?? 0);
            rightController.sink.add(1);
          },
          child: StreamBuilder<int>(
              stream: leftController.stream,
              builder: (context, snapshot) {
                if(volumeSetting){
                  return SizedBox(
                    height: widget.height,
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: 10.o,
                        top: 10.o,
                        bottom: 10.o,
                      ),
                      child: Column(
                        children: [
                          FaIcon(
                            FontAwesomeIcons.volumeHigh,
                            size: 14.o,
                            color: Colors.white,
                          ),
                          SizedBox(height: 8.o),
                          Expanded(
                            child: RotatedBox(
                              quarterTurns: -1,
                              child: LinearProgressIndicator(
                                value: volume,
                                borderRadius: BorderRadius.circular(10.o),
                                backgroundColor: Colors.white.withOpacity(0.3),
                                valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
                return Container(
                  width: widget.height / 2,
                  height: widget.height,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(widget.height),
                      bottomRight: Radius.circular(widget.height),
                    ),
                    color: Colors.white
                        .withOpacity(isLeftAnimating == null ? 0 : 0.4),
                  ),
                  child: Center(
                    child: Transform.rotate(
                      angle: pi,
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AnimatedOpacity(
                            opacity:
                                isLeftAnimating != true || tick < 4 ? 0 : 1,
                            duration: const Duration(milliseconds: 300),
                            child: play,
                          ),
                          AnimatedOpacity(
                            opacity:
                                isLeftAnimating != true || tick > 2 && tick < 6
                                    ? 0
                                    : 1,
                            duration: const Duration(milliseconds: 300),
                            child: play,
                          ),
                          AnimatedOpacity(
                            opacity:
                                isLeftAnimating != true || tick > 3 && tick < 7
                                    ? 0
                                    : 1,
                            duration: const Duration(milliseconds: 300),
                            child: play,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
        ),
        const Spacer(),
        GestureDetector(
          onLongPressStart: (details) => startTimer(false),
          onLongPressEnd: (details) => cancelAnimating(),
          onVerticalDragStart: (details){
            volumeSetting = true;
          },
          onVerticalDragEnd: (details){
            volumeSetting = false;
            leftController.sink.add(1);
          },
          onVerticalDragCancel: (){
            volumeSetting = false;
            leftController.sink.add(1);
          },
          onVerticalDragUpdate: (details) {
            setVolume(details.primaryDelta ?? 0);
            leftController.sink.add(1);
          },
          child: StreamBuilder<int>(
              stream: rightController.stream,
              builder: (context, snapshot) {
                if(brightnessSetting){
                  return SizedBox(
                    height: widget.height,
                    child: Padding(
                      padding: EdgeInsets.only(
                        right: 10.o,
                        top: 10.o,
                        bottom: 10.o,
                      ),
                      child: Column(
                        children: [
                          FaIcon(
                            FontAwesomeIcons.sun,
                            size: 14.o,
                            color: Colors.white,
                          ),
                          SizedBox(height: 8.o),
                          Expanded(
                            child: RotatedBox(
                              quarterTurns: -1,
                              child: LinearProgressIndicator(
                                value: brightness,
                                borderRadius: BorderRadius.circular(10.o),
                                backgroundColor: Colors.white.withOpacity(0.3),
                                valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
                return Container(
                  width: widget.height / 2,
                  height: widget.height,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(widget.height),
                      bottomLeft: Radius.circular(widget.height),
                    ),
                    color: Colors.white
                        .withOpacity(isLeftAnimating == null ? 0 : 0.4),
                  ),
                  child: Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AnimatedOpacity(
                          opacity: isLeftAnimating != false || tick < 4 ? 0 : 1,
                          duration: const Duration(milliseconds: 300),
                          child: play,
                        ),
                        AnimatedOpacity(
                          opacity:
                              isLeftAnimating != false || tick > 2 && tick < 6
                                  ? 0
                                  : 1,
                          duration: const Duration(milliseconds: 300),
                          child: play,
                        ),
                        AnimatedOpacity(
                          opacity:
                              isLeftAnimating != false || tick > 3 && tick < 7
                                  ? 0
                                  : 1,
                          duration: const Duration(milliseconds: 300),
                          child: play,
                        ),
                      ],
                    ),
                  ),
                );
              }),
        ),
      ],
    );
  }

  void setBrightness(double delta) {
    double newBrightness = brightness - (delta / 100);
    if (newBrightness > 1) {
      newBrightness = 1;
    }
    if (newBrightness < 0) {
      newBrightness = 0;
    }
    try {
      screenBrightness
          .setScreenBrightness(newBrightness)
          .then((value){
        brightness = newBrightness;
      });
    } catch (e) {
      debugPrint(e.toString());
      throw 'Failed to get current brightness';
    }
  }

  void setVolume(double delta) {
    double newVolume = volume - (delta / 100);
    if (newVolume > 1) {
      newVolume = 1;
    }
    if (newVolume < 0) {
      newVolume = 0;
    }
    volume = newVolume;
    widget.playerController.setVolume(volume);
  }

  void startTimer(bool leftAnimating) {
    if (isLeftAnimating != null) {
      return;
    }
    isLeftAnimating = leftAnimating;
    if (isLeftAnimating!) {
      leftController.sink.add(tick);
    } else {
      rightController.sink.add(tick);
    }
    timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (tick > 5) {
        tick = 0;
      }
      int seconds = widget.playerController.value.position.inSeconds;
      if (isLeftAnimating!) {
        if (seconds > 10) {
          seconds -= 10;
          if (tick == 1) {
            widget.playerController.seekTo(Duration(seconds: seconds));
          }
        }
        leftController.sink.add(tick);
      } else {
        if (seconds < widget.playerController.value.duration.inSeconds - 10) {
          seconds += 10;
          if (tick == 1) {
            widget.playerController.seekTo(Duration(seconds: seconds));
          }
        }
        rightController.sink.add(tick);
      }
      tick++;
    });
  }

  void cancelAnimating() {
    if (isLeftAnimating == null) {
      return;
    }
    cancelTimer();
    isLeftAnimating = null;
    leftController.sink.add(tick);
    rightController.sink.add(tick);
  }

  void cancelTimer() {
    if (timer != null) {
      timer!.cancel();
    }
  }

  Widget get play => const FaIcon(
        FontAwesomeIcons.play,
        size: 15,
        color: Colors.white,
      );
}
