import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:video_player/video_player.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import 'constants.dart';
import 'dialog.dart';
import 'player_notifier.dart';
import 'screen_set.dart';
import 'screen_set_options.dart';
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
  /// Videoni yuqori qismida chiqadigan nomi
  /// ushbu nom shu video qayta ko'rilganda pozitsiyasini saqlab qolish uchun ishlatilishi ham mumkin
  final String title;

  /// aktiv bo'lish rangi
  final Color primaryColor;

  /// noaktiv rangi
  final Color secondaryColor;

  /// ortqaga qaytish tugmasini borligi
  final bool canPop;

  /// Qo'shimcha hususiyatlardan foydalanishingiz mumkin
  final ScreenSetOptions? screenSetOptions;

  /// Videoga havola
  final String sourceUrl;

  /// Qo'shimcha tugmalar
  final List<Widget> tools;

  /// video pozitsiyasi o'zgarganda video pozitsiyasini(sekund) qaytaradi
  final Function(int position)? onPositionChange;

  const IPlayer({
    super.key,
    required this.title,
    required this.sourceUrl,
    this.onPositionChange,
    this.tools = const[],
    this.canPop = false,
    this.primaryColor = Colors.red,
    this.secondaryColor = Colors.grey,
    this.screenSetOptions,
  });

  @override
  State<IPlayer> createState() => _IPlayerState();
}

class _IPlayerState extends State<IPlayer> {
  /// Pastki va yuqoridagi hususiyatlarni ko'rinish
  bool _isBlocked = false;

  @override
  void initState() {
    WakelockPlus.enable();
    playerNotifier.initializeUrl(widget.sourceUrl);
    // _setAllOrientation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height / 600;
    width = MediaQuery.of(context).size.width / 600;
    arifmethic = (height + width) / 2;
    return PopScope(
      canPop: true,
      onPopInvoked: (canPop) => playerNotifier.back(),
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
                          onTapDown: (details) => playerNotifier.unHide(),
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
                                            valueListenable: playerNotifier.centerWidgets,
                                            builder: (context, snapshot, child) {
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
                                                    child: FaIcon(
                                                      FontAwesomeIcons.backward,
                                                      color: Colors.white,
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
                                                      child: FaIcon(
                                                        playerNotifier.playerController
                                                            .value.isPlaying
                                                            ? FontAwesomeIcons.pause
                                                            : FontAwesomeIcons.play,
                                                        color: Colors.white,
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
                                                    child: FaIcon(
                                                      FontAwesomeIcons.forward,
                                                      color: Colors.white,
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
                                    if(widget.canPop)
                                      IconButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                          playerNotifier.back();
                                        },
                                        icon: FaIcon(
                                          FontAwesomeIcons.arrowLeft,
                                          color: Colors.white,
                                          size: 22.o,
                                        ),
                                      ),
                                    Expanded(
                                      child: Text(
                                        widget.title,
                                        textAlign: TextAlign.center,
                                        maxLines: 2,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white,
                                          fontSize: 16.o,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                    if(widget.canPop)
                                      SizedBox(
                                        width: 20.o,
                                      ),
                                  ],
                                ),
                                const Spacer(),
                                ValueListenableBuilder(
                                  valueListenable: playerNotifier.slider,
                                  builder: (context, value ,child) {
                                    if (_isBlocked) {
                                      return const SizedBox();
                                    }
                                    return Slider(
                                      value: playerNotifier.slider.value,
                                      activeColor: widget.primaryColor,
                                      secondaryActiveColor: widget.secondaryColor,
                                      inactiveColor:
                                      widget.secondaryColor.withOpacity(0.5),
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
                                      _tool(
                                        onTap: () => setState(() {
                                          _isBlocked = !_isBlocked;
                                          playerNotifier.unHide();
                                        }),
                                        icon: FontAwesomeIcons.lockOpen,
                                      ),
                                    ]
                                        : [
                                      ValueListenableBuilder(
                                          valueListenable: playerNotifier.videoPosition,
                                          builder: (context, value, child) {
                                            if(widget.onPositionChange!= null){
                                              widget.onPositionChange!(playerNotifier.playerController.value.position.inSeconds);
                                            }
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
                                          icon: FontAwesomeIcons.film,
                                        ),
                                      _tool(
                                        onTap: () => setState(() {
                                          _isBlocked = !_isBlocked;
                                          playerNotifier.unHide();
                                        }),
                                        icon: FontAwesomeIcons.lock,
                                      ),
                                      _tool(
                                        onTap: _setSpeed,
                                        icon: FontAwesomeIcons.gaugeHigh,
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
                        Center(
                          child: CircularProgressIndicator(
                            backgroundColor: widget.primaryColor,
                          ),
                        )
                      ],
              );
            });
          }
        ),
      ),
    );
  }

  // @override
  // void dispose() {
  //   super.dispose();
  //   playerController.dispose();
  //
  // }

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
  final IconData icon;
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
        child: FaIcon(
          icon,
          size: 22.o,
          color: Colors.white,
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
