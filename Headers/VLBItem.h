/*
 *  Copyright 2010 The Box
 *  All rights reserved.
 *
 *  This file is part of TheBox
 *
 *  Created by Markos Charatzas on 15/12/10.

 */


@interface VLBItem : NSObject

@property(nonatomic, assign) NSUInteger identifier;
@property(nonatomic, copy) NSString *imageURL;
@property(nonatomic, copy) NSString *when;
@property(nonatomic) NSDate *createdAt;

@end
