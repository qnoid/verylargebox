//
//  VLBUserItemView.h
//  thebox
//
//  Created by Markos Charatzas on 02/02/2013.
//  Copyright (c) 2013 TheBox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import <AddressBook/AddressBook.h>
#import "VLBButton.h"
#import "VLBView.h"

typedef void(^VLBUserItemViewGetDirections)(CLLocationCoordinate2D destination, NSDictionary *options);

NS_INLINE
VLBUserItemViewGetDirections tbUserItemViewGetDirectionsNoOp(){
return ^(CLLocationCoordinate2D destination, NSDictionary *options){};
}

NS_INLINE
VLBUserItemViewGetDirections tbUserItemViewGetDirectionsWithAppleMaps()
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
VLBUserItemViewGetDirections tbUserItemViewGetDirectionsWithGoogleMaps()
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
VLBUserItemViewGetDirections tbUserItemViewGetDirections()
{
    Class itemClass = [MKMapItem class];
    if ([itemClass respondsToSelector:@selector(openMapsWithItems:launchOptions:)]) {
        return tbUserItemViewGetDirectionsWithAppleMaps();
    }
    
return tbUserItemViewGetDirectionsWithGoogleMaps();
}

@interface VLBUserItemView : UIView <VLBViewDrawRectDelegate>
@property(nonatomic, weak) IBOutlet UIImageView* itemImageView;
@property(nonatomic, weak) IBOutlet UIView* detailView;
@property(nonatomic, weak) IBOutlet UILabel* whenLabel;
@property(nonatomic, weak) IBOutlet UILabel* storeLabel;
@property(nonatomic, copy) VLBUserItemViewGetDirections didTapOnGetDirectionsButton;

-(IBAction)didTapOnGetDirectionsButton:(id)sender;

@end
