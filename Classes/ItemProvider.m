/*
 *  Copyright 2011 The Box
 *  All rights reserved.
 *
 *  This file is part of TheBox
 *
 *  Created by Markos Charatzas <[firstname.lastname@gmail.com]> on 27/02/11.
 *  Contributor(s): .-
 */
#import "ItemProvider.h"
#import "Item.h"


@implementation ItemProvider

@synthesize items;
@synthesize noOfItems;

- (void) dealloc
{
	[self.items release];
	[super dealloc];
}


-(id) initWith:(NSDictionary *)theItems
{
	self = [super init];
	
	if (self) 
	{
		NSArray *foo = [theItems objectForKey:@"items"];
		self.items = foo;
		self.noOfItems = [foo count];
		counter = 0;
	}
	
return self;
}

-(BOOL) hasNext{
return counter < noOfItems;
}

- (id)nextObject
{
	if(![self hasNext]){
		return nil;
	}
	
	Item *item = [[[Item alloc] init] autorelease];
	
	NSDictionary *bar = [self.items objectAtIndex:counter];
	
	NSURL *imageURL = [NSURL URLWithString:[bar objectForKey:@"image"]];
	
	NSLog(@"url '%@'", imageURL);
	
	NSData *imageData = [NSData dataWithContentsOfURL: imageURL];
	
	UIImage *image = [UIImage imageWithData:imageData];

	item.image = image;
	item.when = [bar objectForKey:@"when"];
	
	counter++;
	
return item;
}

@end
