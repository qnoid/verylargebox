/*
 *  Copyright (c) 2010 (verylargebox.com). All rights reserved.
 *  All rights reserved.
 *
 *  This file is part of TheBox
 *
 *  Created by Markos Charatzas on 16/04/2011.

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
