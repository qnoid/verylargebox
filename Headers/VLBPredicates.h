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
#import "VLBBinarySearch.h"

@interface VLBPredicateOnLocation : NSObject <VLBPredicate>
{
}
@end


@interface VLBPredicates : NSObject {

}

+(VLBPredicateOnLocation *)newLocationIdPredicate;

@end
