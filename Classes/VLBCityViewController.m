//
//
//  VLBCityViewController.m
//  verylargebox 
//
//  Created by Markos Charatzas on 23/11/2010.
//  Copyright (c) 2010 (verylargebox.com). All rights reserved.
//


#import <QuartzCore/QuartzCore.h>
#import "VLBCityViewController.h"
#import "VLBCell.h"
#import "VLBQueries.h"
#import "VLBTakePhotoViewController.h"
#import "VLBBinarySearch.h"
#import "VLBPredicates.h"
#import "AFHTTPRequestOperation.h"
#import "VLBDetailsViewController.h"
#import "NSArray+VLBDecorator.h"
#import "UIImageView+AFNetworking.h"
#import "NSDictionary+VLBDictionary.h"
#import "VLBCell.h"
#import "VLBScrollView.h"
#import "VLBView.h"
#import "VLBColors.h"
#import "VLBLocationService.h"
#import "VLBTableViewDataSourceBuilder.h"
#import "VLBTableViewDelegateBuilder.h"
#import "UIViewController+VLBViewController.h"
#import "VLBUserItemView.h"
#import "VLBAlertViews.h"
#import "MBProgressHUD.h"
#import "VLBPolygon.h"
#import "VLBDrawRects.h"
#import "VLBMacros.h"
#import "VLBErrorBlocks.h"
#import "TestFlight.h"
#import "DDLog.h"

static CGFloat const LOCATIONS_VIEW_HEIGHT = 100.0;
static CGFloat const LOCATIONS_VIEW_WIDTH = 133.0;

static NSString* const DEFAULT_ITEM_THUMB = @"default_item_thumb";
static NSString* const DEFAULT_ITEM_TYPE = @"png";

static NSInteger const FIRST_VIEW_TAG = -1;

@interface NSOperationQueue (VLBOperationQueue)
-(BOOL)vlb_isInProgress;
@end

@implementation NSOperationQueue (VLBOperationQueue)

-(BOOL)vlb_isInProgress {
    return [self operationCount] > 0;
}

@end

/*
 Using a UIButton to display a store given the requirements,
    tap on selected store to get directions
    have left, right padding on the store name as to distinguish with the adjacent ones
 
 
 */
@interface VLBCityViewController ()
@property(nonatomic, strong) VLBLocationService *theBoxLocationService;
@property(nonatomic, strong) CLPlacemark *placemark;
@property(nonatomic, strong) NSArray *localities;
@property(nonatomic, strong) NSArray *locations;
@property(nonatomic, assign) NSUInteger index;
@property(nonatomic, strong) NSMutableArray *items;
@property(nonatomic, assign) NSUInteger numberOfRows;
@property(nonatomic, strong) UIImage *defaultItemImage;
@property(nonatomic, strong) NSOperationQueue *operationQueue;
@property(nonatomic, copy) VLBUserItemViewGetDirections didTapOnGetDirectionsButton;
-(id)initWithBundle:(NSBundle *)nibBundleOrNil locationService:(VLBLocationService *)locationService;
-(void)updateTitle:(NSString *)localityName;
-(void)reloadItems;
@end


@implementation VLBCityViewController

+(VLBCityViewController *)newHomeGridViewController
{
    VLBLocationService* locationService = [VLBLocationService theBoxLocationService];
    
    VLBCityViewController* cityViewController = [[VLBCityViewController alloc] initWithBundle:[NSBundle mainBundle] locationService:locationService];
    
    UIButton* refreshButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [refreshButton setFrame:CGRectMake(0, 0, 30, 30)];
    [refreshButton setImage:[UIImage imageNamed:@"refresh.png"] forState:UIControlStateNormal];
    [refreshButton setImage:[UIImage imageNamed:@"refresh-grey.png"] forState:UIControlStateDisabled];
    [refreshButton addTarget:cityViewController action:@selector(refreshLocations) forControlEvents:UIControlEventTouchUpInside];

    cityViewController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:refreshButton];
    cityViewController.navigationItem.rightBarButtonItem.enabled = NO;
    
    UILabel* titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"Nearby";
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.backgroundColor = [UIColor clearColor];
		titleLabel.font = [VLBTypography fontAvenirNextDemiBoldSixteen];
    titleLabel.adjustsFontSizeToFitWidth = YES;
    cityViewController.navigationItem.titleView = titleLabel;
    [titleLabel sizeToFit];

    cityViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Nearby" image:[UIImage imageNamed:@"city.png"] tag:0];
    
