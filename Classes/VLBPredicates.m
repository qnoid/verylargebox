//
//  Copyright (c) 2010 (verylargebox.com). All rights reserved.
//  All rights reserved.
//
//  This file is part of TheBox
//
//  Created by Markos Charatzas on 16/04/2011.
//

#import "VLBPredicates.h"

@implementation VLBPredicateOnLocation

-(BOOL)does:(id)thiz match:(id)that
{
	NSNumber *thizCategoryId = [[thiz objectForKey:@"location"] objectForKey:@"id"];
	NSNumber *thatCategoryId = [that objectForKey:@"location_id"];
	
return [thizCategoryId isEqual:thatCategoryId];
}

-(BOOL)is:(id)thiz higherThan:(id)that
{
	NSNumber *thizCategoryId = [thiz objectForKey:@"location_id"];
	NSNumber *thatCategoryId = [[that objectForKey:@"location"] objectForKey:@"id"];
	
return [thizCategoryId intValue] > [thatCategoryId intValue];
}

@end


@implementation VLBPredicates

+(VLBPredicateOnLocation *)newLocationIdPredicate {
return [[VLBPredicateOnLocation alloc] init];
}

-(void)ifNil:(id)obj then:(VLBPredicateBlock)block
{
    if(obj){
        return;
    }
    
    block();
}

@end
