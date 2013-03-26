/*
 *  Copyright 2010 The Box
 *  All rights reserved.
 *
 *  This file is part of TheBox
 *
 *  Created by Markos Charatzas (@qnoid) on 15/11/10.
 *  Contributor(s): .-
 */
#import "LocationUIViewController.h"
#import "TheBoxLocationService.h"
#import "TheBoxNotifications.h"
#import "TheBoxQueries.h"
#import "AFHTTPRequestOperation.h"

static NSString* const foursquarePoweredByFilename = @"poweredByFoursquare_gray";
static NSString* const foursquarePoweredByType = @"png";

static UIImage* foursquarePoweredBy;

@interface LocationUIViewController ()
-(id)initWithBundle:(NSBundle *)nibBundleOrNil;
@property(nonatomic, strong) TheBoxLocationService *theBoxLocationService;
@property(nonatomic, strong) NSArray* venues;
@end

@implementation LocationUIViewController
{
}

+(LocationUIViewController*)newLocationViewController {
return [[LocationUIViewController alloc] initWithBundle:[NSBundle mainBundle]];
}

+(void)initialize
{
    NSString* path = [[NSBundle mainBundle] pathForResource:foursquarePoweredByFilename ofType:foursquarePoweredByType];
    foursquarePoweredBy = [UIImage imageWithContentsOfFile:path];
}

@synthesize venuesTableView;
@synthesize map;
@synthesize theBoxLocationService;
@synthesize venues;

-(id)initWithBundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:@"LocationUIViewController" bundle:nibBundleOrNil];
    
    if (self) 
    {
        self.venues = [NSArray array];
        self.theBoxLocationService = [TheBoxLocationService theBoxLocationService];
    }
    
return self;
}


-(void) viewDidLoad
{
	[self.theBoxLocationService notifyDidUpdateToLocation:self];
    
    UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    imageView.image = foursquarePoweredBy;
    imageView.frame = CGRectMake(10,10,320,121);
    
    self.venuesTableView.tableFooterView = imageView;
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.theBoxLocationService startMonitoringSignificantLocationChanges];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self.theBoxLocationService stopMonitoringSignificantLocationChanges];
}

- (IBAction)cancel:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

-(void)didUpdateToLocation:(NSNotification *)notification;
{
	CLLocation *location = [TheBoxNotifications location:notification];
	
	CLLocationCoordinate2D centerCoordinate = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude) ;
	MKCoordinateSpan span = MKCoordinateSpanMake(0.009, 0.009);
	MKCoordinateRegion newRegion = MKCoordinateRegionMake(centerCoordinate, span);	

    AFHTTPRequestOperation* operation = [TheBoxQueries newLocationQuery:location.coordinate.latitude longtitude:location.coordinate.longitude delegate:self];
    
    [operation start];
    
	[map setRegion:newRegion];
    map.showsUserLocation = YES;
}

#pragma mark TBLocationOperationDelegate

-(void)didSucceedWithLocations:(NSArray*)locations
{
    NSLog(@"%s: %@", __PRETTY_FUNCTION__, locations);

    self.venues = locations;
    [self.venuesTableView reloadData];
}

-(void)didFailOnLocationWithError:(NSError*)error
{
    NSLog(@"%s: %@", __PRETTY_FUNCTION__, error);
}

#pragma mark UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.venues count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    NSDictionary* location = [self.venues objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [location objectForKey:@"name"];
    cell.detailTextLabel.text = [[location objectForKey:@"location"] objectForKey:@"address"];
    
return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary* location = [self.venues objectAtIndex:indexPath.row];

    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:location forKey:@"location"]; 
    
	NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
	
	[center postNotificationName:@"didEnterLocation" object:self userInfo:userInfo];
    
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    NSString* query = searchBar.text;
    
    CLLocation* userLocation = map.userLocation.location;
    
    AFHTTPRequestOperation* operation = [TheBoxQueries newLocationQuery:userLocation.coordinate.latitude longtitude:userLocation.coordinate.longitude query:query delegate:self];
    
    [operation start];    
}


@end
