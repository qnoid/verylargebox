/*
 *  Copyright 2010 The Box
 *  All rights reserved.
 *
 *  This file is part of TheBox
 *
 *  Created by Markos Charatzas (@qnoid) on 14/11/10.
 *  Contributor(s): .-
 */
#import <Foundation/Foundation.h>


@interface NSArray (VLBDecorator)

- (BOOL)vlb_isEmpty;
- (BOOL)vlb_isLast:(id)anObject;
- (id)vlb_next:(id)anObject;

@end
