/*
 *  Copyright 2010 The Box
 *  All rights reserved.
 *
 *  This file is part of TheBox
 *
 *  Created by Markos Charatzas on 15/11/10.

 */
#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "VLBLocationServiceDelegate.h"
#import "VLBLocationOperationDelegate.h"
@class VLBLocationService;


/**
 Will fire a notification of "didEnterLocation" with a userinfo containing a "location" key with he following dictionary values
 
 
 {
 "id": "4c1b81768b3aa5937d42975f",
 "name": "Clarks Shoes",
 "contact": {},
 "location": {
 "lat": 55.958778,
 "lng": -3.242337,
 "distance": 4290,
 "country": "United Kingdom"
 },
 "categories": [
 {
 "id": "4bf58dd8d48988d107951735",
 "name": "Shoe Store",
 "pluralName": "Shoe Stores",
 "shortName": "Shoes",
 "icon": {
 "prefix": "https://foursquare.com/img/categories/shops/apparel_shoestore_",
 "sizes": [
 32,
 44,
 64,
 88,
 256
 ],
 "name": ".png"
 },
 "primary": true
 }
 ],
 "verified": false,
 "stats": {
 "checkinsCount": 23,
 "usersCount": 13,
 "tipCount": 0
 },
 "specials": {
 "count": 0,
 "items": []
 },
 "hereNow": {
 "count": 0
 }
 }
 
 */
@interface VLBStoresViewController : UIViewController <VLBLocationServiceDelegate, VLBLocationOperationDelegate, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate> {

}
@property(nonatomic, unsafe_unretained) IBOutlet UITableView *venuesTableView;
@property(nonatomic, unsafe_unretained) IBOutlet MKMapView *map;

+(VLBStoresViewController *)newLocationViewController;
- (IBAction)cancel:(id)sender;

@end
