//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <i_player/i_player_plugin_c_api.h>
#include <screen_brightness_windows/screen_brightness_windows_plugin.h>

void RegisterPlugins(flutter::PluginRegistry* registry) {
  IPlayerPluginCApiRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("IPlayerPluginCApi"));
  ScreenBrightnessWindowsPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("ScreenBrightnessWindowsPlugin"));
}
