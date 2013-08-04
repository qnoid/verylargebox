//
//  VLBUserItemView.m
//  verylargebox
//
//  Created by Markos Charatzas on 02/02/2013.
//  Copyright (c) 2013 (verylargebox.com). All rights reserved.
//

#import "VLBFeedItemView.h"
#import "VLBViews.h"
#import "VLBPolygon.h"
#import "VLBColors.h"
#import "VLBDrawRects.h"
#import "VLBMacros.h"
#import "NSDictionary+VLBItem.h"
#import "NSDictionary+VLBLocation.h"
#import "NSDictionary+VLBLocality.h"
#import "UIImageView+AFNetworking.h"
#import "VLBAlertViews.h"
#import "NSDictionary+VLBDictionary.h"
#import "VLBBoxAlertViews.h"
#import "VLBLocationService.h"
#import "NSObject+VLBObject.h"

typedef void(^VLBFeedItemViewInit)(VLBFeedItemView *userItemView);

static NSString* const DEFAULT_ITEM_THUMB = @"default_item_thumb";
static NSString* const DEFAULT_ITEM_TYPE = @"png";

@interface VLBFeedItemView ()
@property(nonatomic, strong) UIImage *defaultItemImage;
@end

VLBFeedItemViewInit const VLBFeedItemViewInitBlock = ^(VLBFeedItemView *feedItemView){
    
    feedItemView.didTapOnGetDirectionsButton = VLBButtonOnTouchNone;
    feedItemView.storeButton.titleLabel.minimumScaleFactor = 10;
    feedItemView.storeButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    [feedItemView.storeButton.titleLabel sizeToFit];
    [feedItemView.askForDirectionsButton vlb_cornerRadius:4.0];

    NSString* path = [[NSBundle mainBundle] pathForResource:DEFAULT_ITEM_THUMB ofType:DEFAULT_ITEM_TYPE];
    feedItemView.defaultItemImage = [UIImage imageWithContentsOfFile:path];
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
    [self.itemImageView setImageWithURL:[NSURL URLWithString:imageURL] placeholderImage:self.defaultItemImage];
    
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
    
    id name = [location vlb_objectForKey:VLBLocationName ifNil:@""];
    [self.storeButton setTitle:name forState:UIControlStateNormal];
    [self.storeButton.titleLabel sizeToFit];
    
    self.whenLabel.text = [item vlb_objectForKey:VLBItemWhen];
    
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
}

-(IBAction)didTapOnGetDirectionsButton:(UIButton*)sender
{
    self.didTapOnGetDirectionsButton(sender);
}

-(void)drawRect:(CGRect)rect inView:(UIView *)view
{
    [[VLBDrawRects new] drawContextOfHexagonInRect:rect];
}

@end
