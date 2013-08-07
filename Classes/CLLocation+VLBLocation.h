//
//  CLLocation+VLBLocation.h
//  verylargebox
//
//  Created by Markos Charatzas on 07/08/2013.
//  Copyright (c) 2013 verylargebox.com. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>

@interface CLLocation (VLBLocation)

-(BOOL)vlb_isMoreAccurateThan:(CLLocation*)location;

@end