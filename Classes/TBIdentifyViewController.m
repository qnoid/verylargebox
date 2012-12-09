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

@interface TBIdentifyViewController ()
@property(nonatomic, strong) NSOperationQueue *operations;
@property(nonatomic, strong) id<UITableViewDataSource> accountsDatasource;
-(id)initWithBundle:(NSBundle *)nibBundleOrNil accountsDatasource:(id<UITableViewDataSource>) accountsDatasource;
@end

@implementation TBIdentifyViewController

+(TBIdentifyViewController*)newIdentifyViewController
{
    TBUITableViewDataSourceBuilder *datasourceBuilder = [[TBUITableViewDataSourceBuilder alloc] init];

    NSArray* emails = [SSKeychain accountsForService:THE_BOX_SERVICE];
    
    [[datasourceBuilder numberOfRowsInSection:^NSInteger(UITableView *tableView, NSInteger section) {
        return [emails count];
    }]
    cellForRowAtIndexPath:^UITableViewCell *(UITableView *tableView, NSIndexPath *indexPath)
    {
        UITableViewCell *emailCell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
        
        if(!emailCell)
        {
            emailCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellSelectionStyleNone reuseIdentifier:@"Cell"];
            emailCell.textLabel.textColor = [TBColors colorLightOrange];
            emailCell.textLabel.textAlignment = NSTextAlignmentCenter;
        }
        
        NSString* email = [[emails objectAtIndex:indexPath.row] objectForKey:@"acct"];
        emailCell.textLabel.text = email;
        
    return emailCell;
    }];
    

return [[TBIdentifyViewController alloc] initWithBundle:[NSBundle mainBundle] accountsDatasource:[datasourceBuilder newDatasource]];
}

-(id)initWithBundle:(NSBundle *)nibBundleOrNil accountsDatasource:(id<UITableViewDataSource>) accountsDatasource;
{
    self = [super initWithNibName:@"TBIdentifyViewController" bundle:nibBundleOrNil];
    
    if (!self) {
        return nil;
    }
    
    self.operations = [[NSOperationQueue alloc] init];
    self.accountsDatasource = accountsDatasource;
    
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
    
    __unsafe_unretained UIViewController *uself = self;
    
    [self.identifyButton onTouchDown:^(UIButton *button) {
        makeButtonDarkOrange();
        TBEmailViewController* emailViewController = [TBEmailViewController newEmailViewController];
        [uself.navigationController pushViewController:emailViewController animated:YES];
    }];
    [self.identifyButton onTouchUp:makeButtonWhite()];
    [self.theBoxButton onTouchDown:makeButtonDarkOrange()];
    [self.theBoxButton onTouchUp:makeButtonWhite()];
    [self.browseButton onTouchDown:^(UIButton *button) {
        HomeUIGridViewController *homeGridViewControler = [HomeUIGridViewController newHomeGridViewController];
        [uself presentViewController:[[UINavigationController alloc] initWithRootViewController:homeGridViewControler] animated:YES completion:nil];
    }];
    [self.browseButton onTouchUp:makeButtonWhite()];
}

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark TBVerifyUserOperationDelegate
-(void)didSucceedWithVerificationForEmail:(NSString *)email residence:(NSString *)residence
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    TBProfileViewController *profileViewController = [TBProfileViewController newProfileViewController];
    HomeUIGridViewController *homeGridViewControler = [HomeUIGridViewController newHomeGridViewController];
    
    UITabBarController* tabBarController = [[UITabBarController alloc] init];
    tabBarController.viewControllers = @[profileViewController, [[UINavigationController alloc] initWithRootViewController:homeGridViewControler]];
    
    [self presentViewController:tabBarController animated:YES completion:nil];
}

-(void)didFailOnVerifyWithError:(NSError *)error
{
    NSLog(@"ERROR: %s %@", __PRETTY_FUNCTION__, error);
    UIAlertView* userUnauthorisedAlertView = [[UIAlertView alloc] initWithTitle:@"Unauthorised" message:@"You are not authorised. Please check your email to verify." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
    
    [userUnauthorisedAlertView show];
}

#pragma mark UITableViewDatasource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
return [self.accountsDatasource tableView:tableView numberOfRowsInSection:section];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
return [self.accountsDatasource tableView:tableView cellForRowAtIndexPath:indexPath];
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle != UITableViewCellEditingStyleDelete) {
        return;
    }
    
    NSArray* emails = [SSKeychain accountsForService:THE_BOX_SERVICE];
    NSString* email = [[emails objectAtIndex:indexPath.row] objectForKey:@"acct"];
    
    [SSKeychain deletePasswordForService:THE_BOX_SERVICE account:email];
    
    [self.accountsTableView beginUpdates];
    [self.accountsTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    [self.accountsTableView endUpdates];
}


#pragma mark UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray* emails = [SSKeychain accountsForService:THE_BOX_SERVICE];
    NSString* email = [[emails objectAtIndex:indexPath.row] objectForKey:@"acct"];
    
    NSError *error = nil;
    NSString *residence = [SSKeychain passwordForService:THE_BOX_SERVICE account:email error:&error];
    
    AFHTTPRequestOperation *verifyUser = [TheBoxQueries newVerifyUserQuery:self email:email residence:residence];
    
    [self.operations addOperation:verifyUser];

}
@end
