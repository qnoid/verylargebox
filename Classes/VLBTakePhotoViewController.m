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
#import "AFHTTPRequestOperation.h"
#import "JSONKit.h"
#import "VLBStoresViewController.h"
#import "VLBLocationService.h"
#import "VLBCreateItemOperationDelegate.h"
#import "UIViewController+VLBViewController.h"
#import "VLBDrawRects.h"
#import "VLBPolygon.h"
#import "VLBTheBox.h"
#import "VLBTypography.h"
#import "NSDictionary+VLBLocation.h"
#import "NSDictionary+VLBDictionary.h"
#import "QNDAnimations.h"
#import "QNDAnimatedView.h"
#import "NSString+VLBDecorator.h"
#import "VLBErrorBlocks.h"
#import "NSArray+VLBDecorator.h"
#import "VLBAlertViews.h"
#import "VLBViewControllers.h"

static CGFloat const IMAGE_WIDTH = 640.0;
static CGFloat const IMAGE_HEIGHT = 640.0;


NS_INLINE
QNDViewAnimation* viewAnimationWillAnimateImageViewAlpha()
{
return [[[[QNDViewAnimationBuilder alloc] initWithViewAnimationBlock:^(UIView *view) {
        UIButton*button = (UIButton*)view;
        button.imageView.alpha = 0.1;
    }] config:^(QNDViewAnimationBuilder *builder) {
        builder.duration = 1.0;
        builder.options = UIViewAnimationOptionCurveEaseInOut |
                            UIViewAnimationOptionRepeat |
                            UIViewAnimationOptionAutoreverse |
                            UIViewAnimationOptionAllowUserInteraction;
    }] newViewAnimation];
}

@interface CLLocation (VLBLocation)

-(BOOL)vlb_isMoreAccurateThan:(CLLocation*)location;

@end

@implementation CLLocation (VLBLocation)

-(BOOL)vlb_isMoreAccurateThan:(CLLocation*)location{
    if(location == nil){
        return YES;
    }
    
return self.horizontalAccuracy < location.horizontalAccuracy || self.verticalAccuracy < location.verticalAccuracy;
}

@end

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

+(VLBTakePhotoViewController *)newUploadUIViewController:(VLBTheBox*)thebox userId:(NSUInteger)userId
{
    VLBTakePhotoViewController* newUploadUIViewController = [[VLBTakePhotoViewController alloc]
                                                         initWithBundle:[NSBundle mainBundle]
                                                              thebox:thebox
                                                              userId:userId];
    
    UILabel* titleLabel = [[VLBViewControllers new] titleView:@"Take photo of an item"];
    newUploadUIViewController.navigationItem.titleView = titleLabel;
    [titleLabel sizeToFit];

    newUploadUIViewController.navigationItem.leftBarButtonItem = [[VLBViewControllers new] discardButton:newUploadUIViewController
			                                                                                            action:@selector(cancel:)];
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
    self.cameraView.allowPictureRetake = YES;
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
    [viewAnimationWillAnimateImageViewAlpha() animate:self.takePhotoButton completion:nil];
    [viewAnimationWillAnimateImageViewAlpha() animate:self.locationButton completion:nil];

    if(self.itemImage){
        self.takePhotoButton.imageView.alpha = 1.0;//test
    }
    
    if(self.location != nil && ![[self.location vlb_objectForKey:@"name"] vlb_isEmpty]){
        self.locationButton.imageView.alpha = 1.0;
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    [self.theBoxLocationService startMonitoringSignificantLocationChanges];
}

-(void)viewWillDisappear:(BOOL)animated
{
}

#pragma mark VLBLocationOperationDelegate

-(void)didSucceedWithLocations:(NSArray*)locations givenParameters:(NSDictionary *)parameters
{
    DDLogVerbose(@"%s: %@", __PRETTY_FUNCTION__, locations);

    if([locations vlb_isEmpty]){
        self.venues = locations;
        [self.locationOperationDelegate didSucceedWithLocations:locations givenParameters:parameters];
    return;
    }
    
    self.venues = locations;
    [self.locationOperationDelegate didSucceedWithLocations:locations givenParameters:parameters];
}

-(void)didFailOnLocationWithError:(NSError*)error
{
    DDLogError(@"%s: %@", __PRETTY_FUNCTION__, error);
    [self.locationOperationDelegate didFailOnLocationWithError:error];
    [VLBErrorBlocks localizedDescriptionOfErrorBlock:self.view](error);
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
    self.storeLabel.text = self.locality;

    if(self.itemImage && self.hasCoordinates){
        self.navigationItem.rightBarButtonItem = [[VLBViewControllers new] checkmarkMiniButton:self action:@selector(done:)];
    }
}

-(void)didFailReverseGeocodeLocationWithError:(NSNotification *)notification
{
    DDLogWarn(@"%s %@", __PRETTY_FUNCTION__, notification);
    [self.theBoxLocationService dontNotifyDidFailReverseGeocodeLocationWithError:self];
}

#pragma mark VLBKeyboardObserver

- (IBAction)cancel:(id)sender {
    [self.createItemDelegate didCancel];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)done:(id)sender 
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

	[self presentViewController:[[UINavigationController alloc] initWithRootViewController:locationController] animated:YES completion:nil];
}

-(void)didSelectStore:(NSMutableDictionary *)store
{
    DDLogVerbose(@"%s, %@", __PRETTY_FUNCTION__, store);
    [self.theBoxLocationService dontNotifyOnUpdateToLocation:self];
    [self.theBoxLocationService dontNotifyOnFindPlacemark:self];

    if(self.itemImage && self.hasCoordinates){
        self.navigationItem.rightBarButtonItem = [[VLBViewControllers new] checkmarkMiniButton:self action:@selector(done:)];
    }

    self.hasCoordinates = YES;
    self.location = store;
    self.locality = self.locality;

	NSString *locationName = [self.location vlb_objectForKey:@"name"];
    
    self.storeLabel.text = [NSString stringWithFormat:@"%@ \n %@", locationName, self.locality];
}

//http://stackoverflow.com/questions/1703100/resize-uiimage-with-aspect-ratio
- (void)cameraView:(VLBCameraView *)cameraView didFinishTakingPicture:(UIImage *)image withInfo:(NSDictionary *)info meta:(NSDictionary *)meta
{
    CGSize newSize = CGSizeMake(IMAGE_WIDTH, IMAGE_HEIGHT);

    UIGraphicsBeginImageContext(newSize);
    
    [image drawInRect:CGRectMake(0.0f, 0.0f, newSize.width, newSize.height)];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    self.itemImage = newImage;
    self.takePhotoButton.userInteractionEnabled = NO;
    
    if(self.itemImage && self.hasCoordinates){
        self.navigationItem.rightBarButtonItem = [[VLBViewControllers new] checkmarkMiniButton:self action:@selector(done:)];
    }
}

-(void)cameraView:(VLBCameraView *)cameraView didErrorOnTakePicture:(NSError *)error
{
}

-(void)cameraView:(VLBCameraView *)cameraView willRekatePicture:(UIImage *)image
{
    self.navigationItem.rightBarButtonItem = nil;
    self.takePhotoButton.userInteractionEnabled = YES;
    [viewAnimationWillAnimateImageViewAlpha() animate:self.takePhotoButton completion:nil];
}

-(void)cameraView:(VLBCameraView *)cameraView willRriteToCameraRollWithMetadata:(NSDictionary *)metadata
{
    
}

-(void)drawRect:(CGRect)rect inView:(UIView *)view
{
    if([view isEqual:self.takePhotoButton]){
        VLBViewContext context = [VLBViews fill:[VLBColors colorPrimaryBlue]];
        context([[VLBDrawRects new] drawContextOfHexagon:[VLBPolygon hexagonAt:CGRectCenter(rect)]]);
    }
    else if([view isEqual:self.locationButton]){
        VLBViewContext context = [VLBViews fill:[VLBColors colorDarkGreen]];
        context([[VLBDrawRects new] drawContextOfHexagon:[VLBPolygon hexagonAt:CGRectCenter(rect)]]);
    }
    
}

@end
