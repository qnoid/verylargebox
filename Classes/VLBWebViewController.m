//
//  VLBWebViewController.m
//  verylargebox
//
//  Created by Markos Charatzas on 31/08/2013.
//  Copyright (c) 2013 verylargebox.com. All rights reserved.
//

#import "VLBWebViewController.h"
#import "VLBMacros.h"
#import "VLBTheBox.h"

@interface VLBWebViewController ()
@property(nonatomic, weak) VLBTheBox *thebox;
@end

@implementation VLBWebViewController

+(VLBWebViewController*)newWebViewController:(VLBTheBox*)thebox
{
    VLBWebViewController *webViewController = [[VLBWebViewController alloc] initWithBundle:[NSBundle mainBundle] thebox:(VLBTheBox*)thebox];
    
    
return webViewController;
}

-(id)initWithBundle:(NSBundle *)nibBundleOrNil thebox:(VLBTheBox*)thebox
{
    self = [super initWithNibName:NSStringFromClass([VLBWebViewController class]) bundle:nibBundleOrNil];
    
    VLB_IF_NOT_SELF_RETURN_NIL();
    
    self.thebox = thebox;
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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


- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    
}
@end
