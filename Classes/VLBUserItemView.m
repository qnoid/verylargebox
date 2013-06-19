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

static const CLLocationDegrees EmptyLocation = -1000.0;
static const CLLocationCoordinate2D EmptyLocationCoordinate = {-1000.0, -1000.0};

@implementation VLBUserItemView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];

    VLB_IF_NOT_SELF_RETURN_NIL()
    VLB_LOAD_VIEW()
    
    self.didTapOnGetDirectionsButton = tbUserItemViewGetDirectionsNoOp();

    self.storeLabel.layer.sublayerTransform = CATransform3DMakeTranslation(0, 5, 0);

    [[[self.detailView.vlb_border
            vlb_borderWidth:1.0f]
            vlb_topBorder:[VLBColors colorPrimaryBlue]]
            vlb_bottomBorder:[VLBColors colorPrimaryBlue]];

    
return self;
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
