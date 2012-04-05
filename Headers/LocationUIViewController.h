/*
 *  Copyright 2010 The Box
 *  All rights reserved.
 *
 *  This file is part of TheBox
 *
 *  Created by Markos Charatzas <[firstname.lastname@gmail.com]> on 15/11/10.
 *  Contributor(s): .-
 */
#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "TheBoxLocationServiceDelegate.h"
@class TheBoxLocationService;

@interface LocationUIViewController : UIViewController <TheBoxLocationServiceDelegate, UITextFieldDelegate> {

}
@property(nonatomic, retain) IBOutlet UITextField *locationTextField;
@property(nonatomic, retain) IBOutlet MKMapView *map;
@property(nonatomic, retain) TheBoxLocationService *theBoxLocationService;

- (IBAction)done:(id)sender;

@end
