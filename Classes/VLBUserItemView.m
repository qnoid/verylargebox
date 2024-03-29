//
//  VLBUserItemView.m
//  verylargebox
//
//  Created by Markos Charatzas on 02/02/2013.
//  Copyright (c) 2013 (verylargebox.com). All rights reserved.
//

#import "VLBUserItemView.h"
#import "VLBDrawRects.h"
#import "VLBMacros.h"
#import "NSDictionary+VLBItem.h"
#import "NSDictionary+VLBLocation.h"
#import "NSDictionary+VLBLocality.h"
#import "UIImageView+AFNetworking.h"
#import "VLBAlertViews.h"
#import "NSDictionary+VLBDictionary.h"
#import "VLBBoxAlertViews.h"
#import "NSObject+VLBObject.h"

typedef void(^VLBUserItemViewInit)(VLBUserItemView *userItemView);

@interface VLBUserItemView ()
@property(nonatomic, strong) UIImage* placeholderImage;
@end

VLBUserItemViewInit const VLBUserItemViewInitBlock = ^(VLBUserItemView *userItemView){
  
    userItemView.placeholderImage = [UIImage imageNamed:@"placeholder.png"];
    userItemView.didTapOnGetDirectionsButton = VLBButtonOnTouchNone;
    userItemView.storeButton.titleLabel.minimumScaleFactor = 10;
    userItemView.storeButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    userItemView.storeButton.titleLabel.numberOfLines = 0;
    [userItemView.askForDirectionsButton setTitle:NSLocalizedString(@"buttons.getDirections.title", @"Get directions") forState:UIControlStateNormal];
    [userItemView.askForDirectionsButton vlb_cornerRadius:4.0];
};

@implementation VLBUserItemView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];

    VLB_IF_NOT_SELF_RETURN_NIL()
    VLB_LOAD_VIEW()
    
    VLBUserItemViewInitBlock(self);
    
return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    VLB_IF_NOT_SELF_RETURN_NIL()
    VLB_LOAD_VIEW()
    
    VLBUserItemViewInitBlock(self);

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
    id locality = [item vlb_locality];
    NSString* localityName = ([NSObject vlb_isNil:locality])?@"[in the box]":[locality vlb_objectForKey:VLBLocalityName ifNil:@"[in the box]"];

    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:
                                        [NSString stringWithFormat:@"%@\n%@", name, localityName]];
    
    
    [title addAttributes:@{NSForegroundColorAttributeName:[VLBColors colorLightGrey]} range:NSMakeRange(name.length, localityName.length + 1)];

    [self.storeButton setAttributedTitle:title forState:UIControlStateNormal];
    [self.storeButton.titleLabel sizeToFit];
    
    [self.whenButton setTitle:[item vlb_when] forState:UIControlStateNormal];
    
    self.didTapOnGetDirectionsButton = ^(UIButton* button){
        VLBAlertViewBlock onOkGetDirections = ^(UIAlertView *alertView, NSInteger buttonIndex) {
            [Flurry logEvent:@"didGetDirections" withParameters:@{@"controller": @"VLBUserItemView",
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
