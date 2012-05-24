//
//  TBUIView.m
//  thebox
//
//  Created by Markos Charatzas on 19/05/2012.
//  Copyright (c) 2012 TheBox. All rights reserved.
//

#import "TBUIView.h"

static NSUInteger const SHADOW_HEIGHT = 11;

@implementation TBUIView

@synthesize title;

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if(!self){
        return nil;
    }
    
    self.title = [[UILabel alloc] initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height - SHADOW_HEIGHT)];
    self.title.backgroundColor = [UIColor colorWithRed:177.0/255.0 green:97.0/255.0 blue:44.0/255.0 alpha:1.0f];
    [self addSubview:title];
    
return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //set shadow
    CGContextSaveGState(context);

    CGFloat alphaShadow = 1.0f;
    CGColorRef topColor = CGColorRetain([[UIColor colorWithRed:128.0/255.0 green:128.0/255.0 blue:128.0/255.0 alpha:alphaShadow] CGColor]);
    CGColorRef secondPassColor = CGColorRetain([[UIColor colorWithRed:229.0/255.0 green:229.0/255.0 blue:229.0/255.0 alpha:alphaShadow] CGColor]);
    CGColorRef whiteColor = CGColorRetain([[UIColor whiteColor] CGColor]);
    
    NSArray *colors = [NSArray arrayWithObjects: (__bridge id)topColor, secondPassColor, whiteColor, nil];
    CGFloat locations[] = {0, 0.50f, 1};
    
    CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient =
    CGGradientCreateWithColors(space,
                               (__bridge CFArrayRef)colors, locations);
    
    
    CGContextDrawLinearGradient(context, 
                                gradient, 
                                CGPointMake(CGPointZero.x, self.frame.size.height - SHADOW_HEIGHT), 
                                CGPointMake(CGPointZero.x, self.frame.size.height), 
                                0);
    CGContextRestoreGState(context);
    
    CGGradientRelease(gradient);
    CGColorSpaceRelease(space);
    CGColorRelease(whiteColor);
    CGColorRelease(secondPassColor);
    CGColorRelease(topColor);
}

@end
