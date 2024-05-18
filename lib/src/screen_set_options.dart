import 'package:flutter/material.dart';

class ScreenSetOptions{
  /// Logotip boradigan joylar
  final List<Alignment> positions;

  /// faol emas bo'lish vaqti (sekund)
  final int unActiveDuration;

  /// faol emas bo'lish vaqti (sekund)
  final int activeDuration;

  /// faol bo'lgan vaqtdagi maksimal ko'rinishi
  /// 0 dan katta va 1 dan kichik qiymatlarni qabul qiladi
  final double maxOpasity;

  /// faol bo'lgan vaqtdagi minimal shaffofligi
  /// 0 dan katta va 1 dan kichik qiymatlarni qabul qiladi
  final double minOpasity;

  /// ekranni yozib olishdan himoya qilish
  final bool isScreenSecure;

  /// agar ekran yozib olinayotgan bo'lsa video'ni to'xtatish
  final bool pauseWhenRecording;

  /// Ekran yozib olinayotganda chiqadigan text
  final String screenRecordedText;

  /// Ekran yozib olinayotganda chiqadigan text
  final Widget logo;

  const ScreenSetOptions({
    this.positions = const[],
    this.activeDuration = 1,
    this.unActiveDuration = 59,
    this.maxOpasity = 0.9,
    this.minOpasity = 0.1,
    this.isScreenSecure = false,
    this.pauseWhenRecording = false,
    this.screenRecordedText = '',
    this.logo = const SizedBox(),
  }):
        assert(activeDuration >= 1),
        assert(unActiveDuration >= 1),
        assert(minOpasity >= 0),
        assert(maxOpasity >= minOpasity);


  factory ScreenSetOptions.fromJson(Map<String, dynamic> json) => ScreenSetOptions(
    positions: json['positions'] is List
        ? List<Alignment>.from(json['positions'].map((align) => Alignment(align['x'], align['y'])))
        : [],
    activeDuration: int.tryParse(json['active_duration'].toString()) ?? 1,
    unActiveDuration: int.tryParse(json['unActive_duration'].toString()) ?? 5,
    maxOpasity: double.tryParse(json['max_opasity'].toString()) ?? 1,
    minOpasity: double.tryParse(json['min_opasity'].toString()) ?? 0.1,
    pauseWhenRecording: json['pause_when_recording'] == 1,
  );

  ScreenSetOptions copyWith({
    List<Alignment>? positions,
    int? unActiveDuration,
    int? activeDuration,
    double? maxOpasity,
    double? minOpasity,
    bool? isScreenSecure,
    bool? pauseWhenRecording,
    String? screenRecordedText,
    Widget? logo,
  }) => ScreenSetOptions(
    positions: positions ?? this.positions,
    activeDuration: activeDuration ?? this.activeDuration,
    unActiveDuration: unActiveDuration ?? this.unActiveDuration,
    maxOpasity: maxOpasity ?? this.maxOpasity,
    minOpasity: minOpasity ?? this.minOpasity,
    isScreenSecure: isScreenSecure ?? this.isScreenSecure,
    pauseWhenRecording: pauseWhenRecording ?? this.pauseWhenRecording,
    screenRecordedText: screenRecordedText ?? this.screenRecordedText,
    logo: logo ?? this.logo,
  );
}