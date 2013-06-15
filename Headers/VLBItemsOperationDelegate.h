/*
 *  Copyright 2010 The Box
 *  All rights reserved.
 *
 *  This file is part of TheBox
 *
 *  Created by Markos Charatzas (@qnoid) on 04/04/2012.
 *  Contributor(s): .-
 */
#import <Foundation/Foundation.h>

@protocol VLBItemsOperationDelegate <NSObject>


-(void)didSucceedWithItems:(NSMutableArray*)items;
-(void)didFailOnItemsWithError:(NSError*)error;

@end
