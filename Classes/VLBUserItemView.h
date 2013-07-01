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

typedef void(^VLBUserItemViewGetDirections)();

NS_INLINE
VLBUserItemViewGetDirections tbUserItemViewGetDirectionsNoOp(){
return ^(){};
}

NS_INLINE
VLBUserItemViewGetDirections tbUserItemViewGetDirectionsWithAppleMaps(CLLocationCoordinate2D destination, NSDictionary *options)
{
return ^()
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
VLBUserItemViewGetDirections tbUserItemViewGetDirectionsWithGoogleMaps(CLLocationCoordinate2D destination, NSDictionary *options)
{
return ^(){
        NSString *urlstring =
            [NSString stringWithFormat:@"http://maps.google.com/?dirflg=w&daddr=%f,%f",
             destination.latitude,
             destination.longitude];
                
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:urlstring]];
    };
}

NS_INLINE
VLBUserItemViewGetDirections tbUserItemViewGetDirections(CLLocationCoordinate2D destination, NSDictionary *options)
{
    Class itemClass = [MKMapItem class];
    if ([itemClass respondsToSelector:@selector(openMapsWithItems:launchOptions:)]) {
        return tbUserItemViewGetDirectionsWithAppleMaps(destination, options);
    }
    
return tbUserItemViewGetDirectionsWithGoogleMaps(destination, options);
}

@interface VLBUserItemView : UIView <VLBViewDrawRectDelegate>
@property(nonatomic, weak) IBOutlet UIImageView* itemImageView;
@property(nonatomic, weak) IBOutlet UILabel* whenLabel;
@property(nonatomic, weak) IBOutlet UILabel* storeLabel;
@property(nonatomic, copy) VLBUserItemViewGetDirections didTapOnGetDirectionsButton;

-(void)viewWillAppear:(NSDictionary*)item;
-(IBAction)didTapOnGetDirectionsButton:(id)sender;

@end
