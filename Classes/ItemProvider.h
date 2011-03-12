/*
 *  Copyright 2011 The Box
 *  All rights reserved.
 *
 *  This file is part of TheBox
 *
 *  Created by Markos Charatzas <[firstname.lastname@gmail.com]> on 27/02/11.
 *  Contributor(s): .-
 */
#import <Foundation/Foundation.h>


@interface ItemProvider : NSEnumerator
{
	@private
		NSArray *items;
		int noOfItems;
		int counter;
}

@property(nonatomic, retain) NSArray *items;
@property(nonatomic, assign) int noOfItems;

-(id) initWith:(NSDictionary *)items;

@end
