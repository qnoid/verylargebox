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
#import "TheBoxDelegate.h"

@interface TheBoxDelegateHandler : NSObject <TheBoxDelegate>

@property(nonatomic) id<TheBoxDelegate> delegate;

@end