/*
 *  Copyright 2010 The Box
 *  All rights reserved.
 *
 *  This file is part of TheBox
 *
 *  Created by Markos Charatzas (@qnoid) on 5/11/10.
 *  Contributor(s): .-
 */
#import <UIKit/UIKit.h>
#import "VLBAppDelegate.h"

int main(int argc, char *argv[]) {
    int retVal = -1;
    @autoreleasepool {
        @try {
            retVal = UIApplicationMain(argc, argv, nil, NSStringFromClass([VLBAppDelegate class]));
        }
        @catch (NSException* exception) {
            NSLog(@"Uncaught exception: %@", exception.description);
            NSLog(@"Stack trace: %@", [exception callStackSymbols]);
        }
    }
    return retVal;
}
