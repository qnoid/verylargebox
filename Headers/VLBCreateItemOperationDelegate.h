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
#import "AmazonServiceRequest.h"

@protocol VLBCreateItemOperationDelegate <NSObject, AmazonServiceRequestDelegate>

-(void)didStartUploadingItem:(NSMutableDictionary*) location locality:(NSString*) locality;
-(void)bytesWritten:(NSInteger)bytesWritten totalBytesWritten:(long long)totalBytesWritten totalBytesExpectedToWrite:(long long)totalBytesExpectedToWrite;
-(void)didSucceedWithItem:(NSDictionary*)item;
-(void)didFailOnItemWithError:(NSError*)error;

@end
