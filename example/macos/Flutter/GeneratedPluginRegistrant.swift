//
//  Generated file. Do not edit.
//

import FlutterMacOS
import Foundation

import i_player
import screen_brightness_macos
import video_player_avfoundation
import wakelock_macos

func RegisterGeneratedPlugins(registry: FlutterPluginRegistry) {
  IPlayerPlugin.register(with: registry.registrar(forPlugin: "IPlayerPlugin"))
  ScreenBrightnessMacosPlugin.register(with: registry.registrar(forPlugin: "ScreenBrightnessMacosPlugin"))
  FVPVideoPlayerPlugin.register(with: registry.registrar(forPlugin: "FVPVideoPlayerPlugin"))
  WakelockMacosPlugin.register(with: registry.registrar(forPlugin: "WakelockMacosPlugin"))
}
