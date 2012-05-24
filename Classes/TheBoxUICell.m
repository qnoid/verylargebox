/*
 *  Copyright 2010 The Box
 *  All rights reserved.
 *
 *  This file is part of TheBox
 *
 *  Created by Markos Charatzas (@qnoid) on 8/11/10.
 *  Contributor(s): .-
 */
#import "TheBoxUICell.h"

@implementation TheBoxUICell

+(TheBoxUICell*)loadWithOwner:(id)owner
{
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"TheBoxUICell" owner:owner options:nil];
    
return (TheBoxUICell*)[views objectAtIndex:0];
}

@synthesize itemImageView;
@synthesize itemLabel;
@synthesize cellIdentifier;

-(id)initWith:(UIImageView *)anItemImageView itemLabel:(UILabel *)anItemLabel
{
	self = [super init];
	
	if (self) {
		self.itemImageView = anItemImageView;
		self.itemLabel = anItemLabel;
	}
	
return self;
}


@end
