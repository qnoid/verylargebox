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

/*
 *
 */
@protocol TheBoxPredicate <NSObject>

-(BOOL)applies:(id)object;

/*
 * @return true
 */
-(BOOL)isHigherThan:(id)object;

@end

@interface TheBoxBinarySearch : NSObject 
{
}

-(id)find:(id<TheBoxPredicate>)what on:(NSArray *)values;

@end
