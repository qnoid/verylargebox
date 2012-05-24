/*
 *  Copyright 2010 The Box
 *  All rights reserved.
 *
 *  This file is part of TheBox
 *
 *  Created by Markos Charatzas (@qnoid) on 15/12/10.
 *  Contributor(s): .-
 */
#import "TheBoxMath.h"


@implementation TheBoxMath

+(int)getRandomNumber:(int)from to:(int)to {
return (int)from + arc4random() % (to-from+1);
}

@end
