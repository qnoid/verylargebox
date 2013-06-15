/*
 *  Copyright 2010 The Box
 *  All rights reserved.
 *
 *  This file is part of TheBox
 *
 *  Created by Markos Charatzas (@qnoid) on 12/12/10.
 *  Contributor(s): .-
 */
#import <Foundation/Foundation.h>

@interface VLBBundle : NSObject

+(id)allocMainBundle;

@property(unsafe_unretained, nonatomic) NSBundle *bundle;

-(id)initWithBundle:(NSBundle *) bundle;
-(id)loadView:(NSString *) view;


@end