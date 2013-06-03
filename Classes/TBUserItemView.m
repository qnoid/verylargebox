//
//  TBUserItemView.m
//  thebox
//
//  Created by Markos Charatzas on 02/02/2013.
//  Copyright (c) 2013 TheBox. All rights reserved.
//

#import "TBUserItemView.h"
#import "TBViews.h"
#import "TBPolygon.h"
#import "TBColors.h"
#import "TBDrawRects.h"
#import "TBMacros.h"

static const CLLocationDegrees EmptyLocation = -1000.0;
static const CLLocationCoordinate2D EmptyLocationCoordinate = {-1000.0, -1000.0};

@implementation TBUserItemView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];

    TB_IF_NOT_SELF_RETURN_NIL()
    TB_LOAD_VIEW()
    
    self.didTapOnGetDirectionsButton = tbUserItemViewGetDirectionsNoOp();
    
    [[self.detailView.border
      borderWidth:1.0f]
     borderColor:[UIColor blackColor].CGColor];

    
return self;
}

-(IBAction)didTapOnGetDirectionsButton:(id)sender
{
    self.didTapOnGetDirectionsButton(EmptyLocationCoordinate, nil);
}

-(void)drawRect:(CGRect)rect inView:(UIView *)view
{
    [[TBDrawRects new] drawContextOfHexagonInRect:rect];
}

@end
