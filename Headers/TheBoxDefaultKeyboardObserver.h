/*
 *  Copyright 2012 TheBox 
 *  All rights reserved.
 *
 *  This file is part of TheBox
 *
 *  Created by Markos Charatzas (@qnoid)  on 30/03/2012.
 *  Contributor(s): .-
 */
#import <UIKit/UIKit.h>
#import "TheBoxNotifications.h"

@interface TheBoxDefaultKeyboardObserver : NSObject <TheBoxKeyboardObserver>

@property(nonatomic, assign) id<TheBoxKeyboardObserver> keyboardObserver;

@end
