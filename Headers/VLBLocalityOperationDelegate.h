//
//  VLBLocalityOperationDelegate.h
//  verylargebox
//
//  Created by Markos Charatzas on 24/03/2013.
//  Copyright (c) 2013 (verylargebox.com). All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VLBNSErrorDelegate.h"

@protocol VLBLocalityOperationDelegate <NSObject, VLBNSErrorDelegate>
-(void)didSucceedWithLocalities:(NSArray*)localities;
-(void)didFailOnLocalitiesWithError:(NSError*)error;
@end
