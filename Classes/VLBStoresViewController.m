//  VLBStoresViewController.m
//  verylargebox
//
//  Created by Markos Charatzas on 15/11/2010.
//  Copyright (c) 2010 (verylargebox.com). All rights reserved.
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
#import "VLBColors.h"
#import "VLBTypography.h"
#import "QNDAnimations.h"
#import "QNDAnimatedView.h"
#import "NSArray+VLBDecorator.h"
#import "VLBMacros.h"

static NSString* const foursquarePoweredByFilename = @"poweredByFoursquare";
static NSString* const foursquarePoweredByType = @"png";

static UIImage* foursquarePoweredBy;

@interface VLBStoresViewController ()
@property(nonatomic, strong) VLBLocationService *theBoxLocationService;
@property(nonatomic, strong) NSArray* venues;
@property(nonatomic, strong) NSObject<QNDAnimatedView> *animatedMap;
@property(nonatomic, weak) MBProgressHUD *hud;
-(id)initWithBundle:(NSBundle *)nibBundleOrNil venues:(NSArray*)venues;
@end

@implementation VLBStoresViewController

+(VLBStoresViewController *)newLocationViewController:(NSArray*)venues
{

    VLBStoresViewController *storesViewController =
        [[VLBStoresViewController alloc] initWithBundle:[NSBundle mainBundle] venues:venues];

    UILabel* titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"Select a store";
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.backgroundColor = [UIColor clearColor];
		titleLabel.font = [VLBTypography fontAvenirNextDemiBoldSixteen];
    titleLabel.adjustsFontSizeToFitWidth = YES;    
    storesViewController.navigationItem.titleView = titleLabel;
    [titleLabel sizeToFit];

    UIButton* closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeButton setFrame:CGRectMake(0, 0, 30, 30)];
    [closeButton setImage:[UIImage imageNamed:@"down-arrow.png"] forState:UIControlStateNormal];
    [closeButton addTarget:storesViewController action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];

    storesViewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:closeButton];

    [[NSNotificationCenter defaultCenter] addObserver:storesViewController selector:@selector(keyboardWillShow:) name:@"UIKeyboardWillShowNotification" object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:storesViewController selector:@selector(keyboardWillHide:) name:@"UIKeyboardWillHideNotification" object:nil];

return storesViewController;
}

+(void)initialize
{
    NSString* path = [[NSBundle mainBundle] pathForResource:foursquarePoweredByFilename ofType:foursquarePoweredByType];
    foursquarePoweredBy = [UIImage imageWithContentsOfFile:path];
}

-(void)dealloc
{
    [self.theBoxLocationService dontNotifyOnUpdateToLocation:self];
	[self.theBoxLocationService dontNotifyDidFailWithError:self];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"UIKeyboardWillShowNotification"
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"UIKeyboardWillHideNotification"
                                                  object:nil];

}

-(id)initWithBundle:(NSBundle *)nibBundleOrNil venues:(NSArray*)venues
{
    self = [super initWithNibName:@"VLBStoresViewController" bundle:nibBundleOrNil];
    
    VLB_IF_NOT_SELF_RETURN_NIL();
    
    self.venues = venues;
    self.theBoxLocationService = [VLBLocationService theBoxLocationService];
    
return self;
}

