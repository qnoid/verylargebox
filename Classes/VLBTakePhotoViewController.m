//
//  Copyright 2010 The Box
//  All rights reserved.
//
//  This file is part of TheBox
//
//  Created by Markos Charatzas on 9/11/10.
//
//

#import "VLBTakePhotoViewController.h"
#import "VLBQueries.h"
#import "VLBLocationService.h"
#import "VLBCreateItemOperationDelegate.h"
#import "VLBTheBox.h"
#import "NSDictionary+VLBLocation.h"
#import "QNDAnimatedView.h"
#import "NSString+VLBDecorator.h"
#import "VLBErrorBlocks.h"
#import "NSArray+VLBDecorator.h"
#import "CLLocation+VLBLocation.h"

static CGFloat const IMAGE_WIDTH = 640.0;
static CGFloat const IMAGE_HEIGHT = 640.0;


@interface VLBTakePhotoViewController ()
@property(nonatomic, strong) VLBTheBox* thebox;
@property(nonatomic, strong) UIImage* itemImage;
@property(nonatomic, strong) NSArray* venues;
@property(nonatomic, strong) NSString* locality;
@property(nonatomic, strong) NSDictionary* location;
@property(nonatomic, strong) VLBLocationService *theBoxLocationService;
@property(nonatomic, assign) NSUInteger userId;
@property(nonatomic, assign) BOOL hasCoordinates;

@property(nonatomic, strong) CLLocation *lastKnownLocation;
@property(nonatomic, weak) NSObject <VLBLocationOperationDelegate> *locationOperationDelegate;
@end

@implementation VLBTakePhotoViewController

- (void) dealloc
{
    [self.theBoxLocationService stopMonitoringSignificantLocationChanges];    
    [self.theBoxLocationService dontNotifyOnUpdateToLocation:self];
    [self.theBoxLocationService dontNotifyDidFailWithError:self];
    [self.theBoxLocationService dontNotifyDidFailReverseGeocodeLocationWithError:self];
}

+(VLBTakePhotoViewController *)newTakePhotoViewController:(VLBTheBox*)thebox userId:(NSUInteger)userId
{
    VLBTakePhotoViewController* newUploadUIViewController = [[VLBTakePhotoViewController alloc]
                                                         initWithBundle:[NSBundle mainBundle]
                                                              thebox:thebox
                                                              userId:userId];
    
return newUploadUIViewController;
}

-(id)initWithBundle:(NSBundle *)nibBundleOrNil thebox:(VLBTheBox*)thebox userId:(NSUInteger)userId
{
    self = [super initWithNibName:NSStringFromClass([VLBTakePhotoViewController class]) bundle:nibBundleOrNil];
    
    if (!self) {
        return nil;
    }
    
    self.theBoxLocationService = [VLBLocationService theBoxLocationService];
    self.thebox = thebox;
    self.userId = userId;
    self.hasCoordinates = NO;
    self.venues = [NSArray array];

return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    __weak VLBTakePhotoViewController *wself = self;
    [self.takePhotoButton onTouchUpInside:^(UIButton *button) {
        [wself takePhoto:button];
    }];

    [self.locationButton setTitle:NSLocalizedString(@"viewcontrollers.assignstore.header.empty", @"Assign a store") forState:UIControlStateNormal];
    [self.locationButton vlb_cornerRadius:4.0];
    self.locationButton.titleLabel.minimumScaleFactor = 10;
    self.locationButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    self.locationButton.titleLabel.numberOfLines = 0;
    [self.locationButton.titleLabel sizeToFit];

    [self.discardButton setTitle:NSLocalizedString(@"buttons.discardButton.close", @"Close") forState:UIControlStateNormal];
    [self.discardButton vlb_cornerRadius:4.0 corners:UIRectCornerBottomLeft | UIRectCornerTopLeft];
    [self.uploadButton setTitle:NSLocalizedString(@"viewcontroller.takePhotoViewController.uploadButton.title", @"Upload") forState:UIControlStateNormal];
    [self.uploadButton.titleLabel sizeToFit];
    [self.uploadButton vlb_cornerRadius:4.0 corners:UIRectCornerBottomRight | UIRectCornerTopRight];

    self.cameraView.writeToCameraRoll = YES;
    self.cameraView.flashView.backgroundColor =
    [UIColor colorWithPatternImage:[UIImage imageNamed:@"hexabump.png"]];
    
    [self.theBoxLocationService notifyDidUpdateToLocation:self];
    [self.theBoxLocationService notifyDidFindPlacemark:self];
    [self.theBoxLocationService notifyDidFailWithError:self];
    [self.theBoxLocationService notifyDidFailReverseGeocodeLocationWithError:self];
}

