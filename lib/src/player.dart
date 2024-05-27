import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:video_player/video_player.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import 'constants.dart';
import 'dialog.dart';
import 'icon.dart';
import 'player_notifier.dart';
import 'screen_set.dart';
import 'screen_set_options.dart';
import 'theme.dart';
import 'touch_tools.dart';

double height = 1, width = 1, arifmethic = 1; //size variables

extension ExtSize on num {
  double get h {
    return this * height;
  }

  double get w {
    return this * width;
  }

  double get o {
    return this * arifmethic;
  }
}

class IPlayer extends StatefulWidget {
  /// Qo'shimcha hususiyatlardan foydalanishingiz mumkin
  final ScreenSetOptions? screenSetOptions;

  /// Videoga havola
  final String sourceUrl;

  /// Qo'shimcha tugmalar
  final List<Widget> tools;

  /// Qo'shimcha tugmalar
  final IplayerTheme theme;

  /// video pozitsiyasi o'zgarganda video pozitsiyasini(sekund) qaytaradi
  /// 0 >= position <= 1 oralig'ida bo'ladi
  final Function(int position, int duration)? onPositionChange;

  /// player yopilganda ishga tushadi
  final Function(int position, int duration)? onBack;

  const IPlayer({
    super.key,
    required this.sourceUrl,
    this.theme = const IplayerTheme(),
    this.tools = const[],
    this.screenSetOptions,
    this.onBack,
    this.onPositionChange,
  });

  @override
  State<IPlayer> createState() => _IPlayerState();
}

class _IPlayerState extends State<IPlayer> {
  /// Pastki va yuqoridagi hususiyatlarni ko'rinish
  bool _isBlocked = false;

  /// agar canpop = true bo'lsa ekran full screen deb qaraladi
  /// qurilmani avvalgi saqlab turish uchun
  Orientation? initialOrientation;

