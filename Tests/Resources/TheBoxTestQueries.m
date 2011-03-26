/*
 *  Copyright 2010 TheBox
 *  All rights reserved.
 *
 *  This file is part of TheBox
 *
 *  Created by Markos Charatzas <[firstname.lastname@gmail.com]> on 25/03/2011.
 *  Contributor(s): .-
 */
#import "TheBoxTestQueries.h"

@implementation ItemsQuery

/*
 * calls TheBoxDelegate#query:ok: with @"items"
 */
-(void)make:(id<TheBoxDelegate>)delegate;
{
	[delegate query:self ok:@"items"];
}

-(NSString *) description{
return @"items";
}

@end

@implementation QueryCounter

@synthesize counter;

-(void)make:(id<TheBoxDelegate>)delegate {
	counter++;
	[delegate query:self ok:@""];
}

-(NSUInteger) hash{
return 1;
}

-(BOOL) isEqual:(id)that
{
	if (self == that) {
		return YES;
	}
	
	if (![that isKindOfClass:[QueryCounter class]]) {
		return NO;
	}
		  
return YES;
}

@end

@implementation TheBoxTestQueries

+(QueryCounter*)newQueryCounter{
return [[QueryCounter alloc] init];
}

+(ItemsQuery*)newItemsQuery{
return [[ItemsQuery alloc] init];	
}
@end
