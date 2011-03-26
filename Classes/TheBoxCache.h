/*
 *  Copyright 2010 TheBox
 *  All rights reserved.
 *
 *  This file is part of TheBox
 *
 *  Created by Markos Charatzas <[firstname.lastname@gmail.com]> on 25/03/2011.
 *  Contributor(s): .-
 */
#import <Foundation/Foundation.h>


@interface TheBoxCache : NSObject 
{
	@private
		NSCache *cache;
}

@property(nonatomic, retain) NSCache *cache;


-(void)setObject:(id)anObject forKey:(id)aKey;
-(id)objectForKey:(id)key;

@end
