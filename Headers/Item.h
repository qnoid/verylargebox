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

@property(nonatomic, assign) NSUInteger identifier;
@property(nonatomic, copy) NSString *imageURL;
@property(nonatomic, copy) NSString *when;
@property(nonatomic) NSDate *createdAt;

@end
