//
//  TBMacros.h
//  thebox
//
//  Created by Markos Charatzas on 21/04/2013.
//  Copyright (c) 2013 TheBox. All rights reserved.
//

#define loadView() \
NSBundle *mainBundle = [NSBundle mainBundle]; \
NSArray *views = [mainBundle loadNibNamed:NSStringFromClass([self class]) owner:self options:nil]; \
[self addSubview:views[0]];

#define TBInteger(value) [NSNumber numberWithInt:value]

#define initOrReturnNil() \
self = [super init]; \
if (!self) { \
    return nil; \
}
