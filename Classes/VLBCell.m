//
//  Copyright 2010 The Box
//  All rights reserved.
//
//  This file is part of TheBox
//
//  Created by Markos Charatzas on 8/11/10.
//
//

#import "VLBCell.h"

@implementation VLBCell

+(VLBCell *)loadWithOwner:(id)owner
{
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"VLBCell" owner:owner options:nil];
    
return (VLBCell *)[views objectAtIndex:0];
}

@synthesize itemImageView;
@synthesize itemLabel;

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
