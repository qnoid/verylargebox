//
//  VLBLocalityOperationDelegate.h
//  thebox
//
//  Created by Markos Charatzas on 24/03/2013.
//  Copyright (c) 2013 TheBox. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol VLBLocalityOperationDelegate <NSObject>
-(void)didSucceedWithLocalities:(NSArray*)localities;
-(void)didFailOnLocalitiesWithError:(NSError*)error;
@end
