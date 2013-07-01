//
//  VLBIdentifyViewController.m
//  verylargebox
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
#import "DDLog.h"
#import "NSArray+VLBDecorator.h"

NSString* const VLB_EMAIL_VALIDATION_REGEX =
@"(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}"
@"~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\"
@"x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-"
@"z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5"
@"]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-"
@"9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21"
@"-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])";

@interface VLBIdentifyViewController ()
@property(nonatomic, strong) NSOperationQueue *operations;
@property(nonatomic, strong) NSMutableArray* accounts;
@property(nonatomic, strong) NSMutableArray* emailStatuses;

-(id)initWithBundle:(NSBundle *)nibBundleOrNil accounts:(NSMutableArray*) accounts;
@end

@implementation VLBIdentifyViewController

+(VLBIdentifyViewController *)newIdentifyViewController
{
    NSArray* accounts = [SSKeychain accountsForService:THE_BOX_SERVICE];

    VLBIdentifyViewController *identifyViewController = [[VLBIdentifyViewController alloc] initWithBundle:[NSBundle mainBundle] accounts:[NSMutableArray arrayWithArray:accounts]];
    
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
    self.emailStatuses = [NSMutableArray arrayWithCapacity:self.accounts.count];
    
    for (id obj in accounts) {
        [self.emailStatuses addObject:@(VLBEmailStatusDefault)];
    }
    
return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"hexabump.png"]];
    
    self.accountsTableView.layer.sublayerTransform = CATransform3DMakeTranslation(0, 0, 20);
    self.emailTextField.layer.sublayerTransform = CATransform3DMakeTranslation(60, 0, 0);

    __weak VLBIdentifyViewController *uself = self;
    
    [self.identifyButton onTouchUp:^(UIButton *button)
    {
        [TestFlight passCheckpoint:[NSString stringWithFormat:@"%@, %@", [uself class], @"didTouchUpInsideIdentifyButton"]];
        
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
    

    [self.browseButton onTouchUpInside:^(UIButton *button)
    {
        [TestFlight passCheckpoint:[NSString stringWithFormat:@"%@, %@", [uself class], @"didTouchUpInsideBrowseButton"]];

        VLBFeedViewController *feedViewController = [VLBFeedViewController newFeedViewController];

  	  	UIButton* closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [closeButton setFrame:CGRectMake(0, 0, 30, 30)];
        [closeButton setImage:[UIImage imageNamed:@"down-arrow.png"] forState:UIControlStateNormal];
        [closeButton addTarget:self action:@selector(dismissViewControllerAnimated) forControlEvents:UIControlEventTouchUpInside];

        feedViewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:closeButton];
        
        [uself presentViewController:[[UINavigationController alloc] initWithRootViewController:feedViewController] animated:YES completion:nil];
    }];
    
    [self.addEmailButton onTouchUpInside:^(UIButton *button) {
        [TestFlight passCheckpoint:[NSString stringWithFormat:@"%@, %@", [uself class], @"didTouchUpInsideAddEmailButton"]];
        
        [self.identifyView animateWithDuration:0.5 animation:^(UIView *view) {
            view.frame = CGRectMake(view.frame.origin.x, CGPointZero.y,
                                    view.frame.size.width, view.frame.size.height);
        }];
        
        [[[QNDAnimations new] animateView:self.accountsTableView] animateWithDuration:0.5 animation:^(UIView *view) {
            view.frame = CGRectMake(view.frame.origin.x,
                                    104,
                                    view.frame.size.width, view.frame.size.height);
        }];
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
    
    NSPredicate *emailValidation = [NSPredicate predicateWithFormat:@"self MATCHES[c] %@", VLB_EMAIL_VALIDATION_REGEX];

    if(![emailValidation evaluateWithObject:textField.text]) {
    return NO;
    }

    textField.textColor = [UIColor lightGrayColor];
    textField.backgroundColor = [UIColor whiteColor];
    [self.identifyButton sendActionsForControlEvents:UIControlEventTouchUpInside];
    self.identifyButton.enabled = NO;

return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSPredicate *emailValidation = [NSPredicate predicateWithFormat:@"self MATCHES[c] %@", VLB_EMAIL_VALIDATION_REGEX];
    
    NSString *resolvedEmail = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    BOOL isValidEmail = [emailValidation evaluateWithObject:resolvedEmail];
    
    self.identifyButton.enabled = isValidEmail;
    
    if(isValidEmail){
        textField.textColor = [UIColor whiteColor];
        textField.backgroundColor = [VLBColors colorPrimaryBlue];
    }
    else {
        textField.textColor = [UIColor lightGrayColor];
        textField.backgroundColor = [UIColor whiteColor];
    }
    
return YES;
}

#pragma mark TBVerifyUserOperationDelegate
-(void)didSucceedWithVerificationForEmail:(NSString *)email residence:(NSDictionary *)residence
{
    DDLogVerbose(@"%s %@:%@", __PRETTY_FUNCTION__, email, residence);
    
    //thebox should be a property to be shared across every controller
    //the residence should be passed to thebox on a method like didSucceedWithVerificationForEmail:residence
    UINavigationController *profileViewController = [[UINavigationController alloc] initWithRootViewController:[VLBProfileViewController newProfileViewController:residence email:email]];
    UINavigationController *homeGridViewControler = [[UINavigationController alloc] initWithRootViewController:[VLBCityViewController newHomeGridViewController]];
    UINavigationController *feedViewController = [[UINavigationController alloc] initWithRootViewController:[VLBFeedViewController newFeedViewController]];

    UITabBarController* tabBarController = [[UITabBarController alloc] init];
    tabBarController.viewControllers = @[profileViewController, homeGridViewControler, feedViewController];
    
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
    [self.identifyView rewind];
    
    [[[QNDAnimations new] animateView:self.accountsTableView] animateWithDuration:0.5 animation:^(UIView *view) {
        view.frame = CGRectMake(view.frame.origin.x,
                                44,
                                view.frame.size.width, view.frame.size.height);
    }];

    NSError *error = nil;
    [SSKeychain setPassword:residence forService:THE_BOX_SERVICE account:email error:&error];
    
    if (error) {
        DDLogWarn(@"WARNING: %s %@", __PRETTY_FUNCTION__, error);
    }
        
    self.accounts = [NSMutableArray arrayWithArray:[SSKeychain accountsForService:THE_BOX_SERVICE]];
    self.emailStatuses = [NSMutableArray arrayWithCapacity:self.accounts.count];
    for (id obj in self.accounts) {
        [self.emailStatuses addObject:@(VLBEmailStatusDefault)];
    }

    [self.accountsTableView reloadData];
    
    UIAlertView* userDidEnterEmailAlertView =
    [VLBAlertViews newAlertViewWithOk:@"Device Registration"
                              message:[NSString stringWithFormat:@"Requested to register %@ with thebox", [[UIDevice currentDevice] name]]];
    
    [userDidEnterEmailAlertView show];
}

#pragma mark TBCreateUserOperationDelegate
-(void)didSucceedWithRegistrationForEmail:(NSString *)email residence:(NSString *)residence
{
    DDLogVerbose(@"%s", __PRETTY_FUNCTION__);
    
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
    VLBEmailStatus emailStatus = [[self.emailStatuses objectAtIndex:indexPath.row] intValue];

    emailCell.textLabel.text = email;
    vlbEmailStatus(emailStatus)(emailCell);

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
		[self.emailStatuses removeObjectAtIndex:indexPath.row];
    
    [self.accountsTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
}

#pragma mark UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* tableViewCell = [tableView cellForRowAtIndexPath:indexPath];
    vlbEmailStatus(VLBEmailStatusUnknown)(tableViewCell);
    [self.emailStatuses setObject:@(VLBEmailStatusUnknown) atIndexedSubscript:indexPath.row];

    __weak VLBIdentifyViewController *wself = self;
    
    VLBVerifyOperationBlock *verifyOperationBlock = [VLBVerifyOperationBlock new];
    verifyOperationBlock.didSucceedWithVerificationForEmail = ^(NSString* email, NSDictionary* residence)
    {
        vlbEmailStatus(VLBEmailStatusVerified)(tableViewCell);
        [wself.emailStatuses setObject:@(VLBEmailStatusVerified) atIndexedSubscript:indexPath.row];
        [wself didSucceedWithVerificationForEmail:email residence:residence];
    };
    
    verifyOperationBlock.didFailOnVerifyWithError = ^(NSError* error)
    {
        vlbEmailStatus(VLBEmailStatusUnauthorised)(tableViewCell);
        [wself.emailStatuses setObject:@(VLBEmailStatusUnauthorised) atIndexedSubscript:indexPath.row];        
        [wself didFailOnVerifyWithError:error];
    };
    
    verifyOperationBlock.didFailWithNotConnectToInternet = ^(NSError *error)
    {
        vlbEmailStatus(VLBEmailStatusError)(tableViewCell);
        [wself.emailStatuses setObject:@(VLBEmailStatusError) atIndexedSubscript:indexPath.row];

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
