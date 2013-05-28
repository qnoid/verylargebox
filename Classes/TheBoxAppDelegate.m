/*
 *  Copyright 2010 The Box
 *  All rights reserved.
 *
 *  This file is part of TheBox
 *
 *  Created by Markos Charatzas (@qnoid) on 5/11/10.
 *  Contributor(s): .-
 */
#import "TheBoxAppDelegate.h"
#import "TBIdentifyViewController.h"
#import <XRay/XRay.h>
#import "TheBoxLocationService.h"
#import "TheBoxNotifications.h"
#import "TBSecureHashA1.h"
#import "DDTTYLogger.h"

static NSString * const TESTFLIGHT_TEAM_TOKEN = @"fc2b4104428a1fca89ef4bac9ae1e820_ODU1NzMyMDEyLTA0LTI5IDEyOjE3OjI4LjMwMjc3NQ";

static NSString * const TESTFLIGHT_APP_TOKEN = @"d9ff72b2-9a0a-4b4a-ab73-a03314809698";

@interface TheBoxAppDelegate()
@property(nonatomic, strong) TheBoxLocationService *theBoxLocationService;
@end

@implementation TheBoxAppDelegate

@synthesize window;

#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions 
{    
	NSLog(@"Hello The Box");
    [XRay startUp];
    [DDLog addLogger:[DDTTYLogger sharedInstance]];

    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    NSString* userSession = [standardUserDefaults objectForKey:[[NSBundle mainBundle] bundleIdentifier]];
    
    if(!userSession){
        userSession = [[TBSecureHashA1 new] uuid];
        
        [standardUserDefaults setObject:userSession
                                 forKey:[[NSBundle mainBundle] bundleIdentifier]];
        [standardUserDefaults synchronize];
    }
    
    [TestFlight setDeviceIdentifier:userSession];
    [TestFlight takeOff:TESTFLIGHT_APP_TOKEN];

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.rootViewController =
        [[UINavigationController alloc] initWithRootViewController:[TBIdentifyViewController newIdentifyViewController]];
    
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