return cityViewController;
}

-(void)dealloc
{
    [self.theBoxLocationService dontNotifyDidFailWithError:self];
    [self.theBoxLocationService dontNotifyDidFailReverseGeocodeLocationWithError:self];
}


-(id)initWithBundle:(NSBundle *)nibBundleOrNil locationService:(VLBLocationService *)locationService
{
    self = [super initWithNibName:NSStringFromClass([VLBCityViewController class]) bundle:nibBundleOrNil];
    
    if (!self)
    {
        return nil;
    }
    
    self.theBoxLocationService = locationService;
    self.locations = [NSArray array];
    self.items = [NSMutableArray array];
    NSString* path = [nibBundleOrNil pathForResource:DEFAULT_ITEM_THUMB ofType:DEFAULT_ITEM_TYPE];
    self.defaultItemImage = [UIImage imageWithContentsOfFile:path];
    self.operationQueue = [NSOperationQueue new];
    
return self;
}

-(void)drawRect:(CGRect)rect inView:(UIView *)view
{
    [[VLBDrawRects new] drawContextOfHexagonInRect:rect];
}

-(void)refreshLocations
{
    self.navigationItem.rightBarButtonItem.enabled = NO;
    [[VLBQueries newGetLocationsGivenLocalityName:self.placemark.locality delegate:self] start];
}

- (void)updateTitle:(NSString *)localityName
{
    UILabel* titleView = (UILabel*) self.navigationItem.titleView;
    titleView.text = [NSString stringWithFormat:@"Stores in %@", localityName];
    [titleView sizeToFit];
    self.tabBarItem.title = localityName;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"hexabump.png"]];
    self.locationsView.backgroundColor = [VLBColors colorDarkGrey];
    self.locationsView.showsHorizontalScrollIndicator = NO;
    self.locationsView.enableSeeking = YES;
    self.locationsView.contentInset = UIEdgeInsetsMake(0.0f, 100.0f, 0.0f, 100.0f);
    self.locationsView.contentOffset = CGPointMake(-100.0f, 0.0f);
    VLBScrollViewAllowSelection(self.locationsView, NO);
    self.itemsView.showsVerticalScrollIndicator = YES;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.itemsView animated:YES];
    hud.labelText = @"Finding your location";
}

-(void)viewWillAppear:(BOOL)animated
{
	[[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationDidBecomeActive:)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:[UIApplication sharedApplication]];
}

-(void)viewDidAppear:(BOOL)animated
{
    [self.theBoxLocationService notifyDidFindPlacemark:self];
    [self.theBoxLocationService notifyDidFailWithError:self];
    [self.theBoxLocationService notifyDidFailReverseGeocodeLocationWithError:self];
    [self.theBoxLocationService startMonitoringSignificantLocationChanges];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIApplicationDidBecomeActiveNotification
                                                  object:[UIApplication sharedApplication]];
}

#pragma mark application events

- (void)applicationDidBecomeActive:(NSNotification *)notification;
{
	[self.theBoxLocationService startMonitoringSignificantLocationChanges];
}

/**
 @precondition self.locationsView
 */
