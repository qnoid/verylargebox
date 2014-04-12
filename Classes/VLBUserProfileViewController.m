//
//  VLBSignOutViewController.m
//  verylargebox
//
//  Created by Markos Charatzas on 24/07/2013.
//  Copyright (c) 2013 verylargebox.com. All rights reserved.
//

#import "VLBUserProfileViewController.h"
#import "VLBMacros.h"
#import "VLBViewControllers.h"
#import "VLBButton.h"
#import "VLBTheBox.h"
#import "VLBHuds.h"
#import "MBProgressHUD.h"
#import "VLBIdentifyViewController.h"
#import "VLBErrorBlocks.h"

@interface VLBUserProfileViewController ()
@property(nonatomic, weak) VLBTheBox *thebox;
@end

@implementation VLBUserProfileViewController

+(VLBUserProfileViewController*)newUserSettingsViewController:(VLBTheBox*)thebox
{
    VLBUserProfileViewController *signOutViewController = [[VLBUserProfileViewController alloc] initWithBundle:[NSBundle mainBundle] thebox:thebox];

    UILabel* titleLabel = [[VLBViewControllers new] titleView:NSLocalizedString(@"viewcontrollers.userProfile.navigationBar.title", @"User Profile")];
    signOutViewController.navigationItem.titleView = titleLabel;
    [titleLabel sizeToFit];

    signOutViewController.navigationItem.leftBarButtonItem =
    [[VLBViewControllers new] closeButton:signOutViewController
                                   action:@selector(dismissViewControllerAnimated:)];
   
return signOutViewController;
}

-(id)initWithBundle:(NSBundle *)nibBundleOrNil thebox:(VLBTheBox*)thebox
{
    self = [super initWithNibName:NSStringFromClass([VLBUserProfileViewController class]) bundle:nibBundleOrNil];
    
    VLB_IF_NOT_SELF_RETURN_NIL();
    
    self.thebox = thebox;

    return self;
}

- (void)dismissViewControllerAnimated:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    VLBTitleLabelPrimaryBlue(self.emailButton.titleLabel);
    [self.emailButton setTitle:[self.thebox email] forState:UIControlStateNormal];
    
    __weak VLBUserProfileViewController *wself = self;
    
    [self.signOutButton setTitle:NSLocalizedString(@"huds.signout.header", @"Sign out") forState:UIControlStateNormal];
    [self.signOutButton vlb_cornerRadius:2.0];
    [self.signOutButton onTouchUp:^(UIButton *button) {
        [wself.thebox noUserAccount];
        
        UITabBarController *tabBarController = (UITabBarController*)wself.presentingViewController;
        
        NSMutableArray* viewControllers = [NSMutableArray arrayWithArray:tabBarController.viewControllers];
        [viewControllers replaceObjectAtIndex:0 withObject:[wself.thebox newNavigationController:[wself.thebox newIdentifyViewController]]];
        
        tabBarController.viewControllers = viewControllers;
        
        [wself dismissViewControllerAnimated:YES completion:nil];
    }];

    [self.termsOfServiceButton setTitle:NSLocalizedString(@"huds.termsoofservice.header", @"Terms of Service") forState:UIControlStateNormal];
    [self.termsOfServiceButton vlb_cornerRadius:2.0];
    [self.termsOfServiceButton onTouchUp:^(UIButton *button) {
        VLBMarkdownSucessBlock markdownSuccessBlock = [[VLBViewControllers new] presentTextViewController:self title:NSLocalizedString(@"huds.termsoofservice.header", @"Terms of Service")];
        
        [VLBQueries queryTermsOfService:markdownSuccessBlock
                                failure:^(AFHTTPRequestOperation *operation, NSError *error)
         {
             [MBProgressHUD hideHUDForView:self.noticeView animated:YES];
             [VLBErrorBlocks localizedDescriptionOfErrorBlock:self.view](error);
             
             dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                 [self showSignOutViewWithIdCard];
             });
         }];
    }];

    [self.privacyPolicyButton setTitle:NSLocalizedString(@"huds.privacypolicy.header", @"Privacy Policy") forState:UIControlStateNormal];
    [self.privacyPolicyButton vlb_cornerRadius:2.0];
    [self.privacyPolicyButton onTouchUp:^(UIButton *button) {
        VLBMarkdownSucessBlock markdownSuccessBlock = [[VLBViewControllers new] presentTextViewController:self title:NSLocalizedString(@"huds.privacypolicy.header", @"Privacy Policy")];
        
        [VLBQueries queryPrivacyPolicy:markdownSuccessBlock
                                failure:^(AFHTTPRequestOperation *operation, NSError *error)
         {
             [MBProgressHUD hideHUDForView:self.noticeView animated:YES];
             [VLBErrorBlocks localizedDescriptionOfErrorBlock:self.view](error);
             dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                 [self showSignOutViewWithIdCard];
             });
         }];
    }];

}

-(void)viewDidAppear:(BOOL)animated
{
    [self showSignOutViewWithIdCard];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)showSignOutViewWithIdCard
{
    MBProgressHUD *hud = [VLBHuds newSignOutViewWithIdCard:self.noticeView];
	[hud show:YES];
}

@end
