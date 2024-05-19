
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import 'dialog.dart';
import 'quality_loader.dart';

PlayerNotifier? _playerNotifier;

PlayerNotifier get playerNotifier {
  _playerNotifier ??= PlayerNotifier();
  return _playerNotifier!;
}

class PlayerNotifier with ChangeNotifier {
  late VideoPlayerController playerController;

  /// Video qaysi soniyasi qo'yilayotganini boshqaradi
  final ValueNotifier<double> videoPosition = ValueNotifier(0);

  /// Markazdagi widgetlarni boshqaradi
  final ValueNotifier<bool> centerWidgets = ValueNotifier(true);

  /// Sliderni pozitsiyasini anglatadi.
  final ValueNotifier<double> slider = ValueNotifier(0);

  /// Agar true bo'lsa slider ayni vaqtda barmoq bilan surilmoqdaligini anglatadi.
  bool isSliderTouch = false;

  /// vidgetlari ko'rinmaydigan holatgacha qolgan vaqt (sekund)
  int toHideTimeOut = 8;

  /// vidgetlarning yopilishini boshqaradi.
  Timer? _hideTimer;

  /// agar video sifatini tanlash mumkin bo'lgan formatda (m3u8) bo'lsa
  /// video sifatini tanlanishi mumkin.
  List<String>? qualityList;

  /// boshqaruv widgetlarini yashirilishini boshqaradi
  final ValueNotifier<bool> hideController = ValueNotifier(false);

  /// boshlang'ich video havolasi
  String _initialUrl = '';

  void initializeUrl(String link) {
    if(_initialUrl != link){
      if(_initialUrl.isNotEmpty){
        playerController.removeListener(() {});
        playerController.dispose();
      }
      _initialUrl = link;
      setPlayer();
    }
  }

  @override
  void dispose() {
    super.dispose();
    playerController.dispose();
    if (_hideTimer != null) {
      _hideTimer!.cancel();
    }
  }

  void setPlayer() async {
    if (_initialUrl.contains('http')) {
      playerController =
      VideoPlayerController.networkUrl(Uri.parse(_initialUrl))
        ..initialize().then((_) {
          bool playingValue = false, buferingValue = false;
          playerController.play();
          playerController.addListener(() {
            if (playerController.value.isCompleted) {
              WakelockPlus.disable();
            }
            if (!isSliderTouch &&
                !playerController.value.isBuffering &&
                playerController.value.duration != Duration.zero) {
              int duration = playerController.value.duration.inMilliseconds;
              int position = playerController.value.position.inMilliseconds;
              if(duration > 0 && position <= duration){
                slider.value = position / duration;
                videoPosition.value = position.toDouble();
              }
            }
            if (playerController.value.isPlaying != playingValue ||
                playerController.value.isBuffering != buferingValue) {
              playingValue = playerController.value.isPlaying;
              buferingValue = playerController.value.isBuffering;
              centerWidgets.value = playingValue;
            }
          });
          unHide();
          notifyListeners();
        });
    }
  }

  void unHide() {
    if (toHideTimeOut == 0 || _hideTimer == null) {
      if (_hideTimer != null) {
        _hideTimer!.cancel();
      }
      hideController.value = false;
      centerWidgets.value = false;
      toHideTimeOut = 8;
      _hideTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (playerController.value.isPlaying) {
          if (toHideTimeOut <= 0) {
            _hideTimer!.cancel();
            _hideTimer = null;
            hideController.value = false;
            centerWidgets.value = true;
          } else {
            toHideTimeOut--;
          }
        }
      });
    } else {
      toHideTimeOut = 8;
    }
  }

  void selectQuality(BuildContext context) async {
    qualityList ??= await hLSQualityLoader.getQualities(_initialUrl);
    if (qualityList == null) {
      return;
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return PlayerSourseDialog(
          data: List<String>.generate(qualityList!.length,
                  (index) => qualityList![index].split('_')[1].split('.').first),
          onSelect: (int index) {
            final position = playerController.value.position.inMilliseconds;
            playerController.pause();
            playerController.removeListener(() {});
            final loadUrl = _initialUrl
                .substring(0, _initialUrl.lastIndexOf('/') + 1) +
                qualityList![index];
            playerController =
            VideoPlayerController.networkUrl(Uri.parse(loadUrl))
              ..initialize().then((_) {
                playerController.play();
                playerController.seekTo(Duration(seconds: position));
                bool playingValue = false, buferingValue = false;
                playerController.addListener(() {
                  if (playerController.value.isCompleted) {
                    WakelockPlus.disable();
                  }
                  if (!isSliderTouch &&
                      !playerController.value.isBuffering &&
                      playerController.value.duration != Duration.zero) {
                    int duration = playerController.value.duration.inMilliseconds;
                    int position = playerController.value.position.inMilliseconds;
                    if(duration > 0 && position <= duration){
                      slider.value = position / duration;
                      videoPosition.value = position.toDouble();
                    }
                  }
                  if (playerController.value.isPlaying != playingValue ||
                      playerController.value.isBuffering != buferingValue) {
                    playingValue = playerController.value.isPlaying;
                    buferingValue = playerController.value.isBuffering;
                    centerWidgets.value = playingValue;
                  }
                });
                unHide();
                notifyListeners();
              });
          },
        );
      },
    );
  }

  void back() {
    playerController.dispose();
    _initialUrl = '';
  }

}
