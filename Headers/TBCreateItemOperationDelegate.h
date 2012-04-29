/*
 *  Copyright 2010 The Box
 *  All rights reserved.
 *
 *  This file is part of TheBox
 *
 *  Created by Markos Charatzas (@qnoid) on 05/04/2012.
 *  Contributor(s): .-
 */
#import <Foundation/Foundation.h>

@protocol TBCreateItemOperationDelegate <NSObject>

-(void)didSucceedWithItem:(NSDictionary*)item;
-(void)didFailOnItemWithError:(NSError*)error;

@end
