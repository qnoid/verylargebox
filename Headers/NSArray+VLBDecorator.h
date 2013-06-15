/*
 *  Copyright 2010 The Box
 *  All rights reserved.
 *
 *  This file is part of TheBox
 *
 *  Created by Markos Charatzas on 14/11/10.

 */
#import <Foundation/Foundation.h>


@interface NSArray (VLBDecorator)

- (BOOL)vlb_isEmpty;
- (BOOL)vlb_isLast:(id)anObject;
- (id)vlb_next:(id)anObject;

@end