  @override
  void initState() {
    WakelockPlus.enable();
    playerNotifier.initializeUrl(widget.sourceUrl);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if(widget.theme.back != null && initialOrientation == null){
      WidgetsFlutterBinding.ensureInitialized();
      initialOrientation = MediaQuery.of(context).orientation;
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height / 600;
    width = MediaQuery.of(context).size.width / 600;
    arifmethic = (height + width) / 2;
    return PopScope(
      canPop: true,
      onPopInvoked: (canPop) => playerNotifier.back(true),
      child: Scaffold(
        backgroundColor: Colors.black,
        body: ListenableBuilder(
          listenable: playerNotifier,
          builder: (context, child) {
            return OrientationBuilder(builder: (context, orientation) {
              return Stack(
                alignment: Alignment.center,
                children: playerNotifier.playerController.value.isInitialized
                    ? [
                        GestureDetector(
                          onTapUp: (details) {
                            if(playerNotifier.playerController.value.isPlaying){
                              if(!playerNotifier.hideController.value){
                                Future.delayed(const Duration(milliseconds: 1)).then((v){
                                  playerNotifier.toHideTimeOut = 0;
                                  playerNotifier.hideController.value = true;
                                  playerNotifier.playingNotifier.value = !playerNotifier.playingNotifier.value;
                                });
                                return;
                              }
                            }
                            //playerNotifier.unHide();
                            playerNotifier.unHide();
                          },
                          onLongPressStart: (details) => playerNotifier.playerController.pause(),
                          onLongPressEnd: (details) => playerNotifier.playerController.play(),
                          child: InteractiveViewer(
                            minScale: 1,
                            maxScale: 1.6,
                            constrained: true,
                            panEnabled: false,
                            scaleEnabled: orientation == Orientation.landscape,
                            child: SafeArea(
                              child: Center(
                                child: SizedBox(
                                  width: 600.w,
                                  height: 600.w / playerNotifier.playerController.value.aspectRatio,
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: AspectRatio(
                                              aspectRatio:
                                              playerNotifier.playerController.value.aspectRatio,
                                              child: Stack(
                                                children: [
                                                  VideoPlayer(playerNotifier.playerController),
                                                  if(widget.screenSetOptions != null)
                                                    ScreenSet(
                                                      options: widget.screenSetOptions!,
                                                    ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      if (!_isBlocked)
                                        Center(
                                          child: ValueListenableBuilder(
                                            valueListenable: playerNotifier.playingNotifier,
                                            builder: (context, isPlaying, child) {
                                              if (playerNotifier.toHideTimeOut <= 0) {
                                                return const SizedBox();
                                              }
                                              return Row(
                                                crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  GestureDetector(
                                                    onTap: () {
                                                      int seconds = playerNotifier.playerController
                                                          .value.position.inSeconds;
                                                      if (seconds > 10) {
                                                        seconds -= 10;
                                                        playerNotifier.playerController.seekTo(
                                                            Duration(
                                                                seconds: seconds));
                                                      }
                                                      playerNotifier.unHide();
                                                    },
                                                    child: IplayerIcon(
                                                      data: widget.theme.left,
                                                      size: 32.o,
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.all(16.o),
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        if (playerNotifier.playerController
                                                            .value.isPlaying) {
                                                          playerNotifier.playerController.pause();
                                                        } else {
                                                          playerNotifier.playerController.play();
                                                        }
                                                        playerNotifier.unHide();
                                                      },
                                                      child: IplayerIcon(
                                                        data: playerNotifier.playerController
                                                            .value.isPlaying
                                                            ? widget.theme.pause
                                                            : widget.theme.play,
                                                        size: 48.o,
                                                      ),
                                                    ),
                                                  ),
                                                  GestureDetector(
                                                    onTap: () {
                                                      int seconds = playerNotifier.playerController
                                                          .value.position.inSeconds;
                                                      if (seconds <
                                                          playerNotifier.playerController
                                                              .value
                                                              .duration
                                                              .inSeconds -
                                                              10) {
                                                        seconds += 10;
                                                        playerNotifier.playerController.seekTo(
                                                            Duration(
                                                                seconds: seconds));
                                                      }
                                                      playerNotifier.unHide();
                                                    },
                                                    child: IplayerIcon(
                                                      data: widget.theme.right,
                                                      size: 32.o,
                                                    ),
                                                  ),
                                                ],
                                              );
                                            },
                                          ),
                                        ),
                                      if (!_isBlocked)
                                        TouchTools(
                                          height: 600.w /
                                              playerNotifier.playerController.value.aspectRatio,
                                          playerController: playerNotifier.playerController,
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        ValueListenableBuilder(
                          valueListenable: playerNotifier.hideController,
                          builder: (context, isHide ,child) => isHide
                              ? const SizedBox()
                              : child!,
                          child: SafeArea(
                            bottom: false,
                            child: Column(
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    if(widget.theme.back != null)
                                      IconButton(
                                        onPressed: () {
                                          playerNotifier.back(true);
                                          Navigator.pop(context);
                                        },
                                        icon: IplayerIcon(
                                          data: widget.theme.back!,
                                          size: 22.o,
                                        ),
                                      ),
                                    Expanded(
                                      child: widget.theme.title
                                    ),
                                    if(widget.theme.back != null)
                                      SizedBox(
                                        width: 20.o,
                                      ),
                                  ],
                                ),
                                const Spacer(),
                                ValueListenableBuilder(
                                  valueListenable: playerNotifier.slider,
                                  builder: (context, value ,child) {
                                    if(widget.onPositionChange!= null){
                                      widget.onPositionChange!(
                                        playerNotifier.playerController.value.position.inSeconds,
                                        playerNotifier.playerController.value.duration.inSeconds,
                                      );
                                    }
                                    if (_isBlocked) {
                                      return const SizedBox();
                                    }
                                    return Slider(
                                      value: playerNotifier.slider.value,
                                      activeColor: widget.theme.primaryColor,
                                      secondaryActiveColor: widget.theme.secondaryColor,
                                      inactiveColor:
                                      widget.theme.secondaryColor.withOpacity(0.5),
                                      onChangeStart: (value) =>
                                      playerNotifier.isSliderTouch = true,
                                      onChangeEnd: (newValue) {
                                        playerNotifier.slider.value = newValue;
                                        playerNotifier.playerController
                                            .seekTo(Duration(
                                            milliseconds: (playerNotifier.playerController
                                                .value
                                                .duration
                                                .inMilliseconds *
                                                playerNotifier.slider.value)
                                                .toInt()))
                                            .then((value) =>
                                        playerNotifier.isSliderTouch = false);
                                      },
                                      onChanged: (double newValue) {
                                        playerNotifier.slider.value = newValue;
                                        playerNotifier.unHide();
                                      },
                                    );
                                  },
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                    left: 16.o,
                                    right: 8.o,
                                  ),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: _isBlocked
                                        ? [
                                      const Spacer(),
                                      if(widget.theme.unBlock != null)
                                        _tool(
                                          onTap: () => setState(() {
                                            _isBlocked = !_isBlocked;
                                            playerNotifier.unHide();
                                          }),
                                          icon: widget.theme.unBlock!,
                                        ),
                                    ]
                                        : [
                                      ValueListenableBuilder(
                                          valueListenable: playerNotifier.videoPosition,
                                          builder: (context, value, child) {
                                            return Text(
                                              '${_videoPosition(playerNotifier.playerController.value.position)} / ${_videoPosition(playerNotifier.playerController.value.duration)}',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w400,
                                                fontSize: 16.o,
                                                color: Colors.white,
                                              ),
                                            );
                                          }),
                                      const Spacer(),
                                      if (widget.sourceUrl
                                          .contains('.m3u8'))
                                        _tool(
                                          onTap: () => playerNotifier.selectQuality(context),
                                          icon: widget.theme.quality,
                                        ),
                                      if(widget.theme.block != null)
                                        _tool(
                                          onTap: () => setState(() {
                                            _isBlocked = !_isBlocked;
                                            playerNotifier.unHide();
                                          }),
                                          icon: widget.theme.block!,
                                        ),
                                      _tool(
                                        onTap: _setSpeed,
                                        icon: widget.theme.speed,
                                      ),
                                      ...widget.tools,
                                    ],
                                  ),
                                ),
                                if (Platform.isIOS)
                                  SizedBox(
                                    height: 12.o,
                                  )
                              ],
                            ),
                          ),
                        ),
                      ]
                    : [
                        Center(child: widget.theme.loadIndicator)
                      ],
              );
            });
          }
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    if(widget.onBack != null){
      widget.onBack!(
        playerNotifier.playerController.value.position.inSeconds,
        playerNotifier.playerController.value.duration.inSeconds,
      );
    }

    if(widget.theme.back != null && initialOrientation == null){
      SystemChrome.setPreferredOrientations(
          initialOrientation == Orientation.landscape ?[
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
          ]:[
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
          ],
      );
    }
  }

  void _setSpeed() => showDialog(
        context: context,
        builder: (BuildContext context) {
          return PlayerSourseDialog(
            data: speedTitles,
            onSelect: (int index) =>
                playerNotifier.playerController.setPlaybackSpeed(speedValues[index]),
          );
        },
      );

}

class _tool extends StatelessWidget {
  final Function() onTap;
  final IconSourceData icon;
  const _tool({required this.onTap, required this.icon});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.only(
          left: 10.o,
          right: 10.o,
          bottom: 10.o,
        ),
        color: Colors.transparent,
        child: IplayerIcon(
          data: icon,
          size: 22.o,
        ),
      ),
    );
  }
}

String _videoPosition(Duration duration) {
  final hours = _toDigits(duration.inHours);
  final minutes = _toDigits(duration.inMinutes.remainder(60));
  final seconds = _toDigits(duration.inSeconds.remainder(60));
  return [if (duration.inHours > 0) hours, minutes, seconds].join(':');
}

String _toDigits(int n) => n.toString().padLeft(2, '0');
