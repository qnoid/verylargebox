//
//  DetailsUIViewController.m
//  TheBox
//
//  Created by Markos Charatzas on 10/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DetailsUIViewController.h"
#import "TheBoxLocationService.h"
#import "TheBoxNotifications.h"

@interface DetailsUIViewController ()
-(id)initWithBundle:(NSBundle *)nibBundleOrNil onItem:(NSDictionary*)item;
@property(nonatomic) TheBoxLocationService *theBoxLocationService;
@property(nonatomic) CLLocation *location;
@property(nonatomic, strong) NSDictionary* item;
@end

@implementation DetailsUIViewController

@synthesize locationButton;
@synthesize itemImageView;
@synthesize theBoxLocationService;
@synthesize location;
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
    
    [self.locationButton setTitle:[[_item objectForKey:@"location"] objectForKey:@"name"]  forState:UIControlStateNormal];
    [self.locationButton setTitle:[[_item objectForKey:@"location"] objectForKey:@"name"]  forState:UIControlStateSelected];
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
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    NSString *urlstring=[NSString stringWithFormat:@"http://maps.google.com/?saddr=%f,%f&daddr=%@,%@",location.coordinate.latitude,location.coordinate.longitude,[[_item objectForKey:@"location"] objectForKey:@"latitude"],[[_item objectForKey:@"location"] objectForKey:@"longitude"]];
    
    NSLog(@"%@", urlstring);

    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:urlstring]];
}


@end
