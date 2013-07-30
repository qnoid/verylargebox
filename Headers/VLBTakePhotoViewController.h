/*
 *  Copyright 2010 The Box
 *  All rights reserved.
 *
 *  This file is part of TheBox
 *
 *  Created by Markos Charatzas on 9/11/10.

 */
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "VLBNotifications.h"
#import "VLBLocationServiceDelegate.h"
#import "VLBLocalitiesTableViewController.h"
#import "AmazonServiceRequest.h"
#import "VLBButton.h"
#import "VLBViews.h"
#import "VLBStoresViewController.h"
#import "VLBCameraView.h"
#import "VLBView.h"

@class VLBTheBox;
@protocol VLBCreateItemOperationDelegate;

@protocol VLBTakePhotoViewControllerDelegate <NSObject>

- (IBAction)didTouchUpInsideDiscard:(id)sender;

@end
/**
 Displays a video preview of the camera and 2 primary actions.
 1. Take a photo of the item
 2. Select a store for the item

 Will constantly monitor for location changes until no better match can be found, so as to improve the results from 4sq 
 when the user selects a location.
 
 #events
 didUpdateToLocation
    1. will async get the venues from 4sq for the lat/long
 
 didFailReverseGeocodeLocationWithError
    stop monitoring for location updates

 #network connections
    one at a time to 4sq.com to fetch the venues given the lat/long

 
 As soon as the location is update
 */
@interface VLBTakePhotoViewController : UIViewController <VLBLocationServiceDelegate, VLBLocationOperationDelegate, VLBStoresViewControllerDelegate, UINavigationControllerDelegate, UIScrollViewDelegate, UITextFieldDelegate, AmazonServiceRequestDelegate, VLBCameraViewDelegate>
{
}

@property(nonatomic, weak) IBOutlet VLBCameraView *cameraView;
@property(nonatomic, weak) IBOutlet VLBButton *takePhotoButton;
@property(nonatomic, weak) IBOutlet UIButton *locationButton;
@property(nonatomic, weak) IBOutlet UIButton *discardButton;
@property(nonatomic, weak) IBOutlet UIButton *uploadButton;

@property(nonatomic, weak) NSObject<VLBTakePhotoViewControllerDelegate> *delegate;
@property(nonatomic, weak) NSObject<VLBCreateItemOperationDelegate> *createItemDelegate;

/**
 Presents the ImagePicker to allow the user to take a photo
 only if he has a camera.
 
 Allows editting of the image so that he can crop, zoom etc.
 in case he likes to submit a better version.
 
 Also sets the delegate to self.
 */
- (IBAction)takePhoto:(id)sender;

- (IBAction)enterLocation:(id)sender;

- (IBAction)didTouchUpInsideDiscard:(id)sender;

- (IBAction)didTouchUpInsideUploadButton:(id)sender;

+(VLBTakePhotoViewController *)newTakePhotoViewController:(VLBTheBox*)thebox userId:(NSUInteger)userId;

@end
