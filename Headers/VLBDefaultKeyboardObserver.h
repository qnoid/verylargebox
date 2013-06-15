/*
 *  Copyright 2012 TheBox 
 *  All rights reserved.
 *
 *  This file is part of TheBox
 *
 *  Created by Markos Charatzas  on 30/03/2012.

 */
#import <UIKit/UIKit.h>
#import "VLBNotifications.h"

@interface VLBDefaultKeyboardObserver : NSObject <VLBKeyboardObserver>

@property(nonatomic, unsafe_unretained) id<VLBKeyboardObserver> keyboardObserver;

@end
