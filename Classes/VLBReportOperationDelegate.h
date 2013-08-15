//
//  VLBReportOperationDelegate.h
//  verylargebox
//
//  Created by Markos Charatzas on 15/08/2013.
//  Copyright (c) 2013 verylargebox.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VLBNSErrorDelegate.h"

@protocol VLBReportOperationDelegate <NSObject, VLBNSErrorDelegate>

-(void)didFailOnReportWithError:(NSError*)error;
-(void)didSucceedOnReport;
@end
