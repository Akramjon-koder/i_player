//
//  Generated file. Do not edit.
//

// clang-format off

#import "GeneratedPluginRegistrant.h"

#if __has_include(<i_player/IPlayerPlugin.h>)
#import <i_player/IPlayerPlugin.h>
#else
@import i_player;
#endif

#if __has_include(<integration_test/IntegrationTestPlugin.h>)
#import <integration_test/IntegrationTestPlugin.h>
#else
@import integration_test;
#endif

#if __has_include(<screen_brightness_ios/ScreenBrightnessIosPlugin.h>)
#import <screen_brightness_ios/ScreenBrightnessIosPlugin.h>
#else
@import screen_brightness_ios;
#endif

#if __has_include(<screen_protector/ScreenProtectorPlugin.h>)
#import <screen_protector/ScreenProtectorPlugin.h>
#else
@import screen_protector;
#endif

#if __has_include(<video_player_avfoundation/FVPVideoPlayerPlugin.h>)
#import <video_player_avfoundation/FVPVideoPlayerPlugin.h>
#else
@import video_player_avfoundation;
#endif

#if __has_include(<wakelock/WakelockPlugin.h>)
#import <wakelock/WakelockPlugin.h>
#else
@import wakelock;
#endif

@implementation GeneratedPluginRegistrant

+ (void)registerWithRegistry:(NSObject<FlutterPluginRegistry>*)registry {
  [IPlayerPlugin registerWithRegistrar:[registry registrarForPlugin:@"IPlayerPlugin"]];
  [IntegrationTestPlugin registerWithRegistrar:[registry registrarForPlugin:@"IntegrationTestPlugin"]];
  [ScreenBrightnessIosPlugin registerWithRegistrar:[registry registrarForPlugin:@"ScreenBrightnessIosPlugin"]];
  [ScreenProtectorPlugin registerWithRegistrar:[registry registrarForPlugin:@"ScreenProtectorPlugin"]];
  [FVPVideoPlayerPlugin registerWithRegistrar:[registry registrarForPlugin:@"FVPVideoPlayerPlugin"]];
  [WakelockPlugin registerWithRegistrar:[registry registrarForPlugin:@"WakelockPlugin"]];
}

@end
