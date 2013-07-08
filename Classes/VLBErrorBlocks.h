//
//  VLBErrorBlocks.h
//  verylargebox
//
//  Created by Markos Charatzas on 02/06/2013.
//  Copyright (c) 2013 (verylargebox.com). All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VLBAFHTTPRequestOperationCompletionBlocks.h"
#import "VLBHuds.h"

@interface VLBErrorBlocks : NSObject

+(VLBAFHTTPRequestOperationErrorBlock) locationErrorBlock:(UIView*) view config:(VLBProgressHUDBlock)block;
+(VLBAFHTTPRequestOperationErrorBlock) localizedDescriptionOfErrorBlock:(UIView*) view;
@end
