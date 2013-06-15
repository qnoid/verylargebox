//
// Copyright 2012 TheBox 
// All rights reserved.
//
// This file is part of thebox
//
// Created by Markos Charatzas on 24/04/2012.
//
//

#import <Foundation/Foundation.h>

@interface NSCache (VLBCache)

-(id)vlb_objectForKey:(id)aKey ifNilReturn:(id)defaultObject;

@end
