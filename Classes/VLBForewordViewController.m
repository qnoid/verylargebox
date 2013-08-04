//
//  VLBForewordViewController.m
//  verylargebox
//
//  Created by Markos Charatzas on 10/07/2013.
//  Copyright (c) 2013 verylargebox.com. All rights reserved.
//

#import "VLBForewordViewController.h"
#import <Social/Social.h>
#import "VLBViewControllers.h"
#import "VLBMacros.h"
#import "VLBView.h"
#import "VLBHuds.h"

@interface VLBForewordViewController ()

@end

@implementation VLBForewordViewController

+(VLBForewordViewController*)newForewordViewController
{
    VLBForewordViewController *forewordViewController =
            [[VLBForewordViewController alloc] initWithBundle:[NSBundle mainBundle]];
    
    forewordViewController.navigationItem.leftBarButtonItem =
        [[VLBViewControllers new] closeButton:forewordViewController
                                       action:@selector(dismissViewControllerAnimated:)];
    
return forewordViewController;
}

- (id)initWithBundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:@"VLBForewordViewController" bundle:nibBundleOrNil];
    
    VLB_IF_NOT_SELF_RETURN_NIL();
    
return self;
}

- (void)dismissViewControllerAnimated:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)didTouchUpInsideTwitterHandleButton:(id)sender
{
    SLComposeViewController* composeViewController = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
    
    if(!composeViewController){
        [VLBHuds newWithView:self.view config:^MBProgressHUD *(MBProgressHUD *hud) {
            VLB_PROGRESS_HUD_CUSTOM_VIEW_CIRCLE_NO(hud);
            hud.labelText = NSLocalizedString(@"huds.twitter.noaccount.header", @"No twitter account setup.");
            hud.detailsLabelText = NSLocalizedString(@"huds.twitter.noaccount.details", @"Go to Settings -> Twitter to add an account");
        return hud;
        }];
        
    return;
    }
    
    [composeViewController setInitialText:@"@qnoid "];
    
    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:composeViewController] animated:YES completion:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.scrollView.contentSize = CGSizeMake(320, 755);
    [self.imageView vlb_borderWidth:2.0];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
