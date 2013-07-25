//
//  VLBProfileEmptyView.m
//  verylargebox
//
//  Created by Markos Charatzas on 05/07/2013.
//  Copyright (c) 2013 verylargebox.com. All rights reserved.
//

#import "VLBProfileEmptyViewController.h"
#import "VLBMacros.h"
#import "VLBView.h"
#import "VLBDrawRects.h"
#import "VLBTakePhotoViewController.h"
#import "VLBTheBox.h"
#import "VLBViewControllers.h"
#import "AFHTTPRequestOperation.h"
#import "VLBErrorBlocks.h"
#import "VLBQueries.h"
#import "NSDictionary+VLBResidence.h"
#import "VLBProfileViewController.h"
#import "VLBUserProfileViewController.h"
#import "VLBColors.h"

@interface VLBProfileEmptyViewController ()
@property(nonatomic, weak) VLBTheBox *thebox;

@property(nonatomic, strong) NSString* locality;
@property(nonatomic, strong) NSDictionary* location;
@end

@implementation VLBProfileEmptyViewController

+(VLBProfileEmptyViewController *)newProfileViewController:(VLBTheBox*)thebox email:(NSString*)email
{
    VLBProfileEmptyViewController *profileViewController =
        [[VLBProfileEmptyViewController alloc] initWithBundle:[NSBundle mainBundle]
                                                       thebox:thebox];

    UIButton* titleButton = [[VLBViewControllers new] attributedTitleButton:email
                                                           target:profileViewController
                                                           action:@selector(presentUserSettingsViewController)];
    
    profileViewController.navigationItem.titleView = titleButton;

    profileViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"You" image:[UIImage imageNamed:@"user.png"] tag:0];

return profileViewController;
}

-(id)initWithBundle:(NSBundle *)nibBundleOrNil thebox:(VLBTheBox*)thebox
{
    self = [super initWithNibName:NSStringFromClass([VLBProfileEmptyViewController class]) bundle:nibBundleOrNil];
    
    VLB_IF_NOT_SELF_RETURN_NIL();
    
	self.thebox = thebox;

return self;
}

-(void)presentUserSettingsViewController
{
    UINavigationController *newUserSettingsViewController = [[UINavigationController alloc] initWithRootViewController:[self.thebox newUserProfileViewController]];
    [self.navigationController presentViewController:newUserSettingsViewController animated:YES completion:nil];
}

-(void)viewDidLoad
{
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"hexabump.png"]];
}

-(IBAction)didTouchUpInsideTakePhoto
{
    VLBTakePhotoViewController *takePhotoViewController = [self.thebox newUploadUIViewController];
    
    VLBNotificationView *notificationView = [VLBNotificationView newView];
    takePhotoViewController.createItemDelegate = notificationView;
    notificationView.delegate = self;
    [self.view addSubview:notificationView];

    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:takePhotoViewController];
    [self presentViewController:navigationController animated:YES completion:nil];
}

-(void)didCompleteUploading:(VLBNotificationView *)notificationView at:(NSString *)itemURL
{
	AFHTTPRequestOperation *itemQuery = [VLBQueries newPostItemQuery:itemURL
                                                            location:self.location
                                                            locality:self.locality
                                                                user:[self.thebox userId]
                                                            delegate:notificationView];
    
	[itemQuery start];
}

-(void)didStartUploadingItem:(UIImage*)itemImage key:(NSString*)key location:(NSDictionary*) location locality:(NSString*) locality
{
	self.location = location;
	self.locality = locality;
}

-(void)didSucceedWithItem:(NSDictionary*)item
{
    UINavigationController* profileViewController = [[UINavigationController alloc] initWithRootViewController:[self.thebox newProfileViewController]];
    
    NSMutableArray* viewControllers = [NSMutableArray arrayWithArray:self.tabBarController.viewControllers];
    [viewControllers replaceObjectAtIndex:0 withObject:profileViewController];
    
    self.tabBarController.viewControllers = viewControllers;
}

-(void)didFailOnItemWithError:(NSError*)error
{
    DDLogError(@"%s, %@", __PRETTY_FUNCTION__, error);
    [VLBErrorBlocks localizedDescriptionOfErrorBlock:self.view](error);
}

#pragma mark TBNSErrorDelegate
-(void)didFailWithCannonConnectToHost:(NSError *)error
{
    [VLBErrorBlocks localizedDescriptionOfErrorBlock:self.view](error);
}

-(void)didFailWithNotConnectToInternet:(NSError *)error
{
    [VLBErrorBlocks localizedDescriptionOfErrorBlock:self.view](error);
}

-(void)didFailWithTimeout:(NSError *)error
{
    [VLBErrorBlocks localizedDescriptionOfErrorBlock:self.view](error);
}


@end
