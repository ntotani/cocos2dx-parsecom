#import "UserParse.h"
#import "UserWrapper.h"

#define OUTPUT_LOG(...)     if (self.debug) NSLog(__VA_ARGS__);

@implementation UserParse

@synthesize debug = __debug;

- (void) configDeveloperInfo : (NSMutableDictionary*) cpInfo
{
}

- (void) login
{
    OUTPUT_LOG(@"parse login");
}

- (void) logout
{
}

- (BOOL) isLogined
{
}

- (NSString*) getSessionID
{
}

- (void) setDebugMode: (NSNumber*) debug
{
    self.debug = [debug boolValue];
}

- (NSString*) getSDKVersion
{
}

- (NSString*) getPluginVersion
{
}

@end
