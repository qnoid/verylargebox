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
#import "TBLocationOperationDelegate.h"
@class TheBoxLocationService;

@interface LocationUIViewController : UIViewController <TheBoxLocationServiceDelegate, TBLocationOperationDelegate, UITableViewDataSource, UITableViewDelegate> {

}
@property(nonatomic, unsafe_unretained) IBOutlet UITableView *venuesTableView;
@property(nonatomic, unsafe_unretained) IBOutlet MKMapView *map;

+(LocationUIViewController*)newLocationViewController;
- (IBAction)cancel:(id)sender;

@end
