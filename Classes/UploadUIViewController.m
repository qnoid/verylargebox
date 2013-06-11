/*
 *  Copyright 2010 The Box
 *  All rights reserved.
 *
 *  This file is part of TheBox
 *
 *  Created by Markos Charatzas (@qnoid) on 9/11/10.
 *  Contributor(s): .-
 */
#import "UploadUIViewController.h"
#import "TheBoxQueries.h"
#import "AFHTTPRequestOperation.h"
#import "JSONKit.h"
#import "LocationUIViewController.h"
#import "TheBoxLocationService.h"
#import "TBCreateItemOperationDelegate.h"
#import "UIViewController+TBViewController.h"

static CGFloat const IMAGE_WIDTH = 640.0;
static CGFloat const IMAGE_HEIGHT = 480.0;

@interface UploadUIViewController ()
@property(nonatomic, strong) UIImage* itemImage;
@property(nonatomic, strong) NSString* locality;
@property(nonatomic, strong) NSMutableDictionary* location;
@property(nonatomic, strong) TheBoxLocationService *theBoxLocationService;
@property(nonatomic, assign) NSUInteger userId;
-(id)initWithBundle:(NSBundle *)nibBundleOrNil userId:(NSUInteger)userId;
@end

@implementation UploadUIViewController

- (void) dealloc
{
    [self.theBoxLocationService dontNotifyOnUpdateToLocation:self];
    [self.theBoxLocationService dontNotifyDidFailWithError:self];
    [self.theBoxLocationService dontNotifyDidFailReverseGeocodeLocationWithError:self];
}

+(UploadUIViewController*)newUploadUIViewController:(NSUInteger)userId
{
    UploadUIViewController* newUploadUIViewController = [[UploadUIViewController alloc]
                                                         initWithBundle:[NSBundle mainBundle]
                                                         userId:userId];
        
return newUploadUIViewController;
}

-(id)initWithBundle:(NSBundle *)nibBundleOrNil userId:(NSUInteger)userId
{
    self = [super initWithNibName:NSStringFromClass([UploadUIViewController class]) bundle:nibBundleOrNil];
    
    if (!self) {
        return nil;
    }
    
    self.location = [NSMutableDictionary dictionaryWithObject:[NSMutableDictionary dictionary] forKey:@"location"];
    self.theBoxLocationService = [TheBoxLocationService theBoxLocationService];
    self.userId = userId;

return self;
}

-(void) viewDidLoad
{
	[super viewDidLoad];
    [self.theBoxLocationService notifyDidUpdateToLocation:self];
    [self.theBoxLocationService notifyDidFailWithError:self];
    [self.theBoxLocationService notifyDidFindPlacemark:self];
    [self.theBoxLocationService notifyDidFailReverseGeocodeLocationWithError:self];
		
	self.uploadView.contentSize = self.uploadView.frame.size;	
}

-(void)viewWillAppear:(BOOL)animated
{
    if(self.itemImage){
        self.takePhotoButton.titleLabel.hidden = YES;
    }
    
    [self.takePhotoButton setImage:self.itemImage forState:UIControlStateNormal];
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
	CLLocation *location = [TheBoxNotifications location:notification];

	[[_location objectForKey:@"location"] setObject:[NSString stringWithFormat:@"%f",location.coordinate.latitude] forKey:@"lat"];
	[[_location objectForKey:@"location"] setObject:[NSString stringWithFormat:@"%f",location.coordinate.longitude] forKey:@"lng"];
}

-(void)didFailUpdateToLocationWithError:(NSNotification *)notification
{
    DDLogWarn(@"%s %@", __PRETTY_FUNCTION__, notification);
}

-(void)didFindPlacemark:(NSNotification *)notification
{
    [self.theBoxLocationService stopMonitoringSignificantLocationChanges];
    [self.theBoxLocationService dontNotifyOnFindPlacemark:self];
    
    DDLogInfo(@"%s %@", __PRETTY_FUNCTION__, notification);
    self.locality = [TheBoxNotifications place:notification].locality;
}

-(void)didFailReverseGeocodeLocationWithError:(NSNotification *)notification
{
    DDLogWarn(@"%s %@", __PRETTY_FUNCTION__, notification);
    TBLocalitiesTableViewController *localitiesViewController = [TBLocalitiesTableViewController newLocalitiesViewController];
    
    UINavigationController *navigationController =
    [[UINavigationController alloc] initWithRootViewController:localitiesViewController];
    
    navigationController.navigationBar.titleTextAttributes = @{UITextAttributeFont:[UIFont fontWithName:@"Arial" size:14.0]};
    
    [self presentModalViewController:navigationController animated:YES];
}

#pragma mark TBLocalitiesTableViewControllerDelegate

-(void)didSelectLocality:(NSDictionary *)locality
{
    DDLogInfo(@"%s %@", __PRETTY_FUNCTION__, locality);
    self.locality = [locality objectForKey:@"name"];
    [self.navigationController dismissModalViewControllerAnimated:YES];
}

#pragma mark TheBoxKeyboardObserver

- (IBAction)cancel:(id)sender{
	[self dismissModalViewControllerAnimated:YES];
}

- (IBAction)done:(id)sender 
{
    [TestFlight passCheckpoint:[NSString stringWithFormat:@"%@, %s", [self class], __PRETTY_FUNCTION__]];
    
  [TheBoxQueries newPostImage:self.itemImage delegate:self.createItemDelegate];

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
	
	[self presentModalViewController:picker animated:YES];
}

- (IBAction)enterLocation:(id)sender
{
	UIViewController *locationController = [LocationUIViewController newLocationViewController];
	
	NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
	[center addObserver:self selector:@selector(didEnterLocation:) name:@"didEnterLocation" object:locationController];
	
	[self presentModalViewController:locationController animated:YES];	
}

-(void)didEnterLocation:(NSNotification *)aNotification
{
	NSDictionary *userInfo = [aNotification userInfo];
    self.location = [userInfo valueForKey:@"location"];
    
	NSString *locationName = [self.location objectForKey:@"name"];
	[self.locationButton setTitle:locationName forState:UIControlStateNormal];
	[self.locationButton setTitle:locationName forState:UIControlStateSelected];
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
	[self dismissModalViewControllerAnimated:YES];
}

@end
