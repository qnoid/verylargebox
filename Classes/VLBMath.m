/*
 *  Copyright 2010 The Box
 *  All rights reserved.
 *
 *  This file is part of TheBox
 *
 *  Created by Markos Charatzas (@qnoid) on 15/12/10.
 *  Contributor(s): .-
 */
#import "VLBMath.h"


@implementation VLBMath

+(int)getRandomNumber:(int)from to:(int)to {
return (int)from + arc4random() % (to-from+1);
}

@end
