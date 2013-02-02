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

static CGFloat const IMAGE_WIDTH = 640.0;
static CGFloat const IMAGE_HEIGHT = 480.0;

@interface UploadUIViewController ()
@property(nonatomic, strong) UIImage* itemImage;
@property(nonatomic, strong) NSMutableDictionary* location;
@property(nonatomic, strong) TheBoxLocationService *theBoxLocationService;
@property(nonatomic, assign) NSUInteger userId;
-(id)initWithBundle:(NSBundle *)nibBundleOrNil userId:(NSUInteger)userId;
@end

@implementation UploadUIViewController

@synthesize uploadView;
@synthesize takePhotoButton;
@synthesize locationButton;

@synthesize theBox;
@synthesize createItemDelegate;

@synthesize itemImage = _itemImage;
@synthesize location = _location;
@synthesize theBoxLocationService;

- (void) dealloc
{
    [theBoxLocationService dontNotifyOnUpdateToLocation:self];
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
    self.theBoxLocationService = [TheBoxLocationService theBox];
    self.userId = userId;

return self;
}

-(void) viewDidLoad
{
	[super viewDidLoad];
    [self.theBoxLocationService notifyDidUpdateToLocation:self];
		
	uploadView.contentSize = uploadView.frame.size;
	
	CGRect bounds = uploadView.bounds;
	NSLog(@"%@", NSStringFromCGRect(bounds));
	CGSize contentSize = uploadView.contentSize;
	NSLog(@"%@", NSStringFromCGSize(contentSize));		
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.takePhotoButton setImage:self.itemImage forState:UIControlStateNormal];
}

-(void)viewWillDisappear:(BOOL)animated
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

#pragma mark TheBoxLocationServiceDelegate

-(void)didUpdateToLocation:(NSNotification *)notification;
{
	CLLocation *location = [TheBoxNotifications location:notification];

	[[_location objectForKey:@"location"] setObject:[NSString stringWithFormat:@"%f",location.coordinate.latitude] forKey:@"lat"];
	[[_location objectForKey:@"location"] setObject:[NSString stringWithFormat:@"%f",location.coordinate.longitude] forKey:@"lng"];
}


#pragma mark TheBoxKeyboardObserver

- (IBAction)cancel:(id)sender{
	[self dismissModalViewControllerAnimated:YES];
}

- (IBAction)done:(id)sender 
{
    [TestFlight passCheckpoint:[NSString stringWithFormat:@"%@, %s", [self class], __PRETTY_FUNCTION__]];
    
	AFHTTPRequestOperation *itemQuery = [TheBoxQueries newPostItemQuery:self.itemImage location:self.location user:self.userId];

    [itemQuery setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.createItemDelegate didSucceedWithItem:[operation.responseString mutableObjectFromJSONString]];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.createItemDelegate didFailOnItemWithError:error];
    }];
    
	[itemQuery start];
    
	[self dismissModalViewControllerAnimated:YES];    
}

- (IBAction)takePhoto:(id)sender 
{
	UIImagePickerController *picker = [[UIImagePickerController alloc] init];
	picker.delegate = self;
	picker.allowsEditing = YES;
#if !TARGET_IPHONE_SIMULATOR
	picker.sourceType =  UIImagePickerControllerSourceTypeCamera;
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
	[locationButton setTitle:locationName forState:UIControlStateNormal];
	[locationButton setTitle:locationName forState:UIControlStateSelected];
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

	takePhotoButton.titleLabel.hidden = YES;
	
	[self dismissModalViewControllerAnimated:YES];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
	[self dismissModalViewControllerAnimated:YES];
}

@end
