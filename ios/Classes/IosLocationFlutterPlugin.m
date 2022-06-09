#import "IosLocationFlutterPlugin.h"
#if __has_include(<ios_location_flutter_plugin/ios_location_flutter_plugin-Swift.h>)
#import <ios_location_flutter_plugin/ios_location_flutter_plugin-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "ios_location_flutter_plugin-Swift.h"
#endif

@implementation IosLocationFlutterPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftIosLocationFlutterPlugin registerWithRegistrar:registrar];
}
@end
