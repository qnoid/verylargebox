//
//  TBCategoriesOperationDelegate.h
//  TheBox
//
//  Created by Markos Charatzas on 13/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TBCategoriesOperationDelegate <NSObject>

-(void)didSucceedWithCategories:(NSArray*)categories;
-(void)didFailOnCategoriesWithError:(NSError*)error;

@end
