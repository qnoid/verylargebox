//
//  VLBTextViewController.m
//  verylargebox
//
//  Created by Markos Charatzas on 08/04/2014.
//  Copyright (c) 2014 verylargebox.com. All rights reserved.
//

#import "VLBTextViewController.h"
#import "VLBViewControllers.h"

@interface VLBTextViewController ()

@end

@implementation VLBTextViewController

+(instancetype)textViewController:(NSString*)title
{
    VLBTextViewController *viewController = [[VLBTextViewController alloc] init];
    
    UILabel* titleLabel = [[VLBViewControllers new] titleView:title];
    viewController.navigationItem.titleView = titleLabel;
    [titleLabel sizeToFit];
    
    viewController.navigationItem.leftBarButtonItem = [[VLBViewControllers new] closeButton:viewController action:@selector(dismissViewControllerAnimated)];
    
return viewController;
}

-(void)dismissViewControllerAnimated
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.textView.attributedText = self.attributedText;
    [self.textView sizeToFit];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
