#import "UiKitPlugin.h"
#if __has_include(<ui_kit/ui_kit-Swift.h>)
#import <ui_kit/ui_kit-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "ui_kit-Swift.h"
#endif

@implementation UiKitPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftUiKitPlugin registerWithRegistrar:registrar];
}
@end
