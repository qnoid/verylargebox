//
//  TBUIRibbon.m
//  thebox
//
//  Created by Markos Charatzas on 19/05/2012.
//  Copyright (c) 2012 TheBox. All rights reserved.
//

#import "TBUIRibbon.h"

@implementation TBUIRibbon

@synthesize title;

-(void)layoutSubviews
{
    self.title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 22)];
    self.title.backgroundColor = [UIColor colorWithRed:177.0/255.0 green:97.0/255.0 blue:44.0/255.0 alpha:1.0f];
    self.title.text = @"Blackwell's";
    self.title.textColor = [UIColor whiteColor];
    [self.superview addSubview:title];
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGFloat height = 22.0;    
    CGFloat width = self.bounds.size.width;

    CGColorRef theBoxColor = [[UIColor colorWithRed:177.0/255.0 green:97.0/255.0 blue:44.0/255.0 alpha:1.0f] CGColor];    

    CGContextSetStrokeColorWithColor(context, [[UIColor colorWithRed:128.0/255.0 green:128.0/255.0 blue:128.0/255.0 alpha:1.0f] CGColor]);

    //set title
    CGContextSetFillColorWithColor(context, theBoxColor);
    CGContextFillRect(context, CGRectMake(CGPointZero.x, CGPointZero.y, width, height));

    //set shadow
    CGContextSaveGState(context);

    CGFloat alphaShadow = 1.0f;
    CGColorRef topColor = [[UIColor colorWithRed:128.0/255.0 green:128.0/255.0 blue:128.0/255.0 alpha:alphaShadow] CGColor];
    CGColorRef secondPassColor = [[UIColor colorWithRed:229.0/255.0 green:229.0/255.0 blue:229.0/255.0 alpha:alphaShadow] CGColor];
    CGColorRef whiteColor = [[UIColor whiteColor] CGColor];
    
    NSArray *colors = [NSArray arrayWithObjects: (__bridge id)topColor, secondPassColor, whiteColor, nil];
    CGFloat locations[] = {0, 0.50f, 1};
    
    CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient =
    CGGradientCreateWithColors(space,
                               (__bridge CFArrayRef)colors, locations);

    
    CGContextDrawLinearGradient(context, 
                                gradient, 
                                CGPointMake(CGPointZero.x, 22.0), 
                                CGPointMake(CGPointZero.x, 33.0), 
                                0);
    CGContextRestoreGState(context);

    CGGradientRelease(gradient);
    CGColorSpaceRelease(space);
}


@end
