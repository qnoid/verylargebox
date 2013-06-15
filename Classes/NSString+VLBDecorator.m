/*
 *  Copyright 2010 The Box
 *  All rights reserved.
 *
 *  This file is part of TheBox
 *
 *  Created by Markos Charatzas (@qnoid) on 14/11/10.
 *  Contributor(s): .-
 */
#import "NSString+VLBDecorator.h"


@implementation NSString (VLBDecorator)

-(BOOL)vlb_isEmpty {
return self.length == 0;
}

@end
