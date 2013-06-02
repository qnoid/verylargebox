//
//  TBErrorBlocks.h
//  thebox
//
//  Created by Markos Charatzas on 02/06/2013.
//  Copyright (c) 2013 TheBox. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TBAFHTTPRequestOperationCompletionBlocks.h"

@interface TBErrorBlocks : NSObject

+(TBAFHTTPRequestOperationErrorBlock) localizedDescriptionOfErrorBlock:(UIView*) view;
@end
