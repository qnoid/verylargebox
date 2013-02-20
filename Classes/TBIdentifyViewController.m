//
//  TBIdentifyViewController.m
//  thebox
//
//  Created by Markos Charatzas on 18/11/2012.
//  Copyright (c) 2012 TheBox. All rights reserved.
//

#import "TBIdentifyViewController.h"
#import "TBButton.h"
#import "TBColors.h"
#import "TBEmailViewController.h"
#import "HomeUIGridViewController.h"
#import "SSKeychain.h"
#import "TheBoxQueries.h"
#import "TBProfileViewController.h"
#import "AFHTTPRequestOperation.h"
#import "TBUITableViewDataSourceBuilder.h"
#import "TBUIView.h"
#import "TBVerifyOperationBlock.h"

@interface TBIdentifyViewController ()
@property(nonatomic, strong) NSOperationQueue *operations;
@property(nonatomic, strong) NSMutableArray* accounts;
-(id)initWithBundle:(NSBundle *)nibBundleOrNil accounts:(NSMutableArray*) accounts;
@end

@implementation TBIdentifyViewController

+(TBIdentifyViewController*)newIdentifyViewController
{
    NSArray* accounts = [SSKeychain accountsForService:THE_BOX_SERVICE];

    TBIdentifyViewController* identifyViewController = [[TBIdentifyViewController alloc] initWithBundle:[NSBundle mainBundle] accounts:[NSMutableArray arrayWithArray:accounts]];
    
    identifyViewController.title = @"thebox";
    
    UIBarButtonItem *actionButton = [[UIBarButtonItem alloc]
                                     initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                                     target:identifyViewController
                                     action:@selector(launchFeedback)];
    identifyViewController.navigationItem.leftBarButtonItem = actionButton;

return identifyViewController;
}

-(id)initWithBundle:(NSBundle *)nibBundleOrNil accounts:(NSMutableArray*) accounts
{
    self = [super initWithNibName:@"TBIdentifyViewController" bundle:nibBundleOrNil];
    
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
    UIColor *darkOrange = [TBColors colorDarkOrange];

    [[self.theBoxButton.border
        borderWidth:2.0f]
        borderColor:darkOrange.CGColor];
    
    [self.identifyButton cornerRadius:88.0f];
    
    [[self.identifyButton.border
        borderWidth:2.0f]
        borderColor:darkOrange.CGColor];
    
    [[self.browseButton.border
        borderWidth:2.0f]
        borderColor:darkOrange.CGColor];
    
    __unsafe_unretained TBIdentifyViewController *uself = self;
    
    [self.identifyButton onTouchDown:^(UIButton *button) {
        makeButtonDarkOrange();
        TBEmailViewController* emailViewController = [TBEmailViewController newEmailViewController];
        emailViewController.delegate = uself;
        emailViewController.createUserOperationDelegate = uself;
        [uself.navigationController pushViewController:emailViewController animated:YES];
    }];
    [self.identifyButton onTouchUp:makeButtonWhite()];
    [self.theBoxButton onTouchDown:makeButtonDarkOrange()];
    [self.theBoxButton onTouchUp:makeButtonWhite()];
    [self.browseButton onTouchDown:^(UIButton *button)
    {
        HomeUIGridViewController *homeGridViewControler = [HomeUIGridViewController newHomeGridViewController];
        
        UIBarButtonItem *closeButton = [[UIBarButtonItem alloc]
                                        initWithTitle:@"Identify"
                                        style:UIBarButtonItemStylePlain
                                        target:uself
                                        action:@selector(dismissViewControllerAnimated)];
        
        homeGridViewControler.navigationItem.leftBarButtonItem = closeButton;

        [uself presentViewController:[[UINavigationController alloc] initWithRootViewController:homeGridViewControler] animated:YES completion:nil];
    }];
    [self.browseButton onTouchUp:makeButtonWhite()];    
}

-(void)viewWillAppear:(BOOL)animated
{
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)launchFeedback {
    [TestFlight openFeedbackView];
}

-(void)dismissViewControllerAnimated
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark TBVerifyUserOperationDelegate
-(void)didSucceedWithVerificationForEmail:(NSString *)email residence:(NSDictionary *)residence
{
    NSLog(@"%s %@:%@", __PRETTY_FUNCTION__, email, residence);
    TBProfileViewController *profileViewController = [TBProfileViewController newProfileViewController:residence email:email];
    HomeUIGridViewController *homeGridViewControler = [HomeUIGridViewController newHomeGridViewController];
    
    UITabBarController* tabBarController = [[UITabBarController alloc] init];
    tabBarController.viewControllers = @[[[UINavigationController alloc] initWithRootViewController:profileViewController], [[UINavigationController alloc] initWithRootViewController:homeGridViewControler]];
    
    [self presentViewController:tabBarController animated:YES completion:nil];
}

