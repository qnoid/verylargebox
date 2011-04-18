/*
 *  Copyright 2010 TheBox
 *  All rights reserved.
 *
 *  This file is part of TheBox
 *
 *  Created by Markos Charatzas <[firstname.lastname@gmail.com]> on 16/04/2011.
 *  Contributor(s): .-
 */
#import <Foundation/Foundation.h>
#import "TheBoxBinarySearch.h"

@interface TheBoxTestEqualsPredicate : NSObject <TheBoxPredicate> 
{
	@private
		id object;
}

@property(nonatomic, assign) id object;

-(id)init:(id)object;

@end