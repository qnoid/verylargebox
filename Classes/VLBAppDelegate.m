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
#import <Crashlytics/Crashlytics.h>
#import "VLBEmailViewController.h"
#import "VLBLocationService.h"
#import "VLBNotifications.h"
#import "VLBSecureHashA1.h"
#import "DDTTYLogger.h"
#import "VLBTypography.h"
#import "VLBTheBox.h"
#import "VLBCityViewController.h"
#import "VLBFeedViewController.h"
#import "VLBProfileViewController.h"
#import "VLBIdentifyViewController.h"
#import "MBProgressHUD.h"
#import "VLBHuds.h"
#import "Flurry.h"

@interface VLBAppDelegate ()
@property(nonatomic, strong) VLBTheBox* thebox;
@property(nonatomic, strong) VLBLocationService *theBoxLocationService;
@end

@implementation VLBAppDelegate

@synthesize window;

#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions 
{    
		DDLogInfo(@"%s", __PRETTY_FUNCTION__);
    [DDLog addLogger:[DDTTYLogger sharedInstance]];

		self.thebox = [VLBTheBox newTheBox];
    [Crashlytics startWithAPIKey:@"81f3a35c563de29aa0f370c973501175ae86d19c"];
		[Flurry startSession:@"WJVNH9SR82PTQRGXM9X5"];

    [[UINavigationBar appearance] setTintColor:[VLBColors colorPearlWhite]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{UITextAttributeTextColor:[UIColor blackColor],UITextAttributeFont: [VLBTypography fontAvenirNextDemiBoldSixteen]}];

    [[UITabBar appearance] setTintColor:[VLBColors color333333]];
    [[UITabBar appearance] setSelectedImageTintColor:[VLBColors color0102161]];
    [[UITabBarItem appearance] setTitleTextAttributes:@{UITextAttributeTextColor:[UIColor whiteColor],UITextAttributeFont: [VLBTypography fontAvenirNextDemiBoldTwelve]} forState:UIControlStateNormal];
    [[UITabBar appearance] setSelectionIndicatorImage:[[UIImage alloc] init]];

    [[UISearchBar appearance] setTintColor:[VLBColors colorPearlWhite]];

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.

    UIViewController *viewController = [self.thebox newIdentifyViewController];
    
    if([self.thebox hasUserAccount]) {
        viewController = [self.thebox decideOnProfileViewController];
    }
    
    UINavigationController *cityViewControler = [[UINavigationController alloc] initWithRootViewController:[self.thebox newCityViewController]];
    UINavigationController *feedViewController = [[UINavigationController alloc] initWithRootViewController:[self.thebox newFeedViewController]];
    
    UITabBarController* tabBarController = [[UITabBarController alloc] init];
    tabBarController.viewControllers = @[[[UINavigationController alloc] initWithRootViewController:viewController], cityViewControler, feedViewController];
    tabBarController.selectedIndex = 2;
    
    self.window.rootViewController = tabBarController;
    
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
