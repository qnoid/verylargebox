//
//  TBLocationOperationDelegate.h
//  TheBox
//
//  Created by Markos Charatzas on 10/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TBLocationOperationDelegate <NSObject>

-(void)didSucceedWithLocations:(NSArray*)locations;
-(void)didFailOnLocationWithError:(NSError*)error;

@end
