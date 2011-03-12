/*
 *  Copyright 2010 TheBox
 *  All rights reserved.
 *
 *  This file is part of TheBox
 *
 *  Created by Markos Charatzas <[firstname.lastname@gmail.com]> on 27/02/2011.
 *  Contributor(s): .-
 */
#import "Items.h"
#import "Item.h"
#import "TheBoxMath.h"

@implementation Items

+(NSArray *)newItemsWithImages:(NSArray *)images
{
	NSMutableArray *items = [[NSMutableArray alloc] initWithCapacity:[images count]];
	
	for (UIImage *image in images) 
	{
		Item *item = [[Item alloc] init];
		item.image = image;
		item.when = [NSString stringWithFormat:@"%d minutes ago", [TheBoxMath getRandomNumber:1 to:60]];
		[items addObject:item];
		[item release];
	}
	
return items;
}


@end