-(void)keyboardWillShow:(NSNotification*)notification
{
    UIButton* dismissSearchBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [dismissSearchBarButton setFrame:CGRectMake(0, 0, 30, 30)];
    [dismissSearchBarButton setImage:[UIImage imageNamed:@"circlex.png"] forState:UIControlStateNormal];
    [dismissSearchBarButton addTarget:self action:@selector(dismissSearchBar:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:dismissSearchBarButton];

    NSValue *value = [[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    [self.animatedMap animateWithDuration:0.5 animation:^(UIView *view) {
        view.frame = CGRectMake(0, -view.frame.size.height, view.frame.size.width, view.frame.size.height);
    }];

    [UIView animateWithDuration:0.5 animations:^{
        self.venuesTableView.contentInset = self.venuesTableView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, value.CGRectValue.size.height, 0);        
    }];

}

-(void)keyboardWillHide:(NSNotification*)notification
{
    [self.animatedMap rewind];
    self.venuesTableView.contentInset = self.venuesTableView.scrollIndicatorInsets = UIEdgeInsetsMake(185, 0, 0, 0);
    
    CGRect visibleRect;
    visibleRect.origin = self.venuesTableView.bounds.origin;
    visibleRect.size = CGSizeMake(self.venuesTableView.bounds.size.width,
                                  self.venuesTableView.bounds.size.height - self.venuesTableView.contentInset.top +
                                  self.venuesTableView.bounds.origin.y);
    
    //CGRectMake(0, 0, 320, 392 - 205)
    [self.venuesTableView scrollRectToVisible:visibleRect animated:YES];
    self.navigationItem.rightBarButtonItem = nil;
}

-(void)dismissSearchBar:(id)sender
{
    [self.searchBar resignFirstResponder];
}

-(void) viewDidLoad
{
    UIImageView* imageView = [[UIImageView alloc] initWithImage:foursquarePoweredBy];
    imageView.frame = CGRectMake(0, 0, 320, 121);
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    self.searchBar.layer.zPosition = 1;
    self.animatedMap = [[QNDAnimations new] animateView:self.map];    

    self.venuesTableView.tableFooterView = imageView;
    self.venuesTableView.contentInset = UIEdgeInsetsMake(185, 0, 0, 0);
    
    [self.theBoxLocationService startMonitoringSignificantLocationChanges];
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.labelText = @"Finding your location";
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.theBoxLocationService notifyDidUpdateToLocation:self];
	[self.theBoxLocationService notifyDidFailWithError:self];
}

-(void)viewDidAppear:(BOOL)animated
{
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self.theBoxLocationService stopMonitoringSignificantLocationChanges];
}

- (IBAction)cancel:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)didFailUpdateToLocationWithError:(NSNotification *)notification
{
    DDLogError(@"%s %@", __PRETTY_FUNCTION__, notification);
    [self.theBoxLocationService dontNotifyDidFailWithError:self];
    [self.theBoxLocationService stopMonitoringSignificantLocationChanges];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    __block VLBAlertViewDelegate *alertViewDelegate;
    alertViewDelegate = [VLBAlertViews newAlertViewDelegateOnOk:^(UIAlertView *alertView, NSInteger buttonIndex) {
        [self dismissViewControllerAnimated:YES completion:nil];
        alertViewDelegate = nil;
    }];
    
    UIAlertView *alertView = [VLBAlertViews newAlertViewWithOk:@"Location access denied"
                                                       message:@"Go to \n Settings > \n Privacy > \n Location Services > \n Turn switch to 'ON' under 'thebox' to access your location."];
    alertView.delegate = alertViewDelegate;
    
    [alertView show];    
}

-(void)didUpdateToLocation:(NSNotification *)notification;
{
    DDLogInfo(@"%s %@", __PRETTY_FUNCTION__, notification);

    [self.hud hide:YES];
    [self.theBoxLocationService stopMonitoringSignificantLocationChanges];
    [self.theBoxLocationService dontNotifyOnUpdateToLocation:self];

	CLLocation *location = [VLBNotifications location:notification];
	
	CLLocationCoordinate2D centerCoordinate = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude) ;
	MKCoordinateSpan span = MKCoordinateSpanMake(0.009, 0.009);
	MKCoordinateRegion newRegion = MKCoordinateRegionMake(centerCoordinate, span);	

	[self.map setRegion:newRegion];
    self.map.showsUserLocation = YES;
    
    if(![self.venues vlb_isEmpty]){
        return;
    }
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.labelText = [NSString stringWithFormat:@"Finding stores nearby"];
    
}

#pragma mark VLBLocationOperationDelegate

-(void)didSucceedWithLocations:(NSArray*)locations givenParameters:(NSDictionary *)parameters
{
    DDLogVerbose(@"%s: %@", __PRETTY_FUNCTION__, locations);
    [self.hud hide:YES];

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
        cell.textLabel.font = cell.detailTextLabel.font = [VLBTypography fontAvenirNextDemiBoldSixteen];
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
    NSMutableDictionary* store = [self.venues objectAtIndex:indexPath.row];

	[self.delegate didSelectStore:store];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 66.0;
}

#pragma mark UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    NSString* query = searchBar.text;
    
    CLLocation* userLocation = self.map.userLocation.location;
    
    AFHTTPRequestOperation* operation = [VLBQueries newLocationQuery:userLocation.coordinate.latitude longtitude:userLocation.coordinate.longitude query:query delegate:self];
    
    [operation start];    
}


@end
