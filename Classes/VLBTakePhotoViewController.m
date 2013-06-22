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

static CGFloat const IMAGE_WIDTH = 640.0;
static CGFloat const IMAGE_HEIGHT = 480.0;

@interface VLBTakePhotoViewController ()
@property(nonatomic, strong) VLBTheBox* thebox;

@property(nonatomic, strong) UIImage* itemImage;
@property(nonatomic, strong) NSString* locality;
@property(nonatomic, strong) NSDictionary* location;
@property(nonatomic, strong) VLBLocationService *theBoxLocationService;
@property(nonatomic, assign) NSUInteger userId;
@property(nonatomic, assign) BOOL hasAskedForLocality;
@end

@implementation VLBTakePhotoViewController

- (void) dealloc
{
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
    
    UILabel* titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"Take photo of an item";
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.backgroundColor = [UIColor clearColor];
		titleLabel.font = [VLBTypography fontAvenirNextDemiBoldSixteen];
    titleLabel.adjustsFontSizeToFitWidth = YES;    
    newUploadUIViewController.navigationItem.titleView = titleLabel;
    [titleLabel sizeToFit];

    UIButton* closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeButton setFrame:CGRectMake(0, 0, 30, 30)];
    [closeButton setImage:[UIImage imageNamed:@"circlex.png"] forState:UIControlStateNormal];
    [closeButton addTarget:newUploadUIViewController action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];

    newUploadUIViewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:closeButton];

    UIButton* doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [doneButton setFrame:CGRectMake(0, 0, 30, 30)];
    [doneButton setImage:[UIImage imageNamed:@"checkmark-mini.png"] forState:UIControlStateNormal];
    [doneButton addTarget:newUploadUIViewController action:@selector(done:) forControlEvents:UIControlEventTouchUpInside];

    newUploadUIViewController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:doneButton];
    newUploadUIViewController.navigationItem.rightBarButtonItem.enabled = NO;

return newUploadUIViewController;
}

-(id)initWithBundle:(NSBundle *)nibBundleOrNil thebox:(VLBTheBox*)thebox userId:(NSUInteger)userId
{
    self = [super initWithNibName:NSStringFromClass([VLBTakePhotoViewController class]) bundle:nibBundleOrNil];
    
    if (!self) {
        return nil;
    }
    
    self.location = @{@"name":@"", @"location": [@{@"name": @""} mutableCopy]};
    self.theBoxLocationService = [VLBLocationService theBoxLocationService];
    self.thebox = thebox;
    self.userId = userId;
    self.hasAskedForLocality = NO;

return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationItem.rightBarButtonItem.enabled = self.itemImage && self.locality;
    
    if(self.itemImage){
        self.itemImageView.image = self.itemImage;
    }
    
    [self.theBoxLocationService notifyDidUpdateToLocation:self];
    [self.theBoxLocationService notifyDidFindPlacemark:self];
    [self.theBoxLocationService notifyDidFailWithError:self];
    [self.theBoxLocationService notifyDidFailReverseGeocodeLocationWithError:self];
}

-(void)viewDidAppear:(BOOL)animated
{
    [self.theBoxLocationService startMonitoringSignificantLocationChanges];
}

-(void)viewWillDisappear:(BOOL)animated
{
}

#pragma mark TheBoxLocationServiceDelegate

-(void)didUpdateToLocation:(NSNotification *)notification;
{
    [self.theBoxLocationService dontNotifyOnUpdateToLocation:self];
    if(self.location){
        return;
    }

	CLLocation *location = [VLBNotifications location:notification];

	[[self.location objectForKey:@"location"] setObject:[NSString stringWithFormat:@"%f",location.coordinate.latitude] forKey:@"lat"];
	[[self.location objectForKey:@"location"] setObject:[NSString stringWithFormat:@"%f",location.coordinate.longitude] forKey:@"lng"];
}

-(void)didFailUpdateToLocationWithError:(NSNotification *)notification
{
    DDLogWarn(@"%s %@", __PRETTY_FUNCTION__, notification);
    [self.theBoxLocationService dontNotifyDidFailWithError:self];
    [self.theBoxLocationService stopMonitoringSignificantLocationChanges];

    if(self.hasAskedForLocality || self.locality != nil){
        return;
    }
    
    VLBLocalitiesTableViewController *localitiesViewController = [VLBLocalitiesTableViewController newLocalitiesViewController];
    
    localitiesViewController.delegate = self;
    
    UINavigationController *navigationController =
    [[UINavigationController alloc] initWithRootViewController:localitiesViewController];
    
    __weak VLBTakePhotoViewController *wself = self;
    [self presentViewController:navigationController animated:YES completion:^{
        wself.hasAskedForLocality = YES;
    }];
}