-(void)viewWillAppear:(BOOL)animated
{
}

-(void)viewDidAppear:(BOOL)animated
{
    [self.theBoxLocationService startMonitoringSignificantLocationChanges];
}

-(void)viewWillDisappear:(BOOL)animated
{
}

-(BOOL)prefersStatusBarHidden{
    return YES;
}

#pragma mark VLBLocationOperationDelegate

-(void)didSucceedWithLocations:(NSArray*)locations givenParameters:(NSDictionary *)parameters
{
    DDLogVerbose(@"%s: %@", __PRETTY_FUNCTION__, locations);
    self.venues = locations;
    [self.locationOperationDelegate didSucceedWithLocations:locations givenParameters:parameters];
}

-(void)didFailOnLocationWithError:(NSError*)error
{
    DDLogError(@"%s: %@", __PRETTY_FUNCTION__, error);
    [self.locationOperationDelegate didFailOnLocationWithError:error];
}

#pragma mark TBNSErrorDelegate
-(void)didFailWithCannonConnectToHost:(NSError *)error
{
    [self.locationOperationDelegate didFailWithCannonConnectToHost:error];    
    [VLBErrorBlocks localizedDescriptionOfErrorBlock:self.view](error);
}

-(void)didFailWithNotConnectToInternet:(NSError *)error
{
    [self.locationOperationDelegate didFailWithNotConnectToInternet:error];
    [VLBErrorBlocks localizedDescriptionOfErrorBlock:self.view](error);
}

-(void)didFailWithTimeout:(NSError *)error
{
    [self.locationOperationDelegate didFailWithTimeout:error];
    [VLBErrorBlocks localizedDescriptionOfErrorBlock:self.view](error);
}


#pragma mark VLBLocationServiceDelegate

-(void)didUpdateToLocation:(NSNotification *)notification;
{
    DDLogInfo(@"%s %@", __PRETTY_FUNCTION__, notification);

    CLLocation *location = [VLBNotifications location:notification];

    if(![location vlb_isMoreAccurateThan:self.lastKnownLocation]){
        
        [self.theBoxLocationService dontNotifyOnUpdateToLocation:self];        
    return;
    }

    self.lastKnownLocation = location;
    self.hasCoordinates = YES;
    
    self.location = @{@"name":@"",
                      @"location": @{
                        @"lat": [NSString stringWithFormat:@"%f",location.coordinate.latitude],
                        @"lng": [NSString stringWithFormat:@"%f",location.coordinate.longitude]}};
    
    AFHTTPRequestOperation* operation =
        [VLBQueries newLocationQuery:location.coordinate.latitude
                          longtitude:location.coordinate.longitude
                            delegate:self];
    
    [operation start];
}

-(void)didFailUpdateToLocationWithError:(NSNotification *)notification
{
    DDLogWarn(@"%s %@", __PRETTY_FUNCTION__, notification);
    [self.theBoxLocationService dontNotifyDidFailWithError:self];
    [self.theBoxLocationService stopMonitoringSignificantLocationChanges];
}

-(void)didFindPlacemark:(NSNotification *)notification
{
    [self.theBoxLocationService dontNotifyOnFindPlacemark:self];
    
    self.hasCoordinates = YES;
    
    if(self.locality){
        return;
    }
    
    DDLogInfo(@"%s %@", __PRETTY_FUNCTION__, notification);
    self.locality = [VLBNotifications place:notification].locality;
    NSString* localizedString = NSLocalizedString(@"viewcontrollers.assignstore.header", @"Assign a Store (%@)");
    
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:localizedString, self.locality]];
    
    [title addAttributes:@{NSForegroundColorAttributeName:[VLBColors colorLightGrey]} range:NSMakeRange(localizedString.length - 5, self.locality.length + 3)];
    [self.locationButton setAttributedTitle:title
                                   forState:UIControlStateNormal];
    [self.locationButton.titleLabel sizeToFit];
    
    if(self.itemImage && self.hasCoordinates){
        self.uploadButton.enabled = YES;
    }
}

-(void)didFailReverseGeocodeLocationWithError:(NSNotification *)notification
{
    DDLogWarn(@"%s %@", __PRETTY_FUNCTION__, notification);
    [self.theBoxLocationService dontNotifyDidFailReverseGeocodeLocationWithError:self];
}

#pragma mark VLBKeyboardObserver

