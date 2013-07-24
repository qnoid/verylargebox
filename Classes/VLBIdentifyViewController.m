//
//  VLBIdentifyViewController.m
//  verylargebox
//
//  Created by Markos Charatzas on 21/07/2013.
//  Copyright (c) 2013 verylargebox.com. All rights reserved.
//

#import "VLBIdentifyViewController.h"
#import "VLBButtons.h"
#import "VLBButton.h"
#import "VLBMacros.h"
#import "MBProgressHUD.h"
#import "VLBHuds.h"
#import "VLBSecureHashA1.h"
#import "VLBForewordViewController.h"
#import "VLBViewControllers.h"
#import "VLBTheBox.h"
#import "VLBErrorBlocks.h"
#import "VLBTableViewCells.h"
#import "VLBQueries.h"
#import "VLBViewControllers.h"

@interface VLBIdentifyViewController ()
@property(nonatomic, weak) VLBTheBox *thebox;
@property(nonatomic, assign) BOOL didEnterEmail;
@end

@implementation VLBIdentifyViewController

+(VLBIdentifyViewController*)newIdentifyViewController:(VLBTheBox*)thebox
{
    VLBIdentifyViewController *identifyViewController = [[VLBIdentifyViewController alloc] initWithBundle:[NSBundle mainBundle] thebox:(VLBTheBox*)thebox];
    
    identifyViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Sign in" image:[UIImage imageNamed:@"idcard-grey.png"] tag:0];

    UIButton* titleButton = [[VLBViewControllers new] titleButton:@"Picture a Box"
                                                           target:identifyViewController
                                                           action:@selector(didTouchUpInsideForeword:)];
    
    identifyViewController.navigationItem.titleView = titleButton;

return identifyViewController;
}

-(id)initWithBundle:(NSBundle *)nibBundleOrNil thebox:(VLBTheBox*)thebox
{
    self = [super initWithNibName:NSStringFromClass([VLBIdentifyViewController class]) bundle:nibBundleOrNil];
    
    VLB_IF_NOT_SELF_RETURN_NIL();
    
    self.thebox = thebox;
    
return self;
}

-(void)didTouchUpInsideForeword:(id)sender
{
    VLBForewordViewController *forewordViewController = [VLBForewordViewController newForewordViewController];
    
    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:forewordViewController] animated:YES completion:nil];
}

-(void)hideHUDForView
{
    [MBProgressHUD hideAllHUDsForView:self.noticeView animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"hexabump.png"]];    
    self.emailTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, 0)];
    self.emailTextField.leftViewMode = UITextFieldViewModeAlways;
    VLBTitleLabelPrimaryBlue(self.emailButton.titleLabel);

    

    __weak VLBIdentifyViewController *wself = self;

    [self.signUpButton onTouchUp:^(UIButton *button)
    {
        [wself.view sendSubviewToBack:button];

        NSString *email = wself.emailTextField.text;
        NSString* residence = [[VLBSecureHashA1 new] newKey];
        
        [self didEnterEmail:email forResidence:residence];
        
        [TestFlight passCheckpoint:[NSString stringWithFormat:@"%@", @"didTouchUpInsideIdentifyButton"]];
        
        AFHTTPRequestOperation *newRegistrationOperation =
        [VLBQueries newCreateUserQuery:wself email:email residence:residence];
        
        [newRegistrationOperation start];
    }];
    
    
    [self.emailButton onTouchUp:^(UIButton *button) {
        [wself.view sendSubviewToBack:wself.emailButton];
        [wself.view sendSubviewToBack:wself.signInButton];
    }];
    
    [self.signInButton onTouchUp:^(UIButton *button)
    {
        NSString *email = [wself.thebox email];
        NSString *residence = [wself.thebox residenceForEmail:email];

        [wself hideHUDForView];
        MBProgressHUD *hud = [VLBHuds newOnDidSignIn:wself.view email:[wself.thebox email]];
        [hud show:YES];
        
        AFHTTPRequestOperation *verifyUser = [VLBQueries newVerifyUserQuery:wself email:email residence:residence];
        [verifyUser start];
    }];
}

-(void)viewDidAppear:(BOOL)animated
{
    if([self.thebox hasUserAccount] || self.didEnterEmail){
        return;
    }
    
	MBProgressHUD *hud = [VLBHuds newViewWithIdCard:self.noticeView];
	[hud show:YES];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.signUpButton sendActionsForControlEvents:UIControlEventTouchUpInside];
    self.signUpButton.enabled = NO;

    [self.emailButton setTitle:textField.text forState:UIControlStateNormal];
    [self.view sendSubviewToBack:textField];
    
return YES;
}

-(void)textField:(UITextField *)textField email:(NSString *)email isValidEmail:(BOOL)isValidEmail
{
    self.signUpButton.enabled = isValidEmail;
}

-(void)didEnterEmail:(NSString *)email forResidence:(NSString *)residence
{
    self.didEnterEmail = YES;
    [self hideHUDForView];
    MBProgressHUD *hud = [VLBHuds newOnDidEnterEmail:self.noticeView email:email];
    [hud show:YES];
}

#pragma mark VLBCreateUserOperationDelegate
-(void)didSucceedWithRegistrationForEmail:(NSString*)email residence:(NSString*)residence
{
    [self hideHUDForView];

    DDLogVerbose(@"%s", __PRETTY_FUNCTION__);
    self.signInButton.enabled = YES;
    [self.thebox didSucceedWithRegistrationForEmail:email residence:residence];
    
    MBProgressHUD* hud = [VLBHuds newOnDidSucceedWithRegistration:self.noticeView email:email residence:residence];
    
    [hud show:YES];
}

-(void)didFailOnRegistrationWithError:(NSError*)error
{
    [self hideHUDForView];

    [VLBErrorBlocks localizedDescriptionOfErrorBlock:self.view](error);
}

-(void)didSucceedWithVerificationForEmail:(NSString *)email residence:(NSDictionary *)residence
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];

    [self.thebox didSucceedWithVerificationForEmail:email residence:residence];
    
    UINavigationController *profileViewController =
    [[UINavigationController alloc] initWithRootViewController:[self.thebox decideOnProfileViewController]];
    
    NSMutableArray* viewControllers = [NSMutableArray arrayWithArray:self.tabBarController.viewControllers];
    [viewControllers replaceObjectAtIndex:0 withObject:profileViewController];
    
    self.tabBarController.viewControllers = viewControllers;
}

-(void)didFailOnVerifyWithError:(NSError *)error
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];

    MBProgressHUD* hud = [VLBHuds newOnDidFailOnVerifyWithError:self.view];
    [hud show:YES];
    [hud hide:YES afterDelay:5.0];    
}


#pragma mark TBNSErrorDelegate
-(void)didFailWithCannonConnectToHost:(NSError *)error
{
    [self hideHUDForView];

    [VLBErrorBlocks localizedDescriptionOfErrorBlock:self.view](error);
}

-(void)didFailWithNotConnectToInternet:(NSError *)error
{
    [self hideHUDForView];

    [VLBErrorBlocks localizedDescriptionOfErrorBlock:self.view](error);
}

-(void)didFailWithTimeout:(NSError *)error
{
    [self hideHUDForView];

    [VLBErrorBlocks localizedDescriptionOfErrorBlock:self.view](error);
}

@end
