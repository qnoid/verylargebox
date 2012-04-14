//
//  TBCreateItemOperationDelegate.h
//  TheBox
//
//  Created by Markos Charatzas on 05/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TBCreateItemOperationDelegate <NSObject>

-(void)didSucceedWithItem:(NSDictionary*)item;
-(void)didFailOnItemWithError:(NSError*)error;

@end
