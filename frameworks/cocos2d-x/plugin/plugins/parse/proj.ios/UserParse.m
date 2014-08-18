#import "UserParse.h"
#import "UserWrapper.h"
#import "AdsWrapper.h"

#define OUTPUT_LOG(...)     if (self.debug) NSLog(__VA_ARGS__);

@implementation UserParse

@synthesize debug = __debug;

- (void) configDeveloperInfo : (NSMutableDictionary*) cpInfo
{
    [Parse setApplicationId:[cpInfo objectForKey:@"ApplicationID"]
                  clientKey:[cpInfo objectForKey:@"ClientKey"]];
    [PFTwitterUtils initializeWithConsumerKey:[cpInfo objectForKey:@"TwitterConsumerKey"] consumerSecret:[cpInfo objectForKey:@"TwitterConsumerSecret"]];
}

- (void) login
{
    PFLogInViewController* vc = [[PFLogInViewController alloc] init];
    vc.fields = PFLogInFieldsDefault | PFLogInFieldsTwitter;
    vc.delegate = self;
    [[AdsWrapper getCurrentRootViewController] presentViewController:vc animated:YES completion:nil];
}

- (void) logout
{
}

- (BOOL) isLogined
{
    return [PFUser currentUser] != nil;
}

- (NSString*) getSessionID
{
    if ([PFUser currentUser]) {
        return [PFUser currentUser].username;
    }
    return nil;
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

- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user
{
    [UserWrapper onActionResult:self withRet:kLoginSucceed withMsg:user.username];
}

- (void)logInViewController:(PFLogInViewController *)logInController didFailToLogInWithError:(NSError *)error
{
    [UserWrapper onActionResult:self withRet:kLoginFailed withMsg:[error localizedDescription]];
}

- (void)logInViewControllerDidCancelLogIn:(PFLogInViewController *)logInController
{
    [UserWrapper onActionResult:self withRet:kLoginFailed withMsg:@"cancel"];
}

- (void)saveChara:(NSMutableDictionary *)data
{
    PFObject* chara = [PFObject objectWithClassName:@"Chara"];
    chara[@"type"] = data[@"type"];
    chara[@"level"] = data[@"level"];
    chara.ACL = [PFACL ACLWithUser:[PFUser currentUser]];
    [chara saveInBackground];
}

- (void)loadChara
{
    PFQuery* q = [PFQuery queryWithClassName:@"Chara"];
    [q findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        PFObject* chara = objects.firstObject;
        NSString* format = @"{\"type\":\"%@\",\"level\":\"%@\"}";
        NSString* json = [NSString stringWithFormat:format, chara[@"type"], chara[@"level"]];
        [UserWrapper onActionResult:self withRet:kLogoutSucceed withMsg:json];
    }];
}

@end
