/*
 *  Copyright 2012 TheBox 
 *  All rights reserved.
 *
 *  This file is part of TheBox
 *
 *  Created by Markos Charatzas (@qnoid)  on 25/03/2012.
 *  Contributor(s): .-
 */
#import "TheBox.h"

@class TheBoxResponseParser;

@interface TheBox (Testing)
-(id)initWithCache:(TheBoxCache *)cache responseParser:(TheBoxResponseParser*)responseParser;
@end
