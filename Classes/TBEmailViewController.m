//
//  TBEmailViewController.m
//  thebox
//
//  Created by Markos Charatzas on 19/11/2012.
//  Copyright (c) 2012 TheBox. All rights reserved.
//

#import "TBEmailViewController.h"
#import "TBButton.h"
#import "TBView.h"
#import "TBProfileViewController.h"
#import "TheBoxQueries.h"
#import "AFHTTPRequestOperation.h"
#import "TBSecureHashA1.h"
#import "SSKeychain.h"
#import "TBViews.h"

@interface TBEmailViewController ()
@property(nonatomic, strong) NSOperationQueue *operations;
-(id)initWithBundle:(NSBundle *)nibBundleOrNil;
@end

@implementation TBEmailViewController

+(TBEmailViewController*)newEmailViewController
{
    TBEmailViewController* emailViewController = [[TBEmailViewController alloc] initWithBundle:[NSBundle mainBundle]];
    emailViewController.title = @"Identify";
    
    return emailViewController;
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
    [[self.registerButton.border
        borderWidth:2.0f]
        borderColor:darkOrange.CGColor];
    
    __weak TBEmailViewController *uself = self;
    [self.registerButton onTouchDown:^(UIButton *button) {
        [uself didTouchUpInsideRegister];
    }];
    [self.registerButton onTouchUp:makeButtonWhite()];
    [[self.emailTextField.border
        borderWidth:2.0f]
        borderColor:[TBColors colorDarkOrange].CGColor];
}

#pragma mark UITextFieldDelegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    [self didTouchUpInsideRegister];
return YES;
}

-(void)didTouchUpInsideRegister
{
    TBSecureHashA1 *sha1 = [TBSecureHashA1 new];
    NSString* residence = [sha1 newKey];
    
    [self.delegate didEnterEmail:self.emailTextField.text forResidence:residence];
    
    //no need to handle viewcontroller unloading
    AFHTTPRequestOperation *newRegistrationOperation =
        [TheBoxQueries newCreateUserQuery:self.createUserOperationDelegate email:self.emailTextField.text residence:residence];
    
    [self.operations addOperation:newRegistrationOperation];
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