-(void)didFailOnVerifyWithError:(NSError *)error
{
    UIAlertView* userUnauthorisedAlertView = [[UIAlertView alloc] initWithTitle:@"Unauthorised" message:@"You are not authorised. Please check your email to verify." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
    
    [userUnauthorisedAlertView show];
}

#pragma mark TBEmailViewControllerDelegate
-(void)didEnterEmail:(NSString *)email forResidence:(NSString *)residence
{
    NSError *error = nil;
    [SSKeychain setPassword:residence forService:THE_BOX_SERVICE account:email error:&error];
    
    if (error) {
        NSLog(@"WARNING: %s %@", __PRETTY_FUNCTION__, error);
    }
    
    self.accounts = [NSMutableArray arrayWithArray:[SSKeychain accountsForService:THE_BOX_SERVICE]];
    [self.accountsTableView reloadData];
}

#pragma mark TBRegistrationOperationDelegate
-(void)didSucceedWithRegistrationForEmail:(NSString *)email residence:(NSString *)residence
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    UIAlertView* userUnauthorisedAlertView = [[UIAlertView alloc] initWithTitle:@"New Registration" message:[NSString stringWithFormat:@"Please check your email %@.", email] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
    
    [userUnauthorisedAlertView show];    
}

-(void)didFailOnRegistrationWithError:(NSError*)error
{
    NSLog(@"WARNING: %s %@", __PRETTY_FUNCTION__, error);
}

#pragma mark TBNSErrorDelegate
-(void)didFailWithCannonConnectToHost:(NSError *)error
{
    UIAlertView* cannotConnectToHostAlertView = [[UIAlertView alloc] initWithTitle:@"Cannot connect to host" message:@"The was a problem connecting with thebox. Please check your internet connection and try again." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
    
    [cannotConnectToHostAlertView show];
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
        emailCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellSelectionStyleNone reuseIdentifier:@"Cell"];
        emailCell.textLabel.textColor = [TBColors colorLightOrange];
        emailCell.textLabel.textAlignment = NSTextAlignmentCenter;
        UIView* selectedBackgroundView = [[UIView alloc] init];
        selectedBackgroundView.backgroundColor = [TBColors colorLightOrange];
        [[selectedBackgroundView.border
            borderWidth:2.0f]
            borderColor:[TBColors colorDarkOrange].CGColor];
        emailCell.selectedBackgroundView = selectedBackgroundView;
    }
    
    NSString* email = [[self.accounts objectAtIndex:indexPath.row] objectForKey:@"acct"];
    emailCell.textLabel.text = email;

    tbBmailStatus(TBEmailStatusVerified)(emailCell);
    
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
    tbBmailStatus(TBEmailStatusUnknown)(tableViewCell);

    __weak NSObject<TBVerifyUserOperationDelegate> *wself = self;
    
    TBVerifyOperationBlock *verifyOperationBlock = [TBVerifyOperationBlock new];
    verifyOperationBlock.didSucceedWithVerificationForEmail = ^(NSString* email, NSDictionary* residence)
    {
        tbBmailStatus(TBEmailStatusVerified)(tableViewCell);
        [wself didSucceedWithVerificationForEmail:email residence:residence];
    };
    
    verifyOperationBlock.didFailOnVerifyWithError = ^(NSError* error)
    {
        tbBmailStatus(TBEmailStatusError)(tableViewCell);

        if(NSURLErrorNotConnectedToInternet == error.code){
            UIAlertView* notConnectedToInternetAlertView = [[UIAlertView alloc] initWithTitle:@"Not Connected to Internet" message:@"You are not connected to the internet. Check your connection and try again." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
            
            [notConnectedToInternetAlertView show];            
        return;
        }

        [wself didFailOnVerifyWithError:error];
    };
    
    NSArray* emails = [SSKeychain accountsForService:THE_BOX_SERVICE];
    NSString* email = [[emails objectAtIndex:indexPath.row] objectForKey:@"acct"];
    
    NSError *error = nil;
    NSString *residence = [SSKeychain passwordForService:THE_BOX_SERVICE account:email error:&error];
    
    AFHTTPRequestOperation *verifyUser = [TheBoxQueries newVerifyUserQuery:verifyOperationBlock email:email residence:residence];
    
    [self.operations addOperation:verifyUser];
}
@end
