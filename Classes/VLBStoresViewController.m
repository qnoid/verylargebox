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
#import "VLBAlertViews.h"
#import "NSDictionary+VLBFoursquareVenue.h"
#import "NSArray+VLBDecorator.h"
#import "VLBErrorBlocks.h"
#import "VLBTypography.h"
#import "QNDAnimations.h"
#import "QNDAnimatedView.h"
#import "VLBMacros.h"
#import "VLBViewControllers.h"
#import "CLLocation+VLBLocation.h"
#import "CALayer+VLBLayer.h"
#import "VLBColors.h"

static NSString* const foursquarePoweredByFilename = @"poweredByFoursquare";
static NSString* const foursquarePoweredByType = @"png";

static UIImage* foursquarePoweredBy;

@interface VLBStoresViewController ()
@property(nonatomic, strong) VLBLocationService *theBoxLocationService;
@property(nonatomic, strong) NSArray* venues;
@property(nonatomic, strong) NSObject<QNDAnimatedView> *animatedMap;

@property(nonatomic, strong) CLLocation *lastKnownLocation;
-(id)initWithBundle:(NSBundle *)nibBundleOrNil venues:(NSArray*)venues;
@end

@implementation VLBStoresViewController

+(VLBStoresViewController *)newLocationViewController:(NSArray*)venues
{
    VLBStoresViewController *storesViewController =
        [[VLBStoresViewController alloc] initWithBundle:[NSBundle mainBundle] venues:venues];

    UILabel* titleLabel;
    titleLabel = [[VLBViewControllers new] titleView:NSLocalizedString(@"navigationbar.title.store", @"Select a store")];
    storesViewController.navigationItem.titleView = titleLabel;
    [titleLabel sizeToFit];

    storesViewController.navigationItem.leftBarButtonItem = [[VLBViewControllers new] closeButton:storesViewController
                                                                                            action:@selector(cancel:)];

    storesViewController.navigationItem.rightBarButtonItem = [[VLBViewControllers new ]refreshButton:storesViewController
                                                                                               action:@selector(refreshLocations)];

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
    self.navigationItem.rightBarButtonItem = [[VLBViewControllers new] discardButton:self action:@selector(dismissSearchBar:)];

    NSValue *value = [[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    [self.animatedMap animateWithDuration:0.5 animation:^(UIView *view) {
        view.frame = CGRectMake(0, -view.frame.size.height, view.frame.size.width, view.frame.size.height);
    }];

    [UIView animateWithDuration:0.5 animations:^{
        self.venuesTableView.contentInset = self.venuesTableView.scrollIndicatorInsets = UIEdgeInsetsMake(64, 0, value.CGRectValue.size.height, 0);
    }];
}

-(void)keyboardWillHide:(NSNotification*)notification
{
    [self.animatedMap rewind];
    self.venuesTableView.contentInset = self.venuesTableView.scrollIndicatorInsets = UIEdgeInsetsMake(162 + 64, 0, 0, 0);
    
    CGRect visibleRect;
    visibleRect.origin = self.venuesTableView.bounds.origin;
    visibleRect.size = CGSizeMake(self.venuesTableView.bounds.size.width,
                                  self.venuesTableView.bounds.size.height - self.venuesTableView.contentInset.top +
                                  self.venuesTableView.bounds.origin.y);
    
    //CGRectMake(0, 0, 320, 392 - 205)
    [self.venuesTableView scrollRectToVisible:visibleRect animated:YES];
    self.navigationItem.rightBarButtonItem = [[VLBViewControllers new] refreshButton:self
                                                                              action:@selector(refreshLocations)];

}

-(void)dismissSearchBar:(id)sender
{
    [self.searchBar resignFirstResponder];
    self.searchBar.text = @"";

    [self.theBoxLocationService dontNotifyOnUpdateToLocation:self];
    [self.theBoxLocationService dontNotifyDidFailWithError:self];
    [self.theBoxLocationService stopMonitoringSignificantLocationChanges];

    UIButton *refresh = (UIButton*)self.navigationItem.rightBarButtonItem.customView;
    [refresh.imageView.layer vlb_rotate:VLBBasicAnimationBlockRotate];
    self.navigationItem.rightBarButtonItem.enabled = NO;

    AFHTTPRequestOperation* operation =
    [VLBQueries newLocationQuery:self.lastKnownLocation.coordinate.latitude
                      longtitude:self.lastKnownLocation.coordinate.longitude
                        delegate:self];
    
    [operation start];
}

-(void)viewDidLoad
{
    UIImageView* imageView = [[UIImageView alloc] initWithImage:foursquarePoweredBy];
    imageView.frame = CGRectMake(0, 0, 320, 121);
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    self.searchBar.placeholder = NSLocalizedString(@"viewcontrollers.stores.search.placeholder", @"Search for the store that has the item");
    self.searchBar.layer.zPosition = 1;
    self.animatedMap = [[QNDAnimations new] animateView:self.map];

    self.venuesTableView.tableFooterView = imageView;
    
    [self.theBoxLocationService startMonitoringSignificantLocationChanges];
    MBProgressHUD *hud = [VLBHuds newWithViewLocationArrow:self.view];
    [hud show:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
  [self.theBoxLocationService notifyDidUpdateToLocation:self];
	[self.theBoxLocationService notifyDidFailWithError:self];
}

-(void)viewDidAppear:(BOOL)animated
{
    UIButton *refresh = (UIButton*)self.navigationItem.rightBarButtonItem.customView;
    [refresh.imageView.layer vlb_rotate:VLBBasicAnimationBlockRotate];
    self.navigationItem.rightBarButtonItem.enabled = NO;
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
    [self.theBoxLocationService dontNotifyDidFailWithError:self];
    [self.theBoxLocationService stopMonitoringSignificantLocationChanges];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    DDLogWarn(@"%s", __PRETTY_FUNCTION__);
    NSError *error = [VLBNotifications error:notification];

    [VLBErrorBlocks locationErrorBlock:self.view config:VLB_PROGRESS_HUD_CUSTOM_VIEW_CIRCLE_NO](error);
}

-(void)didUpdateToLocation:(NSNotification *)notification;
{
    DDLogInfo(@"%s %@", __PRETTY_FUNCTION__, notification);

    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [self.theBoxLocationService stopMonitoringSignificantLocationChanges];
    [self.theBoxLocationService dontNotifyOnUpdateToLocation:self];

  	CLLocation *location = [VLBNotifications location:notification];
	
    if(![location vlb_isMoreAccurateThan:self.lastKnownLocation])
		{
  	  	UIButton *refresh = (UIButton*)self.navigationItem.rightBarButtonItem.customView;
	  	  [refresh.imageView.layer vlb_stopRotate];
	    	self.navigationItem.rightBarButtonItem.enabled = YES;
        
        [self.theBoxLocationService dontNotifyOnUpdateToLocation:self];
    return;
    }
    
   self.lastKnownLocation = location;

	 CLLocationCoordinate2D centerCoordinate = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude) ;
	 MKCoordinateSpan span = MKCoordinateSpanMake(0.009, 0.009);
   MKCoordinateRegion newRegion = MKCoordinateRegionMake(centerCoordinate, span);	
 	 [self.map setRegion:newRegion];
   self.map.showsUserLocation = YES;
    
   MBProgressHUD *hud = [VLBHuds newWithViewRadar:self.view];
   [hud show:YES];
    
   self.searchBar.text = @"";
   AFHTTPRequestOperation* operation =
   [VLBQueries newLocationQuery:self.lastKnownLocation.coordinate.latitude
                     longtitude:self.lastKnownLocation.coordinate.longitude
                       delegate:self];
    
   [operation start];
}

#pragma mark VLBLocationOperationDelegate

-(void)didSucceedWithLocations:(NSArray*)locations givenParameters:(NSDictionary *)parameters
{
    DDLogVerbose(@"%s: %@", __PRETTY_FUNCTION__, locations);
    UIButton *refresh = (UIButton*)self.navigationItem.rightBarButtonItem.customView;
    [refresh.imageView.layer vlb_stopRotate];
    self.navigationItem.rightBarButtonItem.enabled = YES;
    
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    if([locations vlb_isEmpty] && [self.venues vlb_isEmpty]){
        MBProgressHUD *newNoStoresFound = [VLBHuds newNoStoresFound:self.venuesTableView];
        [newNoStoresFound show:YES];
        [newNoStoresFound hide:YES afterDelay:0.5];
    return;
    }
    
    self.venues = locations;
    [self.venuesTableView reloadData];
}

-(void)didFailOnLocationWithError:(NSError*)error
{
    UIButton *refresh = (UIButton*)self.navigationItem.rightBarButtonItem.customView;
    [refresh.imageView.layer vlb_stopRotate];
    self.navigationItem.rightBarButtonItem.enabled = YES;

    DDLogError(@"%s: %@", __PRETTY_FUNCTION__, error);
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

#pragma mark TBNSErrorDelegate
-(void)didFailWithCannonConnectToHost:(NSError *)error
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [VLBErrorBlocks localizedDescriptionOfErrorBlock:self.view](error);
}

-(void)didFailWithNotConnectToInternet:(NSError *)error
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [VLBErrorBlocks localizedDescriptionOfErrorBlock:self.view](error);
}

-(void)didFailWithTimeout:(NSError *)error
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
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
    cell.textLabel.textColor = [VLBColors colorPrimaryBlue];
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
    MBProgressHUD *hud = [VLBHuds newWithViewSearch:self.view query:query];
    [hud show:YES];
}


-(void)refreshLocations
{
  [self.theBoxLocationService notifyDidUpdateToLocation:self];
	[self.theBoxLocationService notifyDidFailWithError:self];
  [self.theBoxLocationService startMonitoringSignificantLocationChanges];
}

@end
