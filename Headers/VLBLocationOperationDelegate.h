/*
 *  Copyright 2012 TheBox
 *  All rights reserved.
 *
 *  This file is part of TheBox
 *
 *  Created by Markos Charatzas on 10/04/2012.

 */
#import <Foundation/Foundation.h>
#import "VLBNSErrorDelegate.h"

@protocol VLBLocationOperationDelegate <NSObject, VLBNSErrorDelegate>

-(void)didSucceedWithLocations:(NSArray*)locations givenParameters:(NSDictionary*)parameters;
-(void)didFailOnLocationWithError:(NSError*)error;

@end
