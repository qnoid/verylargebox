/**
 *  Copyright 2012 TheBox 
 *  All rights reserved.
 *
 *  This file is part of TheBox
 *
 *  Created by Markos Charatzas (@qnoid)  on 24/04/2012.
 *  Contributor(s): .-
 */
#import <Foundation/Foundation.h>

@interface NSCache (TBCache)

-(id)tbObjectForKey:(id)aKey ifNilReturn:(id)defaultObject;

@end
