#import <Foundation/Foundation.h>
#import "InterfaceUser.h"

@interface UserParse : NSObject <InterfaceUser>
{
}

@property BOOL debug;

/**
 interfaces from InterfaceUser
 */
- (void) configDeveloperInfo : (NSMutableDictionary*) cpInfo;
- (void) login;
- (void) logout;
- (BOOL) isLogined;
- (NSString*) getSessionID;
- (void) setDebugMode: (NSNumber*) debug;
- (NSString*) getSDKVersion;
- (NSString*) getPluginVersion;

@end
