#ifndef FLUTTER_PLUGIN_I_PLAYER_PLUGIN_H_
#define FLUTTER_PLUGIN_I_PLAYER_PLUGIN_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>

#include <memory>

namespace i_player {

class IPlayerPlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  IPlayerPlugin();

  virtual ~IPlayerPlugin();

  // Disallow copy and assign.
  IPlayerPlugin(const IPlayerPlugin&) = delete;
  IPlayerPlugin& operator=(const IPlayerPlugin&) = delete;

  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

}  // namespace i_player

#endif  // FLUTTER_PLUGIN_I_PLAYER_PLUGIN_H_
