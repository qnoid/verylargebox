//
//  VLBErrorBlocks.h
//  verylargebox
//
//  Created by Markos Charatzas on 02/06/2013.
//  Copyright (c) 2013 (verylargebox.com). All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VLBAFHTTPRequestOperationCompletionBlocks.h"

@interface VLBErrorBlocks : NSObject

+(VLBAFHTTPRequestOperationErrorBlock) localizedDescriptionOfErrorBlock:(UIView*) view;
@end
