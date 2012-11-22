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

@interface TBEmailViewController ()
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
        
        [newRegistrationOperation start];
        
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

#pragma TBRegistrationOperationDelegate
-(void)didSucceedWithRegistration
{
    
}

-(void)didFailOnRegistrationWithError:(NSError*)error
{
    NSLog(@"WARNING: %s %@", __PRETTY_FUNCTION__, error);
}

@end
