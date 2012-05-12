/*
 *  Copyright 2010 TheBox
 *  All rights reserved.
 *
 *  This file is part of TheBox
 *
 *  Created by Markos Charatzas (@qnoid) on 10/04/2012.
 *  Contributor(s): .-
 */
#import "DetailsUIViewController.h"
#import "TheBoxLocationService.h"
#import "TheBoxNotifications.h"
#import "LocationUIViewController.h"
#import "TheBoxQueries.h"
#import "AFHTTPRequestOperation.h"

@interface DetailsUIViewController ()
-(id)initWithBundle:(NSBundle *)nibBundleOrNil onItem:(NSDictionary*)item;
@property(nonatomic) TheBoxLocationService *theBoxLocationService;
@property(nonatomic) CLLocation *location;
@property(nonatomic, strong) NSMutableDictionary* item;
@end

@implementation DetailsUIViewController

@synthesize locationButton;
@synthesize itemImageView;
@synthesize theBoxLocationService;
@synthesize location = _location;
@synthesize item = _item;

+(DetailsUIViewController*)newDetailsViewController:(NSDictionary*)item
{
    DetailsUIViewController* detailsViewController = 
        [[DetailsUIViewController alloc] initWithBundle:[NSBundle mainBundle] onItem:item];
    
return detailsViewController;
}

- (id)initWithBundle:(NSBundle *)nibBundleOrNil onItem:(NSDictionary*)item;
{
    self = [super initWithNibName:@"DetailsUIViewController" bundle:nibBundleOrNil];
    if (self) {
        _item = item;
        self.title = [_item objectForKey:@"name"];
        self.theBoxLocationService = [TheBoxLocationService theBox];  
        self.title = @"Details";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self.theBoxLocationService notifyDidUpdateToLocation:self];
    
    NSString *imageURL = [_item objectForKey:@"iphoneImageURL"];
    
	NSLog(@"%@", imageURL);

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
            NSURL *url = [NSURL URLWithString:imageURL];
            NSData* data = [NSData dataWithContentsOfURL:url];
            
            UIImage* image = [UIImage imageWithData:data];
        
            dispatch_sync(dispatch_get_main_queue(), ^{
            itemImageView.image = image;
            });
    });
    
    NSDictionary* location = [_item objectForKey:@"location"];
    id name = [location objectForKey:@"name"];
    
    if(name == [NSNull null]){
        name = [NSString stringWithFormat:@"%@,%@", [location objectForKey:@"latitude"], [location objectForKey:@"longitude"]];
        
        UIBarButtonItem *actionButton = [[UIBarButtonItem alloc]
                                         initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                                         target:self
                                         action:@selector(enterLocation:)];
        self.navigationItem.rightBarButtonItem = actionButton;
    }
    
    self.locationButton.titleLabel.numberOfLines = 0;
    [self.locationButton setTitle:[NSString stringWithFormat:self.locationButton.titleLabel.text, name] forState:UIControlStateNormal];
    [self.locationButton setTitle:[NSString stringWithFormat:self.locationButton.titleLabel.text, name]  forState:UIControlStateSelected];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)didUpdateToLocation:(NSNotification *)notification;
{
	self.location = [TheBoxNotifications location:notification];
	
}

-(IBAction)didClickOnLocation:(id)sender
{
    [TestFlight passCheckpoint:[NSString stringWithFormat:@"%@, %s", [self class], __PRETTY_FUNCTION__]];
    
    NSString *urlstring=[NSString stringWithFormat:@"http://maps.google.com/?saddr=%f,%f&daddr=%@,%@",self.location.coordinate.latitude,self.location.coordinate.longitude,[[_item objectForKey:@"location"] objectForKey:@"latitude"],[[_item objectForKey:@"location"] objectForKey:@"longitude"]];
    
    NSLog(@"%@", urlstring);

    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:urlstring]];
}

#pragma mark LocationUIViewController
- (void)enterLocation:(id)sender
{
	UIViewController *locationController = [LocationUIViewController newLocationViewController];
	
	NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
	[center addObserver:self selector:@selector(didEnterLocation:) name:@"didEnterLocation" object:locationController];
	
	[self presentModalViewController:locationController animated:YES];	
}

-(void)didEnterLocation:(NSNotification *)aNotification
{
	NSDictionary *userInfo = [aNotification userInfo];
    NSDictionary *location = [userInfo valueForKey:@"location"];
    
    [self.item setObject:location forKey:@"location"];
    
	NSString *locationName = [location objectForKey:@"name"];
	[locationButton setTitle:locationName forState:UIControlStateNormal];
	[locationButton setTitle:locationName forState:UIControlStateSelected];
    
    AFHTTPRequestOperation *updateItem = [TheBoxQueries updateItemQuery:self.item delegate:self];
    
    [updateItem start];
}

-(void)didSucceedWithItem:(NSDictionary *)item
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

-(void)didFailOnUpdateItemWithError:(NSError *)error
{
    NSLog(@"%@", error);
}



@end
