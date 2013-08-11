//  VLBDetailsViewController.m
//  verylargebox
//
//  Created by Markos Charatzas on 10/04/2012.
//  Copyright (c) 2012 (verylargebox.com). All rights reserved.
//

#import "VLBDetailsViewController.h"
#import "VLBMacros.h"
#import "NSDictionary+VLBItem.h"
#import "VLBBoxAlertViews.h"
#import "NSDictionary+VLBLocation.h"
#import "NSDictionary+VLBDictionary.h"
#import "VLBLocationService.h"
#import "UIImageView+AFNetworking.h"
#import "VLBDrawRects.h"

@interface VLBDetailsViewController ()
-(id)initWithBundle:(NSBundle *)nibBundleOrNil onItem:(NSDictionary*)item;
@property(nonatomic, strong) NSMutableDictionary* item;
@property(nonatomic, strong) UIImage* placeholderImage;
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
    self.placeholderImage = [UIImage imageNamed:@"placeholder.png"];
    
return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.storeButton.titleLabel.minimumScaleFactor = 10;
    self.storeButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    [self.storeButton.titleLabel sizeToFit];
    
    NSString *imageURL = [self.item vlb_objectForKey:VLBItemIPhoneImageURL];
    [self.itemImageView setImageWithURL:[NSURL URLWithString:imageURL] placeholderImage:self.placeholderImage];
    
    NSDictionary *location = [self.item vlb_location];
    
    id name = [location vlb_objectForKey:VLBLocationName ifNil:@""];

    [self.storeButton setTitle:name forState:UIControlStateNormal];
    [self.storeButton.titleLabel sizeToFit];

    [self.whenButton setTitle:[self.item vlb_objectForKey:VLBItemWhen] forState:UIControlStateNormal];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(IBAction)didTouchUpInsideAskForDirectionsButton:(id)sender
{
    /**
     {
     "created_at" = "2013-03-07T19:58:26Z";
     foursquareid = 4b082a2ff964a520380523e3;
     id = 265;
     lat = "55.94223";
     lng = "-3.18421";
     name = "The Dagda Bar";
     "updated_at" = "2013-03-07T19:58:26Z";
     }
     */
    NSDictionary *location = [self.item vlb_location];
    id name = [location vlb_objectForKey:VLBLocationName ifNil:@""];

    __weak VLBDetailsViewController *wself = self;
    
    VLBAlertViewBlock onOkGetDirections = ^(UIAlertView *alertView, NSInteger buttonIndex) {
        [Flurry logEvent:@"didGetDirections" withParameters:@{@"controller": @"VLBFeedItemView",
         VLBLocationName:name,
               VLBItemId:[wself.item objectForKey:VLBItemId],
         VLBItemImageURL:[wself.item vlb_objectForKey:VLBItemImageURL]}];
        
        [VLBLocationService decideOnDirections:[location vlb_coordinate]
                                       options:location]();
    };
    
    UIAlertView *alertView = [VLBBoxAlertViews location:name bar:onOkGetDirections];
    
    [alertView show];
}

-(void)drawRect:(CGRect)rect inView:(UIView *)view
{
    [[VLBDrawRects new] drawContextOfHexagonInRect:rect];
}

@end
