//  VLBDetailsViewController.m
//  verylargebox
//
//  Created by Markos Charatzas on 10/04/2012.
//  Copyright (c) 2012 (verylargebox.com). All rights reserved.
//

#import "VLBDetailsViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "VLBLocationService.h"
#import "VLBLocationServiceDelegate.h"
#import "VLBUpdateItemOperationDelegate.h"
#import "VLBNotifications.h"
#import "VLBStoresViewController.h"
#import "VLBQueries.h"
#import "AFHTTPRequestOperation.h"
#import "UIViewController+VLBViewController.h"
#import "VLBTypography.h"
#import "VLBFeedItemView.h"
#import "VLBMacros.h"

@interface VLBDetailsViewController ()
-(id)initWithBundle:(NSBundle *)nibBundleOrNil onItem:(NSDictionary*)item;
@property(nonatomic) VLBLocationService *theBoxLocationService;
@property(nonatomic) CLLocation *location;
@property(nonatomic, strong) NSMutableDictionary* item;
@end

@implementation VLBDetailsViewController

+(VLBDetailsViewController *)newDetailsViewController:(NSDictionary*)item
{
    VLBDetailsViewController *detailsViewController =
        [[VLBDetailsViewController alloc] initWithBundle:[NSBundle mainBundle] onItem:item];
    
return detailsViewController;
}

- (id)initWithBundle:(NSBundle *)nibBundleOrNil onItem:(NSMutableDictionary*)item;
{
    self = [super initWithNibName:NSStringFromClass([VLBDetailsViewController class]) bundle:nibBundleOrNil];

    VLB_IF_NOT_SELF_RETURN_NIL();
    
    self.item = item;

return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.itemView viewWillAppear:self.item];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
