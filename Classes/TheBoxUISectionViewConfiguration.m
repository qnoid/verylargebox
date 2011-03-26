/*
 *  Copyright 2010 TheBox
 *  All rights reserved.
 *
 *  This file is part of TheBox
 *
 *  Created by Markos Charatzas <[firstname.lastname@gmail.com]> on 13/03/2011.
 *  Contributor(s): .-
 */
#import "TheBoxUISectionViewConfiguration.h"
#import "TheBoxUISectionView.h"

@implementation TheBoxUISectionViewConfiguration

@synthesize columnFrameWidth;

-(id)initWithColumnFrameWidth:(int) theColumnFrameWidth
{
	self = [super init];
	
	if (self) {
		self.columnFrameWidth = theColumnFrameWidth;
	}
	
return self;
}

-(void) configure:(UIScrollView *)view
{
	TheBoxUISectionView *sectionView = (TheBoxUISectionView *)view;
	
	sectionView.showsHorizontalScrollIndicator = YES;
	sectionView.bounces = NO;
	sectionView.clipsToBounds = YES;
	sectionView.numberOfColumnsPerSectionView = view.frame.size.width / columnFrameWidth;
		
	NSUInteger numberOfColumnsRequired = [sectionView numberOfColumns];
	NSLog(@"numberOfColumnsRequired: %d numberOfColumnsPerSectionView: %d", 
		  numberOfColumnsRequired, 
		  sectionView.numberOfColumnsPerSectionView );
	
	CGSize contentSize = CGSizeMake(
									((float)numberOfColumnsRequired / 
									(float)sectionView.numberOfColumnsPerSectionView) * sectionView.frame.size.width, 
									sectionView.frame.size.height);
	view.contentSize = contentSize;
	
	NSLog(@"thus content size: %@", NSStringFromCGSize(view.contentSize) );	
}

@end
