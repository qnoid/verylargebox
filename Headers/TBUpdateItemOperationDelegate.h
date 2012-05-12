/*
 *  Copyright 2010 TheBox
 *  All rights reserved.
 *
 *  This file is part of TheBox
 *
 *  Created by Markos Charatzas (@qnoid) on 12/05/2012.
 *  Contributor(s): .-
 */
#import <Foundation/Foundation.h>

@protocol TBUpdateItemOperationDelegate <NSObject>

-(void)didSucceedWithItem:(NSDictionary*)item;
-(void)didFailOnUpdateItemWithError:(NSError*)error;

@end
