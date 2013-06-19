//
//  VLBIdentifyViewController.m
//  thebox
//
//  Created by Markos Charatzas on 18/11/2012.
//  Copyright (c) 2012 (verylargebox.com). All rights reserved.
//

#import "VLBIdentifyViewController.h"
#import "VLBButton.h"
#import "VLBColors.h"
#import "VLBCityViewController.h"
#import "SSKeychain.h"
#import "VLBQueries.h"
#import "VLBProfileViewController.h"
#import "AFHTTPRequestOperation.h"
#import "VLBTableViewDataSourceBuilder.h"
#import "VLBView.h"
#import "VLBVerifyOperationBlock.h"
#import "VLBFeedViewController.h"
#import "VLBAlertViews.h"
#import "VLBViews.h"
#import "VLBHuds.h"
#import "MBProgressHUD.h"
#import "VLBPolygon.h"
#import "VLBErrorBlocks.h"
#import "VLBDrawRects.h"
#import "QNDAnimations.h"
#import "QNDAnimatedView.h"
#import "VLBSecureHashA1.h"

@interface VLBIdentifyViewController ()
@property(nonatomic, strong) NSOperationQueue *operations;
@property(nonatomic, strong) NSMutableArray* accounts;

-(id)initWithBundle:(NSBundle *)nibBundleOrNil accounts:(NSMutableArray*) accounts;
@end

@implementation VLBIdentifyViewController

+(VLBIdentifyViewController *)newIdentifyViewController
{
    NSArray* accounts = [SSKeychain accountsForService:THE_BOX_SERVICE];

    VLBIdentifyViewController * identifyViewController = [[VLBIdentifyViewController alloc] initWithBundle:[NSBundle mainBundle] accounts:[NSMutableArray arrayWithArray:accounts]];
    
    UILabel* titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"thebox";
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.backgroundColor = [UIColor clearColor];
		titleLabel.font = [VLBTypography fontAvenirNextDemiBoldSixteen];
    titleLabel.adjustsFontSizeToFitWidth = YES;    
    identifyViewController.navigationItem.titleView = titleLabel;
    [titleLabel sizeToFit];
    
return identifyViewController;
}

-(id)initWithBundle:(NSBundle *)nibBundleOrNil accounts:(NSMutableArray*) accounts
{
    self = [super initWithNibName:@"VLBIdentifyViewController" bundle:nibBundleOrNil];
    
    if (!self) {
        return nil;
    }
    
    self.operations = [[NSOperationQueue alloc] init];
    self.accounts = accounts;
    
return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    UIView<QNDAnimatedView> *accountsTableView = [[QNDAnimations new] animateView:self.accountsTableView];
    [accountsTableView addViewAnimationBlockWithDuration:0.5 animation:^(UIView *view) {
        view.frame = CGRectMake(0, 124, 320, 94);
    }];
    
    self.accountsTableView.layer.sublayerTransform = CATransform3DMakeTranslation(0, 0, 20);
    self.emailTextField.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0);

    __weak VLBIdentifyViewController *uself = self;
    
    [self.identifyButton onTouchUp:^(UIButton *button) {
        VLBSecureHashA1 *sha1 = [VLBSecureHashA1 new];
        NSString* residence = [sha1 newKey];
        
        [uself didEnterEmail:uself.emailTextField.text forResidence:residence];
        
        //no need to handle viewcontroller unloading
        AFHTTPRequestOperation *newRegistrationOperation =
        [VLBQueries newCreateUserQuery:uself email:uself.emailTextField.text residence:residence];
        
        [self.operations addOperation:newRegistrationOperation];
        
        self.emailTextField.text = @"";
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    [self.identifyButton setImageEdgeInsets:UIEdgeInsetsMake(0, -35, 0, 0)];

    [self.browseButton onTouchUpInside:^(UIButton *button)
    {
        [TestFlight passCheckpoint:[NSString stringWithFormat:@"%@, %@", [uself class], @"didTouchUpInsideBrowseButton"]];

        VLBFeedViewController *feedViewController = [VLBFeedViewController newFeedViewController];

  	  	UIButton* closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
	  	  [closeButton setFrame:CGRectMake(0, 0, 30, 30)];
	  	  [closeButton setImage:[UIImage imageNamed:@"circlex.png"] forState:UIControlStateNormal];
		    [closeButton addTarget:self action:@selector(dismissViewControllerAnimated) forControlEvents:UIControlEventTouchUpInside];

        feedViewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:closeButton];
        
        [uself presentViewController:[[UINavigationController alloc] initWithRootViewController:feedViewController] animated:YES completion:nil];
    }];
}

-(void)viewWillAppear:(BOOL)animated
{
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dismissViewControllerAnimated
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark UITextFieldDelegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    [self.identifyButton sendActionsForControlEvents:UIControlEventTouchUpInside];
return self.identifyButton.enabled;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    self.identifyButton.enabled = textField.text.length - range.length + string.length > 0;
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.identifyButton.enabled = YES;
};


#pragma mark TBVerifyUserOperationDelegate
-(void)didSucceedWithVerificationForEmail:(NSString *)email residence:(NSDictionary *)residence
{
    NSLog(@"%s %@:%@", __PRETTY_FUNCTION__, email, residence);
    
    //thebox should be a property to be shared across every controller
    //the residence should be passed to thebox on a method like didSucceedWithVerificationForEmail:residence
    VLBProfileViewController *profileViewController = [VLBProfileViewController newProfileViewController:residence email:email];
    VLBCityViewController *homeGridViewControler = [VLBCityViewController newHomeGridViewController];
    VLBFeedViewController *feedViewController = [VLBFeedViewController newFeedViewController];

    UITabBarController* tabBarController = [[UITabBarController alloc] init];
    tabBarController.viewControllers = @[[[UINavigationController alloc] initWithRootViewController:profileViewController], [[UINavigationController alloc] initWithRootViewController:homeGridViewControler], 
        [[UINavigationController alloc] initWithRootViewController:feedViewController]];
    
    [self presentViewController:tabBarController animated:YES completion:nil];
}

