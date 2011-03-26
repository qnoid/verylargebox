/*
 *  Copyright 2010 The Box
 *  All rights reserved.
 *
 *  This file is part of TheBox
 *
 *  Created by Markos Charatzas <[firstname.lastname@gmail.com]> on 15/12/10.
 *  Contributor(s): .-
 */


@interface Item : NSObject 
{
	@private
		NSString *imageURL;
		NSString *when;
		NSDate *createdAt;
}

@property(nonatomic, copy) NSString *imageURL;
@property(nonatomic, copy) NSString *when;
@property(nonatomic, retain) NSDate *createdAt;

@end