-(void)highlightLocation
{
    for (UIButton* button in self.locationsView.subviews) {
        [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    }
    
    UIButton* locationButton = (UIButton*)[self.locationsView viewWithTag:FIRST_VIEW_TAG];
    
    if(self.index != 0){
        locationButton = (UIButton*)[self.locationsView viewWithTag:self.index];
    }
    
    [locationButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

/**
  @precondition self.locations
 */
-(void)reloadItems
{
    [MBProgressHUD showHUDAddedTo:self.itemsView animated:YES];

    [self.operationQueue cancelAllOperations];
    
    NSDictionary* currentLocation = [self.locations objectAtIndex:self.index];
    NSUInteger locationId = [[[currentLocation objectForKey:@"location"] objectForKey:@"id"] unsignedIntValue];
    
    [self.operationQueue addOperation:[VLBQueries newGetItemsGivenLocationId:locationId page:VLB_Integer(1) delegate:self]];
    [self.operationQueue addOperation:[VLBQueries newGetItemsGivenLocationId:locationId delegate:self]];
}

#pragma mark TBLocationOperationDelegate

-(void)didSucceedWithLocations:(NSArray*)locations givenParameters:(NSDictionary *)parameters
{
    self.navigationItem.rightBarButtonItem.enabled = YES;
    [MBProgressHUD hideHUDForView:self.itemsView animated:YES];
    self.locations = locations;
    [self.locationsView setNeedsLayout];
}

-(void)didFailOnLocationWithError:(NSError*)error
{
    DDLogError(@"%s %@", __PRETTY_FUNCTION__, error);
    [MBProgressHUD hideHUDForView:self.itemsView animated:YES];
}

#pragma mark TBNSErrorDelegate
-(void)didFailWithCannonConnectToHost:(NSError *)error
{
    [MBProgressHUD hideHUDForView:self.itemsView animated:YES];
    [VLBErrorBlocks localizedDescriptionOfErrorBlock:self.view](error);
}

-(void)didFailWithNotConnectToInternet:(NSError *)error
{
    [MBProgressHUD hideHUDForView:self.itemsView animated:YES];
    [VLBErrorBlocks localizedDescriptionOfErrorBlock:self.view](error);
}

-(void)didFailWithTimeout:(NSError *)error
{
    [MBProgressHUD hideHUDForView:self.itemsView animated:YES];
    [VLBErrorBlocks localizedDescriptionOfErrorBlock:self.view](error);
}

#pragma mark VLBGridViewDatasource
-(NSUInteger)numberOfViewsInGridView:(VLBGridView *)gridView {
    return self.numberOfRows;
}

-(NSUInteger)numberOfViewsInGridView:(VLBGridView *)gridView atIndex:(NSInteger)index
{
    if(self.items.count < 2){
        return 1;
    }

    if(index != (self.numberOfRows - 1)){
        return 2;
    }

return self.items.count%2==0?2:1;
}

-(UIView *)gridView:(VLBGridView *)gridView viewOf:(UIView *)view ofFrame:(CGRect)frame atRow:(NSUInteger)row atIndex:(NSUInteger)index {
return [[UIImageView alloc] initWithFrame:frame];
}

-(void)gridView:(VLBGridView *)gridView atIndex:(NSInteger)index willAppear:(UIView *)view{
    
}

-(void)gridView:(VLBGridView *)gridView viewOf:(UIView *)viewOf atRow:(NSInteger)row atIndex:(NSInteger)index willAppear:(UIView *)view
{
    NSDictionary *item = [[[self items] objectAtIndex:(row * 2) + index] objectForKey:@"item"];
    
    UIImageView *imageView = (UIImageView *)view;
    //@"http://s3-eu-west-1.amazonaws.com/com.verylargebox.server/items/images/000/000/020/thumb/.jpg"
    [imageView setImageWithURL:[NSURL URLWithString:[item objectForKey:@"imageURL"]]
              placeholderImage:self.defaultItemImage];
}

#pragma mark VLBGridViewDelegate

-(void)didSelect:(VLBGridView *)gridView atRow:(NSInteger)row atIndex:(NSInteger)index
{
    //there should be a mapping between the index of the cell and the id of the item
	NSMutableDictionary *item = [[self.items objectAtIndex:(row * 2) + index] objectForKey:@"item"];
    
    [TestFlight passCheckpoint:[NSString stringWithFormat:@"%@, %s", [self class], __PRETTY_FUNCTION__]];
    
    VLBDetailsViewController* detailsViewController = [VLBDetailsViewController newDetailsViewController:item];
    detailsViewController.hidesBottomBarWhenPushed = YES;
    
    UIButton* backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setFrame:CGRectMake(0, 0, 30, 30)];
    [backButton addTarget:self.navigationController action:@selector(popViewControllerAnimated:) forControlEvents:UIControlEventTouchUpInside];
    [backButton setImage:[UIImage imageNamed:@"left-arrow.png"] forState:UIControlStateNormal];

    detailsViewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    [self.navigationController pushViewController:detailsViewController animated:YES];
}

-(CGFloat)whatCellWidth:(VLBGridView *)gridView{
    return 160.0;
}

#pragma mark VLBScrollViewDatasource

-(NSUInteger)numberOfViewsInScrollView:(VLBScrollView *)scrollView {
return [self.locations count];
}

- (UIView *)viewInScrollView:(VLBScrollView *)scrollView ofFrame:(CGRect)frame atIndex:(NSUInteger)index
{
    UIButton *storeButton = [[UIButton alloc] initWithFrame:frame];
    storeButton.titleLabel.numberOfLines = 0;
    storeButton.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
		storeButton.titleLabel.font = [VLBTypography fontAvenirNextDemiBoldSixteen];
    [storeButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    
return storeButton;
}

#pragma mark VLBScrollViewDelegate

-(VLBScrollViewOrientation)orientation:(VLBScrollView*)scrollView{
return VLBScrollViewOrientationHorizontal;
}

-(CGFloat)viewsOf:(VLBScrollView *)scrollView{
    return LOCATIONS_VIEW_WIDTH;
}

-(void)didLayoutSubviews:(UIScrollView*)scrollView
{
    [self highlightLocation];
    [self reloadItems];
}

-(void)viewInScrollView:(VLBScrollView *)scrollView willAppearBetween:(NSUInteger)minimumVisibleIndex to:(NSUInteger)maximumVisibleIndex
{
}

-(void)viewInScrollView:(VLBScrollView *)scrollView willAppear:(UIView *)view atIndex:(NSUInteger)index
{
    NSDictionary *location = [[[self locations] objectAtIndex:index] objectForKey:@"location"];

    UIButton *storeButton = (UIButton*)view;
    
    if(index == 0){
        storeButton.tag = FIRST_VIEW_TAG;
    }
    else{
        storeButton.tag = index;
    }
    
    id name = [location vlb_objectForKey:@"name" ifNil:@""];
    
    [storeButton setBackgroundColor:[VLBColors colorDarkGrey]];
    [storeButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [storeButton setTitle:name forState:UIControlStateNormal];
}

-(void)scrollView:(UIScrollView *)scrollView willStopAt:(NSUInteger)index
{
    DDLogVerbose(@"%s %u", __PRETTY_FUNCTION__, index);
    
    if(![self.locationsView isEqual:scrollView]){
        return;
    }

    if(self.index == index){
        return;
    }
    
    self.index = index;

    [self highlightLocation];
    [self reloadItems];
}

-(void)didSelectView:(VLBScrollView *)scrollView atIndex:(NSUInteger)index point:(CGPoint)point
{
    [self.locationsView setContentOffset:point animated:YES];
}

#pragma mark thebox

/*
 * This method will be called after all the callbacks on 
 * [self element:with:] for each item.
 * 
 * At this time the items array has been updated and we can 
 * call [self.gridView reload] to update the grid view
 * 
 [
 {
 "location": {
 "created_at": "2012-05-05T11:29:19Z",
 "distance": null,
 "id": 11,
 "lat": "55.94790220908779",
 "lng": "-3.186249732971191",
 "name": "Blackwell's",
 "updated_at": "2012-05-05T11:29:19Z",
 "items": [
     {
         "created_at": "2012-05-05T11:35:05Z",
         "id": 30,
         "image_content_type": "image/jpeg",
         "image_file_name": ".jpg",
         "image_file_size": 277323,
         "location_id": 11,
         "updated_at": "2012-05-05T11:35:05Z",
         "when": "8 days ago",
         "imageURL": "/system/items/images/000/000/030/thumb/.jpg",
         "iphoneImageURL": "/system/items/images/000/000/030/iphone/.jpg",
         "location": {
             "created_at": "2012-05-05T11:29:19Z",
             "distance": null,
             "id": 11,
             "lat": "55.94790220908779",
             "lng": "-3.186249732971191",
             "name": "Blackwell's",
             "updated_at": "2012-05-05T11:29:19Z"
        }
     },
     {
         "created_at": "2012-05-05T11:34:46Z",
         "id": 29,
         "image_content_type": "image/jpeg",
         "image_file_name": ".jpg",
         "image_file_size": 386772,
         "location_id": 11,
         "updated_at": "2012-05-05T11:34:46Z",
         "when": "8 days ago",
         "imageURL": "/system/items/images/000/000/029/thumb/.jpg",
         "iphoneImageURL": "/system/items/images/000/000/029/iphone/.jpg",
         "location": {
             "created_at": "2012-05-05T11:29:19Z",
             "distance": null,
             "id": 11,
             "lat": "55.94790220908779",
             "lng": "-3.186249732971191",
             "name": "Blackwell's",
             "updated_at": "2012-05-05T11:29:19Z"
         }
     }
     }]
 */

-(void)didSucceedWithItems:(NSMutableArray*) items
{
    DDLogVerbose(@"%s %@", __PRETTY_FUNCTION__, items);
    
    [MBProgressHUD hideAllHUDsForView:self.itemsView animated:YES];
    
	self.items = items;
    self.numberOfRows = round((float)self.items.count/2.0);
    [self.itemsView flashScrollIndicators];
    [self.itemsView reload];
}

-(void)didFailOnItemsWithError:(NSError*)error
{
    DDLogError(@"%s, %@", __PRETTY_FUNCTION__, error);
    [MBProgressHUD hideHUDForView:self.itemsView animated:YES];
}

#pragma mark VLBServiceDelegate
-(void)didFailUpdateToLocationWithError:(NSNotification *)notification
{
    [self.theBoxLocationService dontNotifyDidFailWithError:self];
    [self.theBoxLocationService stopMonitoringSignificantLocationChanges];

    DDLogError(@"%s", __PRETTY_FUNCTION__);
    [MBProgressHUD hideHUDForView:self.itemsView animated:YES];

    VLBAlertViewDelegate *alertViewDelegate = [VLBAlertViews newAlertViewDelegateOnOkDismiss];
    UIAlertView *alertView = [VLBAlertViews newAlertViewWithOk:@"Location access denied"
                                                       message:@"Go to \n Settings > \n Privacy > \n Location Services > \n Turn switch to 'ON' under 'verylargebox' to access your location."];
    alertView.delegate = alertViewDelegate;
    
    [alertView show]; 
}

-(void)didFindPlacemark:(NSNotification *)notification
{
    DDLogInfo(@"%s %@", __PRETTY_FUNCTION__, notification);
    [self.theBoxLocationService dontNotifyOnFindPlacemark:self];
    [self.theBoxLocationService stopMonitoringSignificantLocationChanges];    
    
    self.navigationItem.rightBarButtonItem.enabled = YES;
    
    self.placemark = [VLBNotifications place:notification];

    NSString *localityName = self.placemark.locality;
    
    [self updateTitle:localityName];

    [[VLBQueries newGetLocationsGivenLocalityName:localityName delegate:self] start];
}

-(void)didFailReverseGeocodeLocationWithError:(NSNotification *)notification
{
    DDLogWarn(@"%s %@", __PRETTY_FUNCTION__, notification);
    [self.theBoxLocationService dontNotifyOnFindPlacemark:self];
    [self.theBoxLocationService stopMonitoringSignificantLocationChanges];
    
    VLBLocalitiesTableViewController *localitiesViewController = [VLBLocalitiesTableViewController newLocalitiesViewController];
    localitiesViewController.delegate = self;

    UINavigationController *navigationController =
        [[UINavigationController alloc] initWithRootViewController:localitiesViewController];
    
    [self presentViewController:navigationController animated:YES completion:nil];
}

#pragma mark TBLocalitiesTableViewControllerDelegate

-(void)didSelectLocality:(NSDictionary *)locality
{
    NSString *localityName = [locality objectForKey:@"name"];

    [self updateTitle:localityName];

    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    [[VLBQueries newGetLocationsGivenLocalityName:localityName delegate:self] start];
}

-(IBAction)didTapOnGetDirectionsButton:(id)sender
{
    if([self.locations vlb_isEmpty]){
        return;
    }
    
    NSDictionary *location = [[self.locations objectAtIndex:self.index] objectForKey:@"location"];
    
    __weak VLBCityViewController *wself = self;
    VLBAlertViewDelegate *alertViewDelegateOnOkGetDirections = [VLBAlertViews newAlertViewDelegateOnOk:^(UIAlertView *alertView, NSInteger buttonIndex) {
        [TestFlight passCheckpoint:[NSString stringWithFormat:@"%@, %s", [wself class], __PRETTY_FUNCTION__]];

        tbUserItemViewGetDirections(CLLocationCoordinate2DMake([[location objectForKey:@"lat"] floatValue],
                [[location objectForKey:@"lng"] floatValue]),
                location)();
    }];

    VLBAlertViewDelegate *alertViewDelegateOnCancelDismiss = [VLBAlertViews newAlertViewDelegateOnCancelDismiss];
    
    NSObject<UIAlertViewDelegate> *didTapOnGetDirectionsDelegate =
        [VLBAlertViews all:@[alertViewDelegateOnOkGetDirections, alertViewDelegateOnCancelDismiss]];
    
    UIAlertView *alertView = [VLBAlertViews newAlertViewWithOkAndCancel:@"Get Directions" message:[NSString stringWithFormat:@"Exit the app and get directions to %@.", [location objectForKey:@"name"]]];
                                                                                                  
    alertView.delegate = didTapOnGetDirectionsDelegate;
    
    [alertView show];
}

@end