-(void)didFindPlacemark:(NSNotification *)notification
{
    [self.theBoxLocationService dontNotifyOnFindPlacemark:self];
    [self.theBoxLocationService stopMonitoringSignificantLocationChanges];
    
    if(self.locality){
        return;
    }
    
    DDLogInfo(@"%s %@", __PRETTY_FUNCTION__, notification);
    self.locality = [VLBNotifications place:notification].locality;
    self.storeLabel.text = self.locality;

    self.navigationItem.rightBarButtonItem.enabled = self.itemImage && self.locality;
}

-(void)didFailReverseGeocodeLocationWithError:(NSNotification *)notification
{
    DDLogWarn(@"%s %@", __PRETTY_FUNCTION__, notification);
    [self.theBoxLocationService dontNotifyDidFailReverseGeocodeLocationWithError:self];
    [self.theBoxLocationService stopMonitoringSignificantLocationChanges];

    if(self.hasAskedForLocality || self.locality != nil){
        return;
    }

    VLBLocalitiesTableViewController *localitiesViewController = [VLBLocalitiesTableViewController newLocalitiesViewController];
    
    localitiesViewController.delegate = self;
    
    UINavigationController *navigationController =
    [[UINavigationController alloc] initWithRootViewController:localitiesViewController];
    
    __weak VLBTakePhotoViewController *wself = self;
    [self presentViewController:navigationController animated:YES completion:^{
        wself.hasAskedForLocality = YES;
    }];
}

#pragma mark TBLocalitiesTableViewControllerDelegate

-(void)didSelectLocality:(NSDictionary *)locality
{
    [self.theBoxLocationService dontNotifyDidFailWithError:self];
    [self.theBoxLocationService dontNotifyOnFindPlacemark:self];
    [self.theBoxLocationService stopMonitoringSignificantLocationChanges];

    DDLogInfo(@"%s %@", __PRETTY_FUNCTION__, locality);
    self.locality = [locality objectForKey:@"name"];
    
    NSDictionary *location = [self.location vlb_objectForKey:@"location"];
    
    self.storeLabel.text = [NSString stringWithFormat:@"%@ \n %@", [location objectForKey:VLBLocationName], self.locality];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark TheBoxKeyboardObserver

- (IBAction)cancel:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)done:(id)sender 
{
    [TestFlight passCheckpoint:[NSString stringWithFormat:@"%@, %s", [self class], __PRETTY_FUNCTION__]];
    
    [self.thebox newPostImage:self.itemImage delegate:self.createItemDelegate];

	[self dismissViewControllerAnimated:YES completion:^{
        [self.createItemDelegate didStartUploadingItem:self.location locality:self.locality];
    }];
}

- (IBAction)takePhoto:(id)sender 
{
	UIImagePickerController *picker = [[UIImagePickerController alloc] init];
	picker.delegate = self;
	picker.allowsEditing = YES;
#if !TARGET_IPHONE_SIMULATOR
	picker.sourceType =  UIImagePickerControllerSourceTypeCamera;
    picker.showsCameraControls = YES;    
#endif
	
	[self presentViewController:picker animated:YES completion:nil];
}

- (IBAction)enterLocation:(id)sender
{
	VLBStoresViewController *locationController = [VLBStoresViewController newLocationViewController];
    locationController.delegate = self;

	[self presentViewController:[[UINavigationController alloc] initWithRootViewController:locationController] animated:YES completion:nil];
}

-(void)didSelectStore:(NSMutableDictionary *)store
{
    DDLogInfo(@"%s, %@", __PRETTY_FUNCTION__, store);
    [self.theBoxLocationService dontNotifyOnFindPlacemark:self];
    
    self.location = store;
    self.locality = [[self.location objectForKey:@"location"] vlb_objectForKey:@"city" ifNil:self.locality];

	NSString *locationName = [self.location vlb_objectForKey:@"name"];
    
    self.storeLabel.text = [NSString stringWithFormat:@"%@ \n %@", locationName, self.locality];
}

//http://stackoverflow.com/questions/1703100/resize-uiimage-with-aspect-ratio
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    CGSize newSize = CGSizeMake(IMAGE_WIDTH, IMAGE_HEIGHT);

    UIGraphicsBeginImageContext(newSize);
    
    [image drawInRect:CGRectMake(0.0f, 0.0f, newSize.width, newSize.height)];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    self.itemImage = newImage;
    
	[self dismissModalViewControllerAnimated:YES];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
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
