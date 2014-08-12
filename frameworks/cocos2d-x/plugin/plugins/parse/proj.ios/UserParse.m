#import "UserParse.h"
#import "UserWrapper.h"
#import <Parse/Parse.h>

#define OUTPUT_LOG(...)     if (self.debug) NSLog(__VA_ARGS__);

@implementation UserParse

@synthesize debug = __debug;

- (void) configDeveloperInfo : (NSMutableDictionary*) cpInfo
{
    [Parse setApplicationId:[cpInfo objectForKey:@"ApplicationID"]
                  clientKey:[cpInfo objectForKey:@"ClientKey"]];
}

- (void) login
{
}

- (void) logout
{
}

- (BOOL) isLogined
{
    return NO;
}

- (NSString*) getSessionID
{
    return @"";
}

- (void) setDebugMode: (BOOL) isDebugMode
{
    self.debug = isDebugMode;
}

- (NSString*) getSDKVersion
{
    return @"1.2.20";
}

- (NSString*) getPluginVersion
{
    return @"0.0.1";
}

@end
