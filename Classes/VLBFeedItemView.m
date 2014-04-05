//
//  VLBUserItemView.m
//  verylargebox
//
//  Created by Markos Charatzas on 02/02/2013.
//  Copyright (c) 2013 (verylargebox.com). All rights reserved.
//

#import "VLBFeedItemView.h"
#import "VLBDrawRects.h"
#import "VLBMacros.h"
#import "NSDictionary+VLBItem.h"
#import "NSDictionary+VLBLocation.h"
#import "UIImageView+AFNetworking.h"
#import "VLBAlertViews.h"
#import "NSDictionary+VLBDictionary.h"
#import "VLBBoxAlertViews.h"
#import "VLBTheBox.h"
#import "VLBReportViewController.h"

typedef void(^VLBFeedItemViewInit)(VLBFeedItemView *userItemView);

@interface VLBFeedItemView ()
@property(nonatomic, strong) VLBTheBox* theBox;
@property(nonatomic, strong) UIImage* placeholderImage;
@end

VLBFeedItemViewInit const VLBFeedItemViewInitBlock = ^(VLBFeedItemView *feedItemView){
    
    feedItemView.theBox = [VLBTheBox newTheBox];
    feedItemView.placeholderImage = [UIImage imageNamed:@"placeholder.png"];
    feedItemView.didTapOnGetDirectionsButton = VLBButtonOnTouchNone;
    feedItemView.storeButton.titleLabel.minimumScaleFactor = 10;
    feedItemView.storeButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    feedItemView.storeButton.titleLabel.numberOfLines = 0;
    [feedItemView.askForDirectionsButton setTitle:NSLocalizedString(@"buttons.getDirections.title", @"Get directions") forState:UIControlStateNormal];
    [feedItemView.askForDirectionsButton vlb_cornerRadius:4.0];
    [feedItemView.reportButton vlb_cornerRadius:4.0];
    feedItemView.didTapOnReportButton = VLBButtonOnTouchNone;
};

@implementation VLBFeedItemView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    VLB_IF_NOT_SELF_RETURN_NIL()
    VLB_LOAD_VIEW()
    
    VLBFeedItemViewInitBlock(self);
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    VLB_IF_NOT_SELF_RETURN_NIL()
    VLB_LOAD_VIEW()
    
    VLBFeedItemViewInitBlock(self);
    
    return self;
}

-(void)viewWillAppear:(NSDictionary*)item
{
    if(item == nil){
        [NSException raise:@"RuntimException" format:@"item shouldn't be nil"];
    }
    
    NSString *imageURL = [item vlb_objectForKey:VLBItemIPhoneImageURL];
    [self.itemImageView setImageWithURL:[NSURL URLWithString:imageURL] placeholderImage:self.placeholderImage];
    
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
    NSDictionary *location = [item vlb_location];
    NSString* name = [location vlb_objectForKey:VLBLocationName ifNil:@""];

    [self.storeButton setTitle:name forState:UIControlStateNormal];
    [self.storeButton.titleLabel sizeToFit];
    
    [self.whenButton setTitle:[item vlb_when] forState:UIControlStateNormal];
    
    self.didTapOnGetDirectionsButton = ^(UIButton* button){
        VLBAlertViewBlock onOkGetDirections = ^(UIAlertView *alertView, NSInteger buttonIndex) {
            [Flurry logEvent:@"didGetDirections" withParameters:@{@"controller": @"VLBFeedItemView",
             VLBLocationName:name,
                   VLBItemId:[item objectForKey:VLBItemId],
             VLBItemImageURL:[item vlb_objectForKey:VLBItemImageURL]}];
            
            [VLBLocationService decideOnDirections:[location vlb_coordinate]
                                           options:location]();
        };
        
        UIAlertView *alertView = [VLBBoxAlertViews location:name bar:onOkGetDirections];
        
        [alertView show];
    };
    
    __weak VLBFeedItemView *wself = self;
    
    self.didTapOnReportButton = ^(UIButton* button){
        VLBReportViewController *reportViewController = [wself.theBox newReportViewController:item];
        
        [wself.parentViewController presentViewController:[wself.theBox newNavigationController:reportViewController] animated:YES completion:nil];
    };
}

-(IBAction)didTapOnGetDirectionsButton:(UIButton*)sender
{
    self.didTapOnGetDirectionsButton(sender);
}

-(IBAction)didTapOnReportButton:(UIButton*)sender
{
    self.didTapOnReportButton(sender);
}

-(void)drawRect:(CGRect)rect inView:(UIView *)view
{
    [[VLBDrawRects new] drawContextOfHexagonInRect:rect];
}

@end
