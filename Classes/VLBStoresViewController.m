//
//  Copyright 2010 The Box
//  All rights reserved.
//
//  This file is part of TheBox
//
//  Created by Markos Charatzas on 15/11/10.
//

#import "VLBStoresViewController.h"
#import "VLBLocationService.h"
#import "VLBNotifications.h"
#import "VLBQueries.h"
#import "AFHTTPRequestOperation.h"
#import "VLBAlertViews.h"
#import "VLBColors.h"
#import "NSDictionary+VLBFoursquareVenue.h"
#import "DDLog.h"
#import "NSArray+VLBDecorator.h"
#import "NSDictionary+VLBVenuesOperationParameters.h"
#import "VLBNotifications.h"
#import "MBProgressHUD.h"
#import "VLBErrorBlocks.h"

static NSString* const foursquarePoweredByFilename = @"poweredByFoursquare_gray";
static NSString* const foursquarePoweredByType = @"png";

static UIImage* foursquarePoweredBy;

@interface VLBStoresViewController ()
@property(nonatomic, strong) VLBLocationService *theBoxLocationService;
@property(nonatomic, strong) NSArray* venues;

@property(nonatomic, weak) MBProgressHUD *hud;
-(id)initWithBundle:(NSBundle *)nibBundleOrNil;
@end

@implementation VLBStoresViewController

+(VLBStoresViewController *)newLocationViewController {
return [[VLBStoresViewController alloc] initWithBundle:[NSBundle mainBundle]];
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


-(void)dealloc
{
    [self.theBoxLocationService dontNotifyOnUpdateToLocation:self];
	[self.theBoxLocationService dontNotifyDidFailWithError:self];
}

-(id)initWithBundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:@"VLBStoresViewController" bundle:nibBundleOrNil];
    
    if (self) 
    {
        self.venues = [NSArray array];
        self.theBoxLocationService = [VLBLocationService theBoxLocationService];
    }
    
return self;
}


-(void) viewDidLoad
{
	[self.theBoxLocationService notifyDidUpdateToLocation:self];
	[self.theBoxLocationService notifyDidFailWithError:self];
    
    UIImageView* imageView = [[UIImageView alloc] initWithImage:foursquarePoweredBy];
    imageView.frame = CGRectMake(0, 0, 320, 121);
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    self.venuesTableView.tableFooterView = imageView;
    
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.labelText = @"Finding your location";    
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

-(void)didFailUpdateToLocationWithError:(NSNotification *)notification
{
    DDLogError(@"%s %@", __PRETTY_FUNCTION__, notification);
    NSError* error = [VLBNotifications error:notification];

    if([kCLErrorDomain isEqual:error.domain]){
        DDLogWarn(@"%@", error);
    return;
    }
    
    __block VLBAlertViewDelegate *alertViewDelegate;
    alertViewDelegate = [VLBAlertViews newAlertViewDelegateOnOk:^(UIAlertView *alertView, NSInteger buttonIndex) {
        [self dismissModalViewControllerAnimated:YES];
        alertViewDelegate = nil;
    }];
    
    UIAlertView *alertView = [VLBAlertViews newAlertViewWithOk:@"Location access denied"
                                                       message:@"Go to \n Settings > \n Privacy > \n Location Services > \n Turn switch to 'ON' under 'thebox' to access your location."];
    alertView.delegate = alertViewDelegate;
    
    [alertView show];    
}

-(void)didUpdateToLocation:(NSNotification *)notification;
{
    [self.hud hide:YES];
    [self.theBoxLocationService stopMonitoringSignificantLocationChanges];
    [self.theBoxLocationService dontNotifyOnUpdateToLocation:self];

	CLLocation *location = [VLBNotifications location:notification];
	
	CLLocationCoordinate2D centerCoordinate = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude) ;
	MKCoordinateSpan span = MKCoordinateSpanMake(0.009, 0.009);
	MKCoordinateRegion newRegion = MKCoordinateRegionMake(centerCoordinate, span);	

    AFHTTPRequestOperation* operation = [VLBQueries newLocationQuery:location.coordinate.latitude longtitude:location.coordinate.longitude delegate:self];
    
    [operation start];
    
	[map setRegion:newRegion];
    map.showsUserLocation = YES;
}

#pragma mark TBLocationOperationDelegate

-(void)didSucceedWithLocations:(NSArray*)locations givenParameters:(NSDictionary *)parameters
{
    DDLogVerbose(@"%s: %@", __PRETTY_FUNCTION__, locations);

    if([locations vlb_isEmpty]){
        UIAlertView *alertView = [VLBAlertViews newAlertViewWithOk:@"No stores found"
                                                           message:[NSString stringWithFormat:@"There were no stores found"]];
        [alertView show];
    return;
    }
    
    self.venues = locations;
    [self.venuesTableView reloadData];
}

-(void)didFailOnLocationWithError:(NSError*)error
{
    [self.hud hide:YES];
    DDLogError(@"%s: %@", __PRETTY_FUNCTION__, error);
}

#pragma mark TBNSErrorDelegate
-(void)didFailWithCannonConnectToHost:(NSError *)error
{
    [VLBErrorBlocks localizedDescriptionOfErrorBlock:self.view](error);
}

-(void)didFailWithNotConnectToInternet:(NSError *)error
{
    [VLBErrorBlocks localizedDescriptionOfErrorBlock:self.view](error);
}

-(void)didFailWithTimeout:(NSError *)error
{
    [VLBErrorBlocks localizedDescriptionOfErrorBlock:self.view](error);
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
        cell.textLabel.textAlignment = UITextAlignmentCenter;
        cell.detailTextLabel.textAlignment = UITextAlignmentCenter;
    }
    
    NSDictionary* location = [self.venues objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [location vlb_name];
    cell.detailTextLabel.text = [[location objectForKey:@"location"] objectForKey:@"address"];
    
return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.detailTextLabel.textColor = [UIColor lightGrayColor];
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
    
    AFHTTPRequestOperation* operation = [VLBQueries newLocationQuery:userLocation.coordinate.latitude longtitude:userLocation.coordinate.longitude query:query delegate:self];
    
    [operation start];    
}


@end
