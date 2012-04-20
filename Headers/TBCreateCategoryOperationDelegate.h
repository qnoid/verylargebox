/*
 *  Copyright 2012 TheBox 
 *  All rights reserved.
 *
 *  This file is part of TheBox
 *
 *  Created by Markos Charatzas (@qnoid)  on 17/04/2012.
 *  Contributor(s): .-
 */
#import <Foundation/Foundation.h>

@protocol TBCreateCategoryOperationDelegate <NSObject>

-(void)didSucceedWithCategory:(NSDictionary*)category;
-(void)didFailOnCreateCategoryWithError:(NSError*)error;

@end