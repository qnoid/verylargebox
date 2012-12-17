//
//  TBEmailViewController.m
//  thebox
//
//  Created by Markos Charatzas on 19/11/2012.
//  Copyright (c) 2012 TheBox. All rights reserved.
//

#import "TBEmailViewController.h"
#import "TBButton.h"
#import "TBUIView.h"
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
    
    __weak TBEmailViewController *uself = self;
    [self.registerButton onTouchDown:^(UIButton *button) {
        
        TBSecureHashA1 *sha1 = [TBSecureHashA1 new];
        NSString* residence = [sha1 newKey];

        [self.delegate didEnterEmail:uself.emailTextField.text forResidence:residence];

        //no need to handle viewcontroller unloading
        AFHTTPRequestOperation *newRegistrationOperation =
            [TheBoxQueries newCreateUserQuery:self.createUserOperationDelegate email:uself.emailTextField.text residence:residence];
        
        [self.operations addOperation:newRegistrationOperation];
        
        [uself.navigationController popViewControllerAnimated:YES];
    }];
    [self.registerButton onTouchUp:makeButtonWhite()];
    [[self.emailTextField.border
        borderWidth:2.0f]
        borderColor:[TBColors colorDarkOrange].CGColor];
}

#pragma mark UITextFieldDelegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
return YES;
}

#pragma mark TBRegistrationOperationDelegate
-(void)didSucceedWithRegistrationForEmail:(NSString *)email residence:(NSString *)residence
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    NSError *error = nil;
    [SSKeychain setPassword:residence forService:THE_BOX_SERVICE account:email error:&error];
    
    if (error) {
        NSLog(@"WARNING: %s %@", __PRETTY_FUNCTION__, error);
    }
    
    UIAlertView* userUnauthorisedAlertView = [[UIAlertView alloc] initWithTitle:@"New Registration" message:[NSString stringWithFormat:@"Please check your email %@.", email] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
    
    [userUnauthorisedAlertView show];

}

-(void)didFailOnRegistrationWithError:(NSError*)error
{
    NSLog(@"WARNING: %s %@", __PRETTY_FUNCTION__, error);
}

@end
