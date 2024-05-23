import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class IplayerTheme{
  /// aktiv bo'lish rangi
  final Color primaryColor;

  /// noaktiv rangi
  final Color secondaryColor;

  /// Videoni yuqori qismida chiqadigan widget
  final Widget title;

  /// video yuklanguncha markazda chiqadigan widget
  final Widget loadIndicator;

  /// ortqaga qaytish tugmasini borligi
  // agar ushbu icon null bo'lmasa Navigator.pop ishlaydi.
  final IconSourceData? back;

  /// ortga qaytish uchun ishlatiladigan widget
  final IconSourceData left;

  /// ortga qaytish uchun ishlatiladigan widget
  final IconSourceData right;

  /// ortga qaytish uchun ishlatiladigan widget
  final IconSourceData play;

  /// ortga qaytish uchun ishlatiladigan widget
  final IconSourceData pause;

  /// ortga qaytish uchun ishlatiladigan widget
  final IconSourceData quality;

  /// ortga qaytish uchun ishlatiladigan widget
  final IconSourceData speed;

  /// ortga qaytish uchun ishlatiladigan widget
  final IconSourceData? block;

  /// ortga qaytish uchun ishlatiladigan widget
  final IconSourceData? unBlock;

  const IplayerTheme({
    this.primaryColor = Colors.red,
    this.secondaryColor = Colors.grey,
    this.title = const SizedBox(),
    required this.loadIndicator,
    this.back,
    required this.left,
    required this.right,
    required this.play,
    required this.pause,
    required this.quality,
    required this.speed,
    this.block,
    this.unBlock,
}):
      //agar
        assert (block != null ? unBlock != null : true);

  IplayerTheme copyWith({
    Color? primaryColor,
    Color? secondaryColor,
    Widget? title,
    Widget? loadIndicator,
    IconSourceData? back,
    IconSourceData? left,
    IconSourceData? right,
    IconSourceData? play,
    IconSourceData? pause,
    IconSourceData? quality,
    IconSourceData? speed,
    IconSourceData? block,
    IconSourceData? unBlock,
}) => IplayerTheme(
    primaryColor: primaryColor ?? this.primaryColor,
    secondaryColor: secondaryColor ?? this.secondaryColor,
    title: title ?? this.title,
    loadIndicator: loadIndicator ?? this.loadIndicator,
    back: back ?? this.back,
    left: left ?? this.left,
    right: right ?? this.right,
    play: play ?? this.play,
    pause: pause ?? this.pause,
    quality: quality ?? this.quality,
    speed: speed ?? this.speed,
    block: block ?? this.block,
    unBlock: unBlock ?? this.unBlock,
  );
}

class IconSourceData{
  final IconData? icon;
  final String? imageAsset;
  final String? svgAsset;
  final Color color;

  const IconSourceData({
    this.icon,
    this.imageAsset,
    this.svgAsset,
    this.color = Colors.white,
  }) : assert (icon != null || imageAsset != null || svgAsset != null);
}

const defaultIPlayerTheme = IplayerTheme(
  left: IconSourceData(icon: FontAwesomeIcons.backward),
  right: IconSourceData(icon: FontAwesomeIcons.forward),
  play: IconSourceData(icon: FontAwesomeIcons.play),
  pause: IconSourceData(icon: FontAwesomeIcons.pause),
  quality: IconSourceData(icon: FontAwesomeIcons.film),
  speed: IconSourceData(icon: FontAwesomeIcons.gaugeHigh),
  block: IconSourceData(icon: FontAwesomeIcons.lock),
  unBlock: IconSourceData(icon: FontAwesomeIcons.lockOpen),
  loadIndicator: CircularProgressIndicator(
    backgroundColor: Colors.red,
  ),
);