//
//  VLBUserItemView.h
//  verylargebox
//
//  Created by Markos Charatzas on 02/02/2013.
//  Copyright (c) 2013 (verylargebox.com). All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import <QuartzCore/QuartzCore.h>
#import <AddressBook/AddressBook.h>
#import "VLBButton.h"
#import "VLBView.h"
#import "VLBLocationService.h"

@interface VLBFeedItemView : UIView
@property(nonatomic, weak) IBOutlet UIButton* storeButton;
@property(nonatomic, weak) IBOutlet UIImageView* itemImageView;
@property(nonatomic, weak) IBOutlet UILabel* whenLabel;
@property(nonatomic, weak) IBOutlet UIButton* askForDirectionsButton;
@property(nonatomic, copy) VLBButtonOnTouch didTapOnGetDirectionsButton;

-(void)viewWillAppear:(NSDictionary*)item;
-(IBAction)didTapOnGetDirectionsButton:(id)sender;

@end
