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

@interface TBIdentifyViewController ()
@property(nonatomic, strong) NSOperationQueue *operations;
-(id)initWithBundle:(NSBundle *)nibBundleOrNil;
@end

@implementation TBIdentifyViewController

+(TBIdentifyViewController*)newIdentifyViewController {
return [[TBIdentifyViewController alloc] initWithBundle:[NSBundle mainBundle]];
}

-(id)initWithBundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:@"TBIdentifyViewController" bundle:nibBundleOrNil];
    
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

    NSArray* emails = [SSKeychain accountsForService:THE_BOX_SERVICE];
    
    for (NSDictionary* email in emails) {
        [self.emailButton setTitle:[email objectForKey:@"acct"] forState:UIControlStateNormal];
    }
    
    [self.emailButton onTouchDown:^(UIButton *button)
    {
        NSError *error = nil;
        
        AFHTTPRequestOperation *verifyUser =
            [TheBoxQueries newVerifyUserQuery:self email:self.emailButton.titleLabel.text residence:[SSKeychain passwordForService:THE_BOX_SERVICE account:self.emailButton.titleLabel.text error:&error]];
        
        [self.operations addOperation:verifyUser];
    }];
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
}
@end
