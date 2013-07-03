/*
 *  Copyright 2010 The Box
 *  All rights reserved.
 *
 *  This file is part of TheBox
 *
 *  Created by Markos Charatzas on 05/04/2012.

 */
#import <Foundation/Foundation.h>
#import "AmazonServiceRequest.h"
#import "VLBNSErrorDelegate.h"

@protocol VLBCreateItemOperationDelegate <NSObject, AmazonServiceRequestDelegate, VLBNSErrorDelegate>

-(void)didStartUploadingItem:(UIImage*)itemImage key:(NSString*)key location:(NSDictionary*) location locality:(NSString*) locality;
-(void)bytesWritten:(NSInteger)bytesWritten totalBytesWritten:(long long)totalBytesWritten totalBytesExpectedToWrite:(long long)totalBytesExpectedToWrite;
-(void)didSucceedWithItem:(NSDictionary*)item;
-(void)didFailOnItemWithError:(NSError*)error;

@end
