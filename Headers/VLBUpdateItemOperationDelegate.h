/*
 *  Copyright (c) 2010 (verylargebox.com). All rights reserved.
 *  All rights reserved.
 *
 *  This file is part of TheBox
 *
 *  Created by Markos Charatzas on 12/05/2012.

 */
#import <Foundation/Foundation.h>

@protocol VLBUpdateItemOperationDelegate <NSObject>

-(void)didSucceedWithItem:(NSDictionary*)item;
-(void)didFailOnUpdateItemWithError:(NSError*)error;

@end
