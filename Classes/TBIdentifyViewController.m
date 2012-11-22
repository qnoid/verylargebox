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

@interface TBIdentifyViewController ()
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

@end
