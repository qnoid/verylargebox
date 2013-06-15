/*
 *  Copyright (c) 2010 (verylargebox.com). All rights reserved.
 *  All rights reserved.
 *
 *  This file is part of TheBox
 *
 *  Created by Markos Charatzas on 16/04/2011.

 */
#import <Foundation/Foundation.h>

/*
 *
 */
@protocol VLBPredicate <NSObject>

-(BOOL)does:(id)thiz match:(id)that;
/*
 * @return true
 */
-(BOOL)is:(id)thiz higherThan:(id)that;

@end

@interface VLBBinarySearch : NSObject

@property(nonatomic) id<VLBPredicate> predicate;

-(id)initWithPredicate:(id<VLBPredicate>) predicate;

-(NSUInteger)find:(id)what on:(NSArray *)values;

@end
