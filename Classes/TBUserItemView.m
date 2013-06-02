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

static const CLLocationDegrees EmptyLocation = -1000.0;
static const CLLocationCoordinate2D EmptyLocationCoordinate = {-1000.0, -1000.0};

@implementation TBUserItemView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }
    
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([TBUserItemView class])
                                                   owner:self
                                                 options:nil];

    [self addSubview:[views objectAtIndex:0]];
    self.didTapOnGetDirectionsButton = tbUserItemViewGetDirectionsNoOp();
    
return self;
}

-(IBAction)didTapOnGetDirectionsButton:(id)sender
{
    self.didTapOnGetDirectionsButton(EmptyLocationCoordinate, nil);
}

-(void)drawRect:(CGRect)rect inView:(UIView *)view
{
    CGPoint center = CGRectCenter(rect);
    TBPolygon* hexagon = [TBPolygon hexagonAt:center];
    
    tbViewSolidContext([TBColors colorLightGreen], [TBColors colorDarkGreen])(^(CGContextRef context){
        [hexagon rotateAt:0.25 collect:^(int index, CGPoint angle) {
            if(index == 0){
                CGContextMoveToPoint(context, angle.x, angle.y);
            }
            
            CGContextAddLineToPoint(context, angle.x, angle.y);
        }];
    });
}

@end
