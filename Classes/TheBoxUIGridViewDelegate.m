/*
 *  Copyright 2010 TheBox
 *  All rights reserved.
 *
 *  This file is part of TheBox
 *
 *  Created by Markos Charatzas <[firstname.lastname@gmail.com]> on 21/05/2011.
 *  Contributor(s): .-
 */
#import "TheBoxUIGridViewDelegate.h"
#import "TheBoxSize.h"
#import <QuartzCore/QuartzCore.h>

static const int CELL_FRAME_WIDTH = 160;

@interface TheBoxUIGridViewDelegate()
@property(nonatomic, strong) NSMutableDictionary* frames;
@property(nonatomic, strong) NSMutableDictionary* views;
@end


@implementation TheBoxUIGridViewDelegate


#pragma mark private fields

@synthesize datasource;
@synthesize frames;
@synthesize views;

- (id) init
{
	self = [super init];
	
	if (self) 
	{
		self.frames = [NSMutableDictionary new];
		self.views = [NSMutableDictionary new];        
	}
return self;
}

-(UIView*)viewAtRow:(NSUInteger)row {
return [self.views objectForKey:[NSNumber numberWithInt:row]];
}

-(void)setView:(UIView*)view atIndex:(NSUInteger)index
{
    [self.views setObject:view forKey:[NSNumber numberWithInt:index]];
	[self.frames setObject:[NSNumber numberWithInt:index] forKey:[NSValue valueWithCGRect:[view frame]]];
}

-(CGSize)contentSizeOf:(TheBoxUIScrollView *)scrollView withData:(id<TheBoxUIScrollViewDatasource>)datasource;
{
	NSNumber* index = [self.frames objectForKey:[NSValue valueWithCGRect:[scrollView frame]]];

	NSUInteger numberOfViews = [self.datasource numberOfViews:scrollView atIndex:[index intValue]];
	
	CGFloat width = CELL_FRAME_WIDTH;

return [scrollView.theBoxSize sizeOf:numberOfViews width:width];
}

-(NSUInteger)numberOfViews:(TheBoxUIScrollView *)scrollView
{
	NSNumber* index = [self.frames objectForKey:[NSValue valueWithCGRect:[scrollView frame]]];
	
return [self.datasource numberOfViews:scrollView atIndex:[index intValue]];
}

-(UIView*)viewOf:(TheBoxUIScrollView *)scrollView atIndex:(NSInteger)index
{
	NSNumber* row = [self.frames objectForKey:[NSValue valueWithCGRect:[scrollView frame]]];
	
    UIView* viewOf = [self.datasource viewOf:scrollView atRow:[row intValue] atIndex:index];
    
return viewOf;
}

@end
