/*
 *  Copyright 2010 TheBox
 *  All rights reserved.
 *
 *  This file is part of TheBox
 *
 *  Created by Markos Charatzas <[firstname.lastname@gmail.com]> on 16/04/2011.
 *  Contributor(s): .-
 */
#import "VLBTestRanking.h"


@implementation VLBTestRanking

-(BOOL)does:(id)thiz match:(id)that{
return [thiz isEqual:that];
}

-(BOOL)is:(id)thiz higherThan:(id)that {    
return [thiz intValue] > [that intValue];
}

@end
