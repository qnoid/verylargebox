//
//  TBVerifyOperationBlock.m
//  thebox
//
//  Created by Markos Charatzas on 10/02/2013.
//  Copyright (c) 2013 TheBox. All rights reserved.
//

#import "TBVerifyOperationBlock.h"

@implementation TBVerifyOperationBlock

- (id)init
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.didSucceedWithVerificationForEmail = tbEmptyDidSucceedWithVerificationForEmail();
    self.didFailOnVerifyWithError = tbEmptyDidFailOnVerifyWithError();
    
return self;
}

-(void)didSucceedWithVerificationForEmail:(NSString *)email residence:(NSDictionary *)residence {
    self.didSucceedWithVerificationForEmail(email, residence);
}

-(void)didFailOnVerifyWithError:(NSError *)error {
    self.didFailOnVerifyWithError(error);
}

@end
