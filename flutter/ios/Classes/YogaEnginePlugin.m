#import "YogaEnginePlugin.h"
#if __has_include(<yoga_engine/yoga_engine-Swift.h>)
#import <yoga_engine/yoga_engine-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "yoga_engine-Swift.h"
#endif

@implementation YogaEnginePlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftYogaEnginePlugin registerWithRegistrar:registrar];
}
@end
