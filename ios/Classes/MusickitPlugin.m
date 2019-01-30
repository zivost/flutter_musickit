#import "MusickitPlugin.h"
#import <musickit/musickit-Swift.h>

@implementation MusickitPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftMusickitPlugin registerWithRegistrar:registrar];
}
@end
