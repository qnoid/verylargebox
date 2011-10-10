/*
 *  Copyright 2010 The Box
 *  All rights reserved.
 *
 *  This file is part of TheBox
 *
 *  Created by Markos Charatzas <[firstname.lastname@gmail.com]> on 12/12/10.
 *  Contributor(s): .-
 */
#import <Foundation/Foundation.h>

@interface TheBoxBundle : NSObject 
{
	@private
		NSBundle *bundle;
}

+(id)allocMainBundle;

@property(nonatomic, retain) NSBundle *bundle;

-(id)initWithBundle:(NSBundle *) bundle;
-(id)loadView:(NSString *) view;


@end
