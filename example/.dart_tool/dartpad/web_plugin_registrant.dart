// Flutter web plugin registrant file.
//
// Generated file. Do not edit.
//

// @dart = 2.13
// ignore_for_file: type=lint

import 'package:i_player/i_player_web.dart';
import 'package:video_player_web/video_player_web.dart';
import 'package:wakelock_web/wakelock_web.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

void registerPlugins([final Registrar? pluginRegistrar]) {
  final Registrar registrar = pluginRegistrar ?? webPluginRegistrar;
  IPlayerWeb.registerWith(registrar);
  VideoPlayerPlugin.registerWith(registrar);
  WakelockWeb.registerWith(registrar);
  registrar.registerMessageHandler();
}