- (IBAction)didTouchUpInsideDiscard:(id)sender
{
    [self.createItemDelegate didCancel];
    [self.delegate didTouchUpInsideDiscard:sender];
}

- (IBAction)didTouchUpInsideUploadButton:(id)sender 
{
    [Flurry logEvent:@"didTakePhoto"];
    
    NSString* key = [self.thebox newPostImage:self.itemImage delegate:self.createItemDelegate];

	[self dismissViewControllerAnimated:YES completion:^{
        [self.createItemDelegate didStartUploadingItem:self.itemImage key:key location:self.location locality:self.locality];
    }];
}

- (IBAction)takePhoto:(id)sender 
{
    [self.cameraView takePicture];
}

- (IBAction)enterLocation:(id)sender
{
    [Flurry logEvent:@"didEnterLocation"];
	VLBStoresViewController *locationController = [VLBStoresViewController newLocationViewController:self.venues];
    self.locationOperationDelegate = locationController;
    locationController.delegate = self;

    UINavigationController* navigationController = [[UINavigationController alloc] initWithRootViewController:locationController];
    navigationController.navigationBar.translucent = YES;
    
	[self presentViewController:navigationController animated:YES completion:nil];
}

-(void)didSelectStore:(NSMutableDictionary *)store
{
    DDLogVerbose(@"%s, %@", __PRETTY_FUNCTION__, store);
    [self.theBoxLocationService dontNotifyOnUpdateToLocation:self];
    [self.theBoxLocationService dontNotifyOnFindPlacemark:self];

    if(self.itemImage && self.hasCoordinates){
        self.uploadButton.enabled = YES;
    }

    self.hasCoordinates = YES;
    self.location = store;
    self.locality = self.locality;

	NSString *locationName = [self.location vlb_objectForKey:VLBLocationName];
    
    [self.locationButton setAttributedTitle:[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@", locationName] attributes:@{NSForegroundColorAttributeName:[VLBColors colorLightGrey]}] forState:UIControlStateNormal];
    [self.locationButton.titleLabel sizeToFit];
}

//http://stackoverflow.com/questions/1703100/resize-uiimage-with-aspect-ratio
- (void)cameraView:(VLBCameraView *)cameraView didFinishTakingPicture:(UIImage *)image withInfo:(NSDictionary *)info meta:(NSDictionary *)meta
{
    [self.takePhotoButton setImage:nil forState:UIControlStateNormal];
    [self.takePhotoButton setBackgroundImage:[UIImage imageNamed:@"takephoto-retake.png"] forState:UIControlStateNormal];
    [self.takePhotoButton setTitle:NSLocalizedString(@"buttons.takePhoto.retake", @"Retake") forState:UIControlStateNormal];
    [self.discardButton setTitle:NSLocalizedString(@"buttons.discardButton.discard", @"Discard") forState:UIControlStateNormal];
    
    __weak VLBTakePhotoViewController *wself = self;
    [self.takePhotoButton onTouchUpInside:^(UIButton *button) {
        [wself.cameraView retakePicture];
    }];
    
    CGSize newSize = CGSizeMake(IMAGE_WIDTH, IMAGE_HEIGHT);

    UIGraphicsBeginImageContext(newSize);
    
    [image drawInRect:CGRectMake(0.0f, 0.0f, newSize.width, newSize.height)];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    self.itemImage = newImage;
    
    if(self.itemImage && self.hasCoordinates){
        self.uploadButton.enabled = YES;
    }
}

-(void)cameraView:(VLBCameraView *)cameraView didErrorOnTakePicture:(NSError *)error
{
}

-(void)cameraView:(VLBCameraView *)cameraView willRekatePicture:(UIImage *)image
{
    [self.discardButton setTitle:NSLocalizedString(@"buttons.discardButton.close", @"Close") forState:UIControlStateNormal];

    __weak VLBTakePhotoViewController *wself = self;
    [self.takePhotoButton onTouchUpInside:^(UIButton *button) {
        [wself takePhoto:button];
    }];

    self.uploadButton.enabled = NO;
    [self.takePhotoButton setTitle:nil forState:UIControlStateNormal];
    [self.takePhotoButton setImage:[UIImage imageNamed:@"takephoto-icon.png"] forState:UIControlStateNormal];
    [self.takePhotoButton setBackgroundImage:[UIImage imageNamed:@"takephoto.png"] forState:UIControlStateNormal];    
}

-(void)cameraView:(VLBCameraView *)cameraView willRriteToCameraRollWithMetadata:(NSDictionary *)metadata
{
    
}

@end
