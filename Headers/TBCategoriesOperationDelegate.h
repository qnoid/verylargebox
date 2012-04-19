/*
 *  Copyright 2012 TheBox 
 *  All rights reserved.
 *
 *  This file is part of TheBox
 *
 *  Created by Markos Charatzas (@qnoid)  on 13/04/2012.
 *  Contributor(s): .-
 */
#import <Foundation/Foundation.h>

@protocol TBCategoriesOperationDelegate <NSObject>

-(void)didSucceedWithCategories:(NSArray*)categories;
-(void)didFailOnCategoriesWithError:(NSError*)error;

@end
