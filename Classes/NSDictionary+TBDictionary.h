//
//  NSDictionary+TBDictionary.h
//  TheBox
//
//  Created by Markos Charatzas on 04/05/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (TBDictionary)

-(id)tbObjectForKey:(id)aKey ifNil:(id)defaultObj;

@end
