//
//  Copyright 2010 The Box
//  All rights reserved.
//
//  This file is part of TheBox
//
//  Created by Markos Charatzas on 5/11/10.
//
//

#import "VLBAppDelegate.h"
#import <XRay/XRay.h>
#import <Crashlytics/Crashlytics.h>
#import "VLBIdentifyViewController.h"
#import "VLBLocationService.h"
#import "VLBNotifications.h"
#import "VLBSecureHashA1.h"
#import "DDTTYLogger.h"
#import "VLBTypography.h"

static NSString * const TESTFLIGHT_TEAM_TOKEN = @"fc2b4104428a1fca89ef4bac9ae1e820_ODU1NzMyMDEyLTA0LTI5IDEyOjE3OjI4LjMwMjc3NQ";
static NSString * const TESTFLIGHT_APP_TOKEN = @"d9ff72b2-9a0a-4b4a-ab73-a03314809698";

@interface VLBAppDelegate ()
@property(nonatomic, strong) VLBLocationService *theBoxLocationService;
@end

@implementation VLBAppDelegate

@synthesize window;

#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions 
{    
		DDLogInfo(@"%s", __PRETTY_FUNCTION__);
    [DDLog addLogger:[DDTTYLogger sharedInstance]];

    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    NSString* userSession = [standardUserDefaults objectForKey:[[NSBundle mainBundle] bundleIdentifier]];
    
    if(!userSession){
        userSession = [[VLBSecureHashA1 new] uuid];
        
        [standardUserDefaults setObject:userSession
                                 forKey:[[NSBundle mainBundle] bundleIdentifier]];
        [standardUserDefaults synchronize];
    }

    [Crashlytics startWithAPIKey:@"81f3a35c563de29aa0f370c973501175ae86d19c"];
    [TestFlight setDeviceIdentifier:userSession];
    [TestFlight takeOff:TESTFLIGHT_APP_TOKEN];

    [[UINavigationBar appearance] setTintColor:[VLBColors colorPearlWhite]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{UITextAttributeTextColor:[UIColor blackColor],UITextAttributeFont: [VLBTypography fontAvenirNextDemiBoldSixteen]}];

    [[UITabBar appearance] setTintColor:[VLBColors color333333]];
    [[UITabBar appearance] setSelectedImageTintColor:[VLBColors color0102161]];
    [[UITabBarItem appearance] setTitleTextAttributes:@{UITextAttributeTextColor:[UIColor whiteColor],UITextAttributeFont: [VLBTypography fontAvenirNextDemiBoldTwelve]} forState:UIControlStateNormal];
    [[UITabBar appearance] setSelectionIndicatorImage:[[UIImage alloc] init]];

    [[UISearchBar appearance] setTintColor:[VLBColors colorPearlWhite]];

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    UINavigationController* navigationController = [[UINavigationController alloc] initWithRootViewController:[VLBIdentifyViewController newIdentifyViewController]];
    
    self.window.rootViewController = navigationController;
    
    [TestFlight passCheckpoint:[NSString stringWithFormat:@"%s", __PRETTY_FUNCTION__]];
    
    [self.window makeKeyAndVisible];
return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}

@end
