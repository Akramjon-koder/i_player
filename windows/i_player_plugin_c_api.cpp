#include "include/i_player/i_player_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "i_player_plugin.h"

void IPlayerPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  i_player::IPlayerPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
