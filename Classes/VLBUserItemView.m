//
//  VLBUserItemView.m
//  thebox
//
//  Created by Markos Charatzas on 02/02/2013.
//  Copyright (c) 2013 (verylargebox.com). All rights reserved.
//

#import "VLBUserItemView.h"
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

static const CLLocationDegrees EmptyLocation = -1000.0;
static const CLLocationCoordinate2D EmptyLocationCoordinate = {-1000.0, -1000.0};

static NSString* const DEFAULT_ITEM_THUMB = @"default_item_thumb";
static NSString* const DEFAULT_ITEM_TYPE = @"png";

@interface VLBUserItemView ()
@property(nonatomic, strong) UIImage *defaultItemImage;
@end

@implementation VLBUserItemView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];

    VLB_IF_NOT_SELF_RETURN_NIL()
    VLB_LOAD_VIEW()
    
    self.didTapOnGetDirectionsButton = tbUserItemViewGetDirections();
    self.storeLabel.layer.sublayerTransform = CATransform3DMakeTranslation(0, 5, 0);

    
return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    VLB_IF_NOT_SELF_RETURN_NIL()
    VLB_LOAD_VIEW()
    
    self.didTapOnGetDirectionsButton = tbUserItemViewGetDirections();    
    self.storeLabel.layer.sublayerTransform = CATransform3DMakeTranslation(0, 5, 0);
    
    NSString* path = [[NSBundle mainBundle] pathForResource:DEFAULT_ITEM_THUMB ofType:DEFAULT_ITEM_TYPE];
    self.defaultItemImage = [UIImage imageWithContentsOfFile:path];

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
    
    id name = [location vlb_objectForKey:VLBLocationName];
    if([[NSNull null] isEqual:name]){
        name = @"";
    }

    NSDictionary *locality = [item vlb_locality];

    id localityName = [locality vlb_objectForKey:VLBLocalityName];
    if([[NSNull null] isEqual:localityName]){
        localityName = @"[in thebox]";
    }
    

    self.storeLabel.text = [NSString stringWithFormat:@"%@ \n %@", name, localityName];
    self.whenLabel.text = [item vlb_objectForKey:VLBItemWhen];
    
    __weak VLBUserItemView *wself = self;
    self.didTapOnGetDirectionsButton = ^(CLLocationCoordinate2D destination, NSDictionary *options){
        VLBAlertViewDelegate *alertViewDelegateOnOkGetDirections = [VLBAlertViews newAlertViewDelegateOnOk:^(UIAlertView *alertView, NSInteger buttonIndex) {
            [TestFlight passCheckpoint:[NSString stringWithFormat:@"%@, %@", [wself class], @"didTapOnGetDirectionsButton"]];
            
            wself.didTapOnGetDirectionsButton(CLLocationCoordinate2DMake([[location objectForKey:@"lat"] floatValue],
                                                                         [[location objectForKey:@"lng"] floatValue]),
                                              location);
        }];
        
        VLBAlertViewDelegate *alertViewDelegateOnCancelDismiss = [VLBAlertViews newAlertViewDelegateOnCancelDismiss];
        
        NSObject<UIAlertViewDelegate> *didTapOnGetDirectionsDelegate =
        [VLBAlertViews all:@[alertViewDelegateOnOkGetDirections, alertViewDelegateOnCancelDismiss]];
        
        UIAlertView *alertView = [VLBAlertViews newAlertViewWithOkAndCancel:@"Get Directions" message:[NSString stringWithFormat:@"Exit the app and get directions%@", [@"" isEqual:name]? @"." : [NSString stringWithFormat:@" to %@.", name]]];
        
        alertView.delegate = didTapOnGetDirectionsDelegate;
        
        [alertView show];
    };
}

-(IBAction)didTapOnGetDirectionsButton:(id)sender
{
    self.didTapOnGetDirectionsButton(EmptyLocationCoordinate, nil);
}

-(void)drawRect:(CGRect)rect inView:(UIView *)view
{
    [[VLBDrawRects new] drawContextOfHexagonInRect:rect];
}

@end
