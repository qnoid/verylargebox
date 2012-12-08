//
//  TBEmailViewController.m
//  thebox
//
//  Created by Markos Charatzas on 19/11/2012.
//  Copyright (c) 2012 TheBox. All rights reserved.
//

#import "TBEmailViewController.h"
#import "TBButton.h"
#import "TBProfileViewController.h"
#import "HomeUIGridViewController.h"
#import "TheBoxQueries.h"
#import "AFHTTPRequestOperation.h"
#import "TBSecureHashA1.h"
#import "SSKeychain.h"

@interface TBEmailViewController ()
@property(nonatomic, strong) NSOperationQueue *operations;
-(id)initWithBundle:(NSBundle *)nibBundleOrNil;
@end

@implementation TBEmailViewController

+(TBEmailViewController*)newEmailViewController {
return [[TBEmailViewController alloc] initWithBundle:[NSBundle mainBundle]];
}

-(id)initWithBundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:@"TBEmailViewController" bundle:nibBundleOrNil];
    
    if (!self) {
        return nil;
    }
    
    self.operations = [[NSOperationQueue alloc] init];

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    UIColor *darkOrange = [TBColors colorDarkOrange];
    
    [[self.theBoxButton.border
        borderWidth:2.0f]
        borderColor:darkOrange.CGColor];
    
    [[self.registerButton.border
        borderWidth:2.0f]
        borderColor:darkOrange.CGColor];

    [self.theBoxButton onTouchDown:makeButtonDarkOrange()];
    [self.theBoxButton onTouchUp:makeButtonWhite()];
    
    __unsafe_unretained TBEmailViewController *uself = self;

    [self.registerButton onTouchDown:^(UIButton *button) {
        
        //no need to handle viewcontroller unloading
        AFHTTPRequestOperation *newRegistrationOperation =
            [TheBoxQueries newCreateUserQuery:uself email:uself.emailTextField.text];
        
        [self.operations addOperation:newRegistrationOperation];
        
        TBProfileViewController *profileViewController = [TBProfileViewController newProfileViewController];
        HomeUIGridViewController *homeGridViewControler = [HomeUIGridViewController newHomeGridViewController];
        
        UITabBarController* tabBarController = [[UITabBarController alloc] init];
        tabBarController.viewControllers = @[profileViewController, [[UINavigationController alloc] initWithRootViewController:homeGridViewControler]];
        
        [uself presentViewController:tabBarController animated:YES completion:nil];
    }];
    [self.registerButton onTouchUp:makeButtonWhite()];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
return YES;
}

#pragma mark TBNSErrorDelegate
-(void)didFailWithCannonConnectToHost:(NSError *)error
{
    UIAlertView* cannotConnectToHostAlertView = [[UIAlertView alloc] initWithTitle:@"Cannot connect to host" message:@"The was a problem connecting with thebox. Please check your internet connection and try again." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
    
    [cannotConnectToHostAlertView show];
}

#pragma mark TBRegistrationOperationDelegate
-(void)didSucceedWithRegistrationForEmail:(NSString *)email residence:(NSString *)residence
{
    NSError *error = nil;
    [SSKeychain setPassword:residence forService:THE_BOX_SERVICE account:email error:&error];
    
    if (error) {
        NSLog(@"WARNING: %s %@", __PRETTY_FUNCTION__, error);
    }
    
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

-(void)didFailOnRegistrationWithError:(NSError*)error
{
    NSLog(@"WARNING: %s %@", __PRETTY_FUNCTION__, error);
}

@end