-(void)didFailOnVerifyWithError:(NSError *)error
{
    UIAlertView* userUnauthorisedAlertView =
        [VLBAlertViews newAlertViewWithOk:@"Unauthorised"
                                  message:@"You are not authorised. Please check your email to verify."];
    
    [userUnauthorisedAlertView show];
}

-(void)didEnterEmail:(NSString *)email forResidence:(NSString *)residence
{
    NSError *error = nil;
    [SSKeychain setPassword:residence forService:THE_BOX_SERVICE account:email error:&error];
    
    if (error) {
        NSLog(@"WARNING: %s %@", __PRETTY_FUNCTION__, error);
    }
    
    self.accounts = [NSMutableArray arrayWithArray:[SSKeychain accountsForService:THE_BOX_SERVICE]];
    [self.accountsTableView reloadData];
    
    UIAlertView* userDidEnterEmailAlertView =
    [VLBAlertViews newAlertViewWithOk:@"Device Registration"
                              message:[NSString stringWithFormat:@"Requested to register %@ with thebox", [[UIDevice currentDevice] name]]];
    
    [userDidEnterEmailAlertView show];
}

#pragma mark TBCreateUserOperationDelegate
-(void)didSucceedWithRegistrationForEmail:(NSString *)email residence:(NSString *)residence
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    UIAlertView* userUnauthorisedAlertView =
        [VLBAlertViews newAlertViewWithOk:@"New Registration"
                                  message:[NSString stringWithFormat:@"Please check your email to verify %@", [[UIDevice currentDevice] name]]];
     
    [userUnauthorisedAlertView show];
}

-(void)didFailOnRegistrationWithError:(NSError*)error
{
    MBProgressHUD *hud = [VLBHuds newWithView:self.view config:VLB_PROGRESS_HUD_CUSTOM_VIEW_CIRCLE_NO];
    hud.detailsLabelText = error.localizedDescription;
    [hud show:YES];
    [hud hide:YES afterDelay:3.0];
    
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

#pragma mark UITableViewDatasource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
return [self.accounts count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *emailCell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    if(!emailCell)
    {
        emailCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        emailCell.textLabel.font = [VLBTypography fontLucidaGrandeTwenty];
        UIView* selectedBackgroundView = [[UIView alloc] init];
        selectedBackgroundView.backgroundColor = [VLBColors colorPrimaryBlue];
        emailCell.selectedBackgroundView = selectedBackgroundView;
        vlbEmailStatus(VLBEmailStatusDefault)(emailCell);
    }
    
    NSString* email = [[self.accounts objectAtIndex:indexPath.row] objectForKey:@"acct"];
    emailCell.textLabel.text = email;
    
return emailCell;
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle != UITableViewCellEditingStyleDelete) {
        return;
    }
    
    if(editingStyle == UITableViewCellSelectionStyleNone){
        return;
    }
    
    NSString* email = [[self.accounts objectAtIndex:indexPath.row] objectForKey:@"acct"];
    [SSKeychain deletePasswordForService:THE_BOX_SERVICE account:email];
    [self.accounts removeObjectAtIndex:indexPath.row];
    
    [self.accountsTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
}


#pragma mark UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* tableViewCell = [tableView cellForRowAtIndexPath:indexPath];
    vlbEmailStatus(VLBEmailStatusUnknown)(tableViewCell);

    __weak NSObject<VLBVerifyUserOperationDelegate> *wself = self;
    
    VLBVerifyOperationBlock *verifyOperationBlock = [VLBVerifyOperationBlock new];
    verifyOperationBlock.didSucceedWithVerificationForEmail = ^(NSString* email, NSDictionary* residence)
    {
        vlbEmailStatus(VLBEmailStatusVerified)(tableViewCell);
        [wself didSucceedWithVerificationForEmail:email residence:residence];
    };
    
    verifyOperationBlock.didFailOnVerifyWithError = ^(NSError* error)
    {
        vlbEmailStatus(VLBEmailStatusUnauthorised)(tableViewCell);
        [wself didFailOnVerifyWithError:error];
    };
    
    verifyOperationBlock.didFailWithNotConnectToInternet = ^(NSError *error)
    {
        vlbEmailStatus(VLBEmailStatusError)(tableViewCell);

        UIAlertView* notConnectedToInternetAlertView =
        [VLBAlertViews newAlertViewWithOk:@"Not Connected to Internet"
                                  message:@"You are not connected to the internet. Check your connection and try again."];
        
        [notConnectedToInternetAlertView show];
    };
    
    NSArray* emails = [SSKeychain accountsForService:THE_BOX_SERVICE];
    NSString* email = [[emails objectAtIndex:indexPath.row] objectForKey:@"acct"];
    
    NSError *error = nil;
    NSString *residence = [SSKeychain passwordForService:THE_BOX_SERVICE account:email error:&error];
    
    AFHTTPRequestOperation *verifyUser = [VLBQueries newVerifyUserQuery:verifyOperationBlock email:email residence:residence];
    
    [self.operations addOperation:verifyUser];
}

-(void)drawRect:(CGRect)rect inView:(UIView *)view
{
    [[VLBDrawRects new] drawContextOfHexagonInRect:rect];
}

@end
