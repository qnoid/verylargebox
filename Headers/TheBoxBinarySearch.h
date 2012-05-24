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

/*
 *
 */
@protocol TheBoxPredicate <NSObject>

-(BOOL)does:(id)thiz match:(id)that;
/*
 * @return true
 */
-(BOOL)is:(id)thiz higherThan:(id)that;

@end

@interface TheBoxBinarySearch : NSObject 

@property(nonatomic) id<TheBoxPredicate> predicate;

-(id)initWithPredicate:(id<TheBoxPredicate>) predicate;

-(NSUInteger)find:(id)what on:(NSArray *)values;

@end
