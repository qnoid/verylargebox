//
//  CLLocation+VLBLocation.m
//  verylargebox
//
//  Created by Markos Charatzas on 07/08/2013.
//  Copyright (c) 2013 verylargebox.com. All rights reserved.
//

#import "CLLocation+VLBLocation.h"

@implementation CLLocation (VLBLocation)

-(BOOL)vlb_isMoreAccurateThan:(CLLocation*)location{
    if(location == nil){
        return YES;
    }
    
    return self.horizontalAccuracy < location.horizontalAccuracy || self.verticalAccuracy < location.verticalAccuracy;
}

@end
