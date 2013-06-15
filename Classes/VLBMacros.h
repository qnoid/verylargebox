//
//  TBMacros.h
//  thebox
//
//  Created by Markos Charatzas on 21/04/2013.
//  Copyright (c) 2013 TheBox. All rights reserved.
//

#define VLB_LOAD_VIEW() \
NSBundle *mainBundle = [NSBundle mainBundle]; \
NSArray *views = [mainBundle loadNibNamed:NSStringFromClass([self class]) owner:self options:nil]; \
[self addSubview:views[0]];

#define VLB_Integer(value) [NSNumber numberWithInt:value]

#define VLB_INIT_OR_RETURN_NIL() \
self = [super init]; \
if (!self) { \
    return nil; \
}

#define VLB_IF_NOT_SELF_RETURN_NIL() \
if (!self) { \
return nil; \
}

#define VLB_RETURN_IF_NIL(obj) \
if (!obj) { \
return nil; \
}
