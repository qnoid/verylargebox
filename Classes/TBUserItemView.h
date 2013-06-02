//
//  TBUserItemView.h
//  thebox
//
//  Created by Markos Charatzas on 02/02/2013.
//  Copyright (c) 2013 TheBox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import <AddressBook/AddressBook.h>
#import "TBButton.h"
#import "TBView.h"

typedef void(^TBUserItemViewGetDirections)(CLLocationCoordinate2D destination, NSDictionary *options);

NS_INLINE
TBUserItemViewGetDirections tbUserItemViewGetDirectionsNoOp(){
return ^(CLLocationCoordinate2D destination, NSDictionary *options){};
}

NS_INLINE
TBUserItemViewGetDirections tbUserItemViewGetDirectionsWithAppleMaps()
{
return ^(CLLocationCoordinate2D destination, NSDictionary *options)
    {
        MKPlacemark* placeMark = [[MKPlacemark alloc] initWithCoordinate:destination addressDictionary:nil];
    
        MKMapItem* mapItem =  [[MKMapItem alloc] initWithPlacemark:placeMark];
    
        id name = [options objectForKey:@"name"];
        if([[NSNull null] isEqual:name]){
            name = @"";
        }

        mapItem.name = name;
        [mapItem openInMapsWithLaunchOptions:@{MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeWalking}];
    };
}
        
NS_INLINE
TBUserItemViewGetDirections tbUserItemViewGetDirectionsWithGoogleMaps()
{
return ^(CLLocationCoordinate2D destination, NSDictionary *options){
        NSString *urlstring =
            [NSString stringWithFormat:@"http://maps.google.com/?dirflg=w&daddr=%f,%f",
             destination.latitude,
             destination.longitude];
        
        NSLog(@"%@", urlstring);
        
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:urlstring]];
    };
}

NS_INLINE
TBUserItemViewGetDirections tbUserItemViewGetDirections()
{
    Class itemClass = [MKMapItem class];
    if ([itemClass respondsToSelector:@selector(openMapsWithItems:launchOptions:)]) {
        return tbUserItemViewGetDirectionsWithAppleMaps();
    }
    
return tbUserItemViewGetDirectionsWithGoogleMaps();
}

@interface TBUserItemView : UIView <TBViewDrawRectDelegate>
@property(nonatomic, weak) IBOutlet UIImageView* itemImageView;
@property(nonatomic, weak) IBOutlet UILabel* whenLabel;
@property(nonatomic, weak) IBOutlet UILabel* storeLabel;
@property(nonatomic, copy) TBUserItemViewGetDirections didTapOnGetDirectionsButton;

-(IBAction)didTapOnGetDirectionsButton:(id)sender;

@end
