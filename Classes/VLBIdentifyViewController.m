//
//  VLBIdentifyViewController.m
//  verylargebox
//
//  Created by Markos Charatzas on 21/07/2013.
//  Copyright (c) 2013 verylargebox.com. All rights reserved.
//

#import "VLBIdentifyViewController.h"
#import "VLBButtons.h"
#import "VLBMacros.h"
#import "VLBHuds.h"
#import "VLBSecureHashA1.h"
#import "VLBForewordViewController.h"
#import "VLBViewControllers.h"
#import "VLBTheBox.h"
#import "VLBErrorBlocks.h"
#import "VLBQueries.h"
#import "VLBTextViewController.h"

@interface VLBIdentifyViewController ()
@property(nonatomic, weak) VLBTheBox *thebox;
@property(nonatomic, assign) BOOL didEnterEmail;
@property(nonatomic, strong) VLBEmailTextFieldDelegate *emailTextFieldDelegate;
@end

@implementation VLBIdentifyViewController

+(VLBIdentifyViewController*)newIdentifyViewController:(VLBTheBox*)thebox
{
    VLBIdentifyViewController *identifyViewController = [[VLBIdentifyViewController alloc] initWithBundle:[NSBundle mainBundle] thebox:(VLBTheBox*)thebox];
    
    identifyViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"tabbar.title.signin", @"Sign in") image:[UIImage imageNamed:@"user.png"] tag:0];

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
    self.emailTextFieldDelegate = [[VLBEmailTextFieldDelegate alloc] init];
    
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
    self.emailTextField.placeholder = NSLocalizedString(@"viewcontrollers.identify.emailTextField.placeholder", @"Enter your email");
    self.emailTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, 0)];
    self.emailTextField.leftViewMode = UITextFieldViewModeAlways;
    [self.signUpButton setTitle:NSLocalizedString(@"viewcontrollers.identify.signUpButton.placeholder", @"Sign up") forState:UIControlStateNormal];
    [self.signInButton setTitle:NSLocalizedString(@"viewcontrollers.identify.signInButton.placeholder", @"Sign in") forState:UIControlStateNormal];
    [self.termsOfServiceButton setTitle:NSLocalizedString(@"viewcontrollers.identify.termsOfServiceButton.title", @"By signing up you agree to the terms of service") forState:UIControlStateNormal];
    VLBTitleButtonAttributedWhite(self.termsOfServiceButton, self.termsOfServiceButton.titleLabel.text);
    
    VLBTitleLabelPrimaryBlue(self.emailButton.titleLabel);

    __weak VLBIdentifyViewController *wself = self;

    self.emailTextFieldDelegate.onReturn = ^(UITextField* textField)
    {
        [wself.signUpButton sendActionsForControlEvents:UIControlEventTouchUpInside];
        wself.signUpButton.enabled = NO;
        
        [wself.emailButton setTitle:textField.text forState:UIControlStateNormal];
        [wself.view sendSubviewToBack:textField];
    };
    
    self.emailTextFieldDelegate.didEnterEmail = ^(UITextField *textField, NSString* email, BOOL isValid){
        wself.signUpButton.enabled = isValid;
    };
    
    self.emailTextField.delegate = self.emailTextFieldDelegate;

    [self.signUpButton vlb_cornerRadius:2.0];
    [self.signUpButton onTouchUp:^(UIButton *button)
    {
        [wself.emailTextField resignFirstResponder];
        [wself.view sendSubviewToBack:button];

        NSString *email = [wself.emailTextField.text lowercaseString];
        NSString* residence = [[VLBSecureHashA1 new] newKey];
        
        [self didEnterEmail:email forResidence:residence];
        
        [Flurry logEvent:@"didSignUp"];
        
        [VLBQueries newCreateUserQuery:wself email:email residence:residence];
        
    }];
    
    
    [self.emailButton onTouchUp:^(UIButton *button) {
        [wself.view sendSubviewToBack:wself.emailButton];
        [wself.view sendSubviewToBack:wself.signInButton];
    }];
    
    [self.signInButton vlb_cornerRadius:2.0];
    [self.signInButton onTouchUp:^(UIButton *button)
    {
        NSString *email = [wself.thebox email];
        NSString *residence = [wself.thebox residenceForEmail:email];

        [Flurry logEvent:@"didSignIn"];

        [wself hideHUDForView];
        MBProgressHUD *hud = [VLBHuds newOnDidSignIn:wself.view email:[wself.thebox email]];
        [hud show:YES];
        
        [VLBQueries newVerifyUserQuery:wself email:email residence:residence];
    }];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
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
        [self.thebox newNavigationController:[self.thebox decideOnProfileViewController]];
    
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

-(IBAction)didTouchUpInsideTermsOfServiceButton:(UIButton*)termsOfServiceButton
{
    VLBMarkdownSucessBlock markdownSuccessBlock = [[VLBViewControllers new] presentTextViewController:self title:NSLocalizedString(@"huds.termsoofservice.header", @"Terms of Service")];
    
    [VLBQueries queryTermsOfService:markdownSuccessBlock
    failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
        [self hideHUDForView];
        
        [VLBErrorBlocks localizedDescriptionOfErrorBlock:self.view](error);
    }];
}

@end
