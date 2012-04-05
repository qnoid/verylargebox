//
//  TBItemsOperationDelegate.h
//  TheBox
//
//  Created by Markos Charatzas on 04/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TBCategoriesOperationDelegate <NSObject>


-(void)didSucceedWithItems:(NSMutableArray*)items;
-(void)didFailOnItemsWithError:(NSError*)error;

@end
