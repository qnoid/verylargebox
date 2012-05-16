/*
 *  Copyright 2010 TheBox
 *  All rights reserved.
 *
 *  This file is part of TheBox
 *
 *  Created by Markos Charatzas (@qnoid) on 16/04/2011.
 *  Contributor(s): .-
 */
#import <Foundation/Foundation.h>
#import "TheBoxBinarySearch.h"

@interface TheBoxPredicateOnLocation : NSObject <TheBoxPredicate>
{
}
@end


@interface TheBoxPredicates : NSObject {

}

+(TheBoxPredicateOnLocation*)newLocationIdPredicate;

@end
