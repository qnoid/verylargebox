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

@interface VLBProfileEmptyViewController ()
@property(nonatomic, weak) VLBTheBox *thebox;

@property(nonatomic, strong) NSDictionary* residence;
@end

@implementation VLBProfileEmptyViewController

+(VLBProfileEmptyViewController *)newProfileViewController:(VLBTheBox*)thebox residence:(NSDictionary*)residence email:(NSString*)email
{
    VLBProfileEmptyViewController *profileViewController =
        [[VLBProfileEmptyViewController alloc] initWithBundle:[NSBundle mainBundle]
                                                       thebox:thebox
                                                    residence:residence];

    UILabel* titleLabel = [[VLBViewControllers new] titleView:email];
    profileViewController.navigationItem.titleView = titleLabel;
    [titleLabel sizeToFit];

    profileViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"You" image:[UIImage imageNamed:@"user.png"] tag:0];
    profileViewController.navigationItem.leftBarButtonItem = [[VLBViewControllers new] closeButton:profileViewController action:@selector(close)];

return profileViewController;
}

-(id)initWithBundle:(NSBundle *)nibBundleOrNil thebox:(VLBTheBox*)thebox residence:(NSDictionary*)residence
{
    self = [super initWithNibName:NSStringFromClass([VLBProfileEmptyViewController class]) bundle:nibBundleOrNil];
    
    VLB_IF_NOT_SELF_RETURN_NIL();
    
	self.thebox = thebox;
    self.residence = residence;

return self;
}

-(void)close
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)drawRect:(CGRect)rect inView:(UIView*)view
{
    [[VLBDrawRects new] drawContextOfHexagonInRect:rect];
}

-(IBAction)didTouchUpInsideTakePhoto
{
    VLBTakePhotoViewController *takePhotoViewController = [self.thebox newUploadUIViewController];
    
    takePhotoViewController.createItemDelegate = self;
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:takePhotoViewController];
    [self presentViewController:navigationController animated:YES completion:nil];
}


@end
