//
//  VLBVerifyOperationBlock.m
//  verylargebox
//
//  Created by Markos Charatzas on 10/02/2013.
//  Copyright (c) 2013 (verylargebox.com). All rights reserved.
//

#import "VLBVerifyOperationBlock.h"

@implementation VLBVerifyOperationBlock

- (id)init
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.didSucceedWithVerificationForEmail = vlbEmptyDidSucceedWithVerificationForEmail();
    self.didFailOnVerifyWithError = vlbEmptyDidFailOnVerifyWithError();
    self.didFailWithNotConnectToInternet = vlbEmptyDidFailOnVerifyWithError();
    
return self;
}

-(void)didSucceedWithVerificationForEmail:(NSString *)email residence:(NSDictionary *)residence {
    self.didSucceedWithVerificationForEmail(email, residence);
}

-(void)didFailWithNotConnectToInternet:(NSError *)error {
    self.didFailWithNotConnectToInternet(error);
}

-(void)didFailWithTimeout:(NSError *)error{
    self.didFailOnVerifyWithError(error);    
}

-(void)didFailOnVerifyWithError:(NSError *)error {
    self.didFailOnVerifyWithError(error);
}

@end
