//
//  VLBIdentifyViewController.m
//  verylargebox
//
//  Created by Markos Charatzas on 18/11/2012.
//  Copyright (c) 2012 (verylargebox.com). All rights reserved.
//

#import "VLBEmailViewController.h"
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
#import "VLBTheBox.h"
#import "NSDictionary+VLBResidence.h"
#import "VLBProfileEmptyViewController.h"
#import "VLBViewControllers.h"
#import "VLBForewordViewController.h"
#import "VLBMacros.h"
#import "VLBTheBox.h"
#import "VLBButtons.h"
#import "VLBTableViewCells.h"

@interface VLBEmailViewController ()
@property(nonatomic, weak) VLBTheBox *thebox;

@property(nonatomic, strong) NSOperationQueue *operations;
@property(nonatomic, strong) NSMutableArray* accounts;
@property(nonatomic, strong) NSMutableArray* emailStatuses;

-(id)initWithBundle:(NSBundle *)nibBundleOrNil thebox:(VLBTheBox*)thebox accounts:(NSMutableArray*) accounts;
@end

@implementation VLBEmailViewController

+(VLBEmailViewController*)newEmailViewController:(VLBTheBox*)thebox
{
    NSArray* accounts = [SSKeychain accountsForService:THE_BOX_SERVICE];

    VLBEmailViewController *identifyViewController = [[VLBEmailViewController alloc] initWithBundle:[NSBundle mainBundle] thebox:thebox accounts:[NSMutableArray arrayWithArray:accounts]];
    
    identifyViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Identify" image:[UIImage imageNamed:@"idcard.png"] tag:0];
    
    identifyViewController.navigationItem.leftBarButtonItem =
    [[VLBViewControllers new] closeButton:identifyViewController
                                   action:@selector(dismissViewControllerAnimated:)];

return identifyViewController;
}

-(id)initWithBundle:(NSBundle *)nibBundleOrNil thebox:(VLBTheBox*)thebox accounts:(NSMutableArray*) accounts
{
    self = [super initWithNibName:NSStringFromClass([VLBEmailViewController class]) bundle:nibBundleOrNil];
    
    VLB_IF_NOT_SELF_RETURN_NIL();
    
    self.thebox = thebox;

    self.operations = [[NSOperationQueue alloc] init];
    self.accounts = accounts;
    self.emailStatuses = [NSMutableArray arrayWithCapacity:self.accounts.count];
    
    for (id obj in accounts) {
        [self.emailStatuses addObject:@(VLBEmailStatusDefault)];
    }
    
return self;
}

- (void)dismissViewControllerAnimated:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)hideHUDForView
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"hexabump.png"]];
    self.emailTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, 0)];
    self.emailTextField.leftViewMode = UITextFieldViewModeAlways;

    __weak VLBEmailViewController *wself = self;
    
    [self.identifyButton onTouchUp:^(UIButton *button)
     {
         NSString* residence = [[VLBSecureHashA1 new] newKey];
         
         [wself didEnterEmail:wself.emailTextField.text forResidence:residence];

         [Flurry logEvent:[NSString stringWithFormat:@"%@", @"didTouchUpInsideIdentifyButton"]];
         
         AFHTTPRequestOperation *newRegistrationOperation =
         [VLBQueries newCreateUserQuery:self email:wself.emailTextField.text residence:residence];
         
         [newRegistrationOperation start];

         wself.emailTextField.text = @"";
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
    
    [self.identifyButton sendActionsForControlEvents:UIControlEventTouchUpInside];
    self.identifyButton.enabled = NO;

return YES;
}

-(void)textField:(UITextField *)textField email:(NSString *)email isValidEmail:(BOOL)isValidEmail
{
    self.identifyButton.enabled = isValidEmail;
}


#pragma mark TBVerifyUserOperationDelegate
-(void)didSucceedWithVerificationForEmail:(NSString *)email residence:(NSDictionary *)residence
{
    DDLogVerbose(@"%s %@:%@", __PRETTY_FUNCTION__, email, residence);    
    [self.thebox didSucceedWithVerificationForEmail:email residence:residence];
    [self dismissViewControllerAnimated:YES completion:nil];    
}

-(void)didFailOnVerifyWithError:(NSError *)error
{
    MBProgressHUD* hud = [VLBHuds newOnDidFailOnVerifyWithError:self.view];
    [hud addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideHUDForView)]];
    hud.userInteractionEnabled = YES;

    [hud show:YES];
}

-(void)didEnterEmail:(NSString *)email forResidence:(NSString *)residence
{
    self.accounts = [NSMutableArray arrayWithArray:[SSKeychain accountsForService:THE_BOX_SERVICE]];
    self.emailStatuses = [NSMutableArray arrayWithCapacity:self.accounts.count];
    for (id obj in self.accounts) {
        [self.emailStatuses addObject:@(VLBEmailStatusDefault)];
    }

    [self.accountsTableView reloadData];
}

#pragma mark TBCreateUserOperationDelegate
-(void)didSucceedWithRegistrationForEmail:(NSString *)email residence:(NSString *)residence
{
    DDLogVerbose(@"%s", __PRETTY_FUNCTION__);
    
    MBProgressHUD* hud = [VLBHuds newOnDidSucceedWithRegistration:self.view email:email residence:residence];
    [hud addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideHUDForView)]];
    hud.userInteractionEnabled = YES;
        
    [hud show:YES];
}

-(void)didFailOnRegistrationWithError:(NSError*)error
{
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

#pragma mark UITableViewDatasource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
return [self.accounts count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *emailCell = [tableView dequeueReusableCellWithIdentifier:@"VLBEmailTableViewCell"];
    
    if(!emailCell){
				emailCell = [VLBTableViewCells newEmailTableViewCell];
    }
    
    emailCell.textLabel.text = [self.thebox emailForAccountAtIndex:indexPath.row];

    VLBEmailStatus emailStatus = [[self.emailStatuses objectAtIndex:indexPath.row] intValue];
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
    
    [self.thebox deleteAccountAtIndex:indexPath.row];
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

    __weak VLBEmailViewController *wself = self;
    
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

    		[VLBErrorBlocks localizedDescriptionOfErrorBlock:self.view](error);
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
