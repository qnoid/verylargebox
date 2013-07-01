//
//  main.m
//  thebox
//
//  Created by Markos Charatzas on 05/11/2010.
//  Copyright (c) 2010 (verylargebox.com). All rights reserved.
//
#import <UIKit/UIKit.h>
#import "VLBAppDelegate.h"

int main(int argc, char *argv[]) {
    int retVal = -1;
    @autoreleasepool {
        retVal = UIApplicationMain(argc, argv, nil, NSStringFromClass([VLBAppDelegate class]));
    }
    return retVal;
}
