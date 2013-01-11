/*
 *  Copyright 2012 TheBox
 *  All rights reserved.
 *
 *  This file is part of TheBox
 *
 *  Created by Markos Charatzas (@qnoid) on 10/04/2012.
 *  Contributor(s): .-
 */
#import <Foundation/Foundation.h>

@protocol TBLocationOperationDelegate <NSObject>

-(void)didSucceedWithLocations:(NSArray*)locations;
-(void)didFailOnLocationWithError:(NSError*)error;

@end
