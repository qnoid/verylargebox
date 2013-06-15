/*
 *  Copyright (c) 2010 (verylargebox.com). All rights reserved.
 *  All rights reserved.
 *
 *  This file is part of TheBox
 *
 *  Created by Markos Charatzas on 25/03/2011.

 */
#import <Foundation/Foundation.h>


@interface VLBCache : NSObject

@property(nonatomic, strong) NSCache *cache;


-(void)setObject:(id)anObject forKey:(id)aKey;
-(id)objectForKey:(id)key;

@end
