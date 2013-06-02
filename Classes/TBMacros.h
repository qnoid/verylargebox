//
//  TBMacros.h
//  thebox
//
//  Created by Markos Charatzas on 21/04/2013.
//  Copyright (c) 2013 TheBox. All rights reserved.
//

#define TB_LOAD_VIEW() \
NSBundle *mainBundle = [NSBundle mainBundle]; \
NSArray *views = [mainBundle loadNibNamed:NSStringFromClass([self class]) owner:self options:nil]; \
[self addSubview:views[0]];

#define TBInteger(value) [NSNumber numberWithInt:value]

#define TB_INIT_OR_RETURN_NIL() \
self = [super init]; \
if (!self) { \
    return nil; \
}

#define TB_IF_NOT_SELF_RETURN_NIL() \
if (!self) { \
return nil; \
}

#define TB_RETURN_IF_NIL(obj) \
if (!obj) { \
return nil; \
}
