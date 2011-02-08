/*
 *  Copyright 2010 The Box
 *  All rights reserved.
 *
 *  This file is part of TheBox
 *
 *  Created by Markos Charatzas <[firstname.lastname@gmail.com]> on 15/12/10.
 *  Contributor(s): .-
 */
#import <Foundation/Foundation.h>


@interface Item : NSObject 
{
	@private
		UIImage *image;
		NSString *value;
		NSString *when;
}

@property(nonatomic, retain) UIImage *image;
@property(nonatomic, retain) NSString *value;
@property(nonatomic, retain) NSString *when;

@end
