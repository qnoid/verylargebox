//
//  Copyright 2012 TheBox 
//  All rights reserved.
//
//  This file is part of TheBox
//
//  Created by Markos Charatzas on 27/04/2012.
//
//

#import <SenTestingKit/SenTestingKit.h>
#import "OCMock.h"
#import "OCMArg.h"
#import "VLBScrollView.h"
#import "VLBScrollViewDatasource.h"
#import "VLBSize.h"
#import "VLBRecycleStrategy.h"
#import "VLBVisibleStrategy.h"

@interface VLBScrollView (Testing)
-(id)initWithFrame:(CGRect) frame size:(NSObject<VLBSize>*)size dimension:(NSObject<VLBDimension>*)dimension;
-(void)setVisibleStrategy:(id<VLBVisibleStrategy>)visibleStrategy;
-(id<VLBVisibleStrategy>)visibleStrategy;
-(void)setRecycleStrategy:(VLBRecycleStrategy *)recycleStrategy;
-(void)setContentView:(UIView*)contentView;
-(void)setTheBoxSize:(VLBSize *)size;
@end

@interface VLBScrollViewTest : SenTestCase {
	
}
@end

@implementation VLBScrollViewTest

-(void)testGivenInitWithFrameAssertContentViewAsSubview
{
    CGRect anyframe = CGRectMake(0, 0, 320, 196);
    VLBScrollView *theBoxScrollView = [[VLBScrollView alloc] initWithFrame:anyframe size:nil dimension:nil];
    
    STAssertTrue(1 == [theBoxScrollView.subviews count], nil);
    UIView* contentView = [theBoxScrollView.subviews objectAtIndex:0];    
    STAssertTrue(CGRectEqualToRect(contentView.frame, CGRectMake(CGPointZero.x, CGPointZero.y, anyframe.size.width, anyframe.size.height)) , nil);
}
@end
