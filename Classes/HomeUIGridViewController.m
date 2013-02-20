/*
 *  Copyright 2010 The Box
 *  All rights reserved.
 *
 *  This file is part of TheBox
 *
 *  Created by Markos Charatzas (@qnoid) on 23/11/2010.
 *  Contributor(s): .-
 */
#import <QuartzCore/QuartzCore.h>
#import "HomeUIGridViewController.h"
#import "TheBoxUICell.h"
#import "TheBoxQueries.h"
#import "UploadUIViewController.h"
#import "TheBoxBinarySearch.h"
#import "TheBoxPredicates.h"
#import "AFHTTPRequestOperation.h"
#import "DetailsUIViewController.h"
#import "NSArray+Decorator.h"
#import "UIImageView+AFNetworking.h"
#import "NSDictionary+TBDictionary.h"
#import "TheBoxUICell.h"
#import "TheBoxUIScrollView.h"
#import "TBItemView.h"
#import "TBUIView.h"
#import "TBColors.h"
#import "TheBoxLocationService.h"
#import "TBUITableViewDataSourceBuilder.h"
#import "TBUITableViewDelegateBuilder.h"
#import <objc/runtime.h>

static CGFloat const LOCATIONS_VIEW_HEIGHT = 44.0;

static NSString* const DEFAULT_ITEM_THUMB = @"default_item_thumb";
static NSString* const DEFAULT_ITEM_TYPE = @"png";

static NSInteger const FIRST_VIEW_TAG = -1;
static NSInteger const ACTIVITY_INDICATOR_TAG = -2;


@interface UITableViewController (TBUITableViewController)
@property(nonatomic, strong) NSObject<UITableViewDataSource> *dataSource;
@property(nonatomic, strong) NSObject<UITableViewDelegate> *delegate;
@end

@implementation UITableViewController (TBUITableViewController)

@dynamic dataSource;
@dynamic delegate;

-(void)setDataSource:(NSObject<UITableViewDataSource> *)dataSource
{
    static char const * const UITableViewDataSourceKey = "UITableViewDataSource";
    objc_setAssociatedObject(self, UITableViewDataSourceKey, dataSource, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(void)setDelegate:(NSObject<UITableViewDelegate> *)delegate
{
    static char const * const UITableViewDelegateKey = "UITableViewDelegate";
    objc_setAssociatedObject(self, UITableViewDelegateKey, delegate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end

@interface HomeUIGridViewController ()
@property(nonatomic, strong) CLLocation *location;
@property(nonatomic, strong) TheBoxLocationService *theBoxLocationService;
@property(nonatomic, strong) NSArray *locations;
@property(nonatomic, assign) NSUInteger index;
@property(nonatomic, strong) NSMutableArray *items;
@property(nonatomic, strong) UIImage *defaultItemImage;
-(id)initWithBundle:(NSBundle *)nibBundleOrNil locationService:(TheBoxLocationService*)locationService;
-(void)highlightLocation;
-(void)reloadItems;
@end


@implementation HomeUIGridViewController

+(HomeUIGridViewController*)newHomeGridViewController
{    
    HomeUIGridViewController* homeGridViewController = [[HomeUIGridViewController alloc] initWithBundle:[NSBundle mainBundle] locationService:[TheBoxLocationService theBox]];
    
    UILabel* titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"Nearby";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.adjustsFontSizeToFitWidth = YES;
    homeGridViewController.navigationItem.titleView = titleLabel;
    [titleLabel sizeToFit];

    homeGridViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Nearby" image:[UIImage imageNamed:@"group.png"] tag:0];

    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
	[center addObserver:homeGridViewController selector:@selector(applicationDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:[UIApplication sharedApplication]];
    
return homeGridViewController;
}

-(void)dealloc
{
    [self.theBoxLocationService dontNotifyOnUpdateToLocation:self];
    [self.theBoxLocationService dontNotifyOnFindPlacemark:self];
}


-(id)initWithBundle:(NSBundle *)nibBundleOrNil locationService:(TheBoxLocationService*)locationService
{
    self = [super initWithNibName:nil bundle:nibBundleOrNil];
    
    if (self) 
    {
        self.theBoxLocationService = locationService;
        self.locations = [NSArray array];
        self.items = [NSMutableArray array];
        self.theBoxLocationService = locationService;
        NSString* path = [nibBundleOrNil pathForResource:DEFAULT_ITEM_THUMB ofType:DEFAULT_ITEM_TYPE];
        self.defaultItemImage = [UIImage imageWithContentsOfFile:path];
    }
    
return self;
}

-(void)loadView
{
    CGRect applicationFrame = [[UIScreen mainScreen] applicationFrame];

    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(CGPointZero.x,
                                                            CGPointZero.y,
                                                            applicationFrame.size.width,
                                                            applicationFrame.size.height - 44.0 - 49.0)];
    view.backgroundColor = [UIColor whiteColor];

    TheBoxUIScrollView* locationsView = [TheBoxUIScrollView newHorizontalScrollView:CGRectMake(CGPointZero.x, CGPointZero.y, applicationFrame.size.width, LOCATIONS_VIEW_HEIGHT) viewsOf:122.0];
    locationsView.backgroundColor = [TBColors colorLightOrange];
    locationsView.datasource = self;
    locationsView.scrollViewDelegate = self;
    locationsView.showsHorizontalScrollIndicator = NO;
    
    TheBoxUIScrollView* itemsView = [TheBoxUIScrollView newHorizontalScrollView:CGRectMake(CGPointZero.x, LOCATIONS_VIEW_HEIGHT, applicationFrame.size.width, applicationFrame.size.height - LOCATIONS_VIEW_HEIGHT - 44.0 - 49) viewsOf:160.0];

    itemsView.datasource = self;
    itemsView.scrollViewDelegate = self;
    itemsView.decelerationRate = UIScrollViewDecelerationRateFast;
    
    UIImageView* signPostImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGPointZero.x, 8.0, 22.0, 28.0)];
    signPostImageView.image = [UIImage imageNamed:@"signpost"];

    [view addSubview:locationsView];
    [view addSubview:itemsView];
    [view addSubview:signPostImageView];
    
    self.view = view;
    self.locationsView = locationsView;
    self.itemsView = itemsView;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self.theBoxLocationService notifyDidUpdateToLocation:self];
    [self.theBoxLocationService notifyDidFindPlacemark:self];
    [self.theBoxLocationService notifyDidFailReverseGeocodeLocationWithError:self];
}

-(void)viewWillAppear:(BOOL)animated
{
	[[TheBoxQueries newGetLocations:self] start];
    [self.theBoxLocationService startMonitoringSignificantLocationChanges];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self.theBoxLocationService stopMonitoringSignificantLocationChanges];
}

#pragma mark application events

- (void)applicationDidBecomeActive:(NSNotification *)notification;
{
	[[TheBoxQueries newItemsQuery:self] start];
}

/**
 @precondition self.locationsView
 */
-(void)highlightLocation
{
    for (UIButton* button in self.locationsView.subviews) {
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button removeTarget:self action:@selector(didClickOnLocation:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    UIButton* locationButton = (UIButton*)[self.locationsView viewWithTag:FIRST_VIEW_TAG];
    
    if(self.index != 0){
        locationButton = (UIButton*)[self.locationsView viewWithTag:self.index];
    }
    
    [locationButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [locationButton addTarget:self action:@selector(didClickOnLocation:) forControlEvents:UIControlEventTouchUpInside];
}

/**
  @precondition self.locations
 */
-(void)reloadItems
{
    NSDictionary* currentLocation = [self.locations objectAtIndex:self.index];
    NSUInteger locationId = [[[currentLocation objectForKey:@"location"] objectForKey:@"id"] unsignedIntValue];
    
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:
                                                  CGRectMake(CGPointZero.x, CGPointZero.y, [[UIScreen mainScreen] bounds].size.width, 323.0)];
    
    activityIndicator.tag = ACTIVITY_INDICATOR_TAG;
    activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    [activityIndicator startAnimating];
    
    [self.view insertSubview:activityIndicator atIndex:0];
    [self.view bringSubviewToFront:activityIndicator];
    
    [[TheBoxQueries newGetItemsGivenLocationId:locationId delegate:self] start];
}

#pragma mark TBLocationOperationDelegate

-(void)didSucceedWithLocations:(NSArray*)locations
{
    self.locations = locations;
    [self.locationsView flashScrollIndicators];
    [self.locationsView setNeedsLayout];
    [self.locationsView layoutIfNeeded];
}

-(void)didFailOnLocationWithError:(NSError*)error
{
    NSLog(@"%s %@", __PRETTY_FUNCTION__, error);
}

#pragma mark TheBoxUIScrollViewDatasource

-(NSUInteger)numberOfViewsInScrollView:(TheBoxUIScrollView *)scrollView
{
    if(![self.locationsView isEqual:scrollView]){
       return [self.items count];
    }
    
return [self.locations count];
}

- (UIView *)viewInScrollView:(TheBoxUIScrollView *)scrollView ofFrame:(CGRect)frame atIndex:(NSUInteger)index
{
    if(![self.locationsView isEqual:scrollView])
    {
        TBItemView* itemView = [TBItemView itemViewWithOwner:self];
        itemView.frame = frame;
    return itemView;
    }

    UIButton *storeButton = [[UIButton alloc] initWithFrame:frame];
    storeButton.titleLabel.numberOfLines = 0;
    storeButton.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [storeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
return storeButton;
}

#pragma mark TheBoxUIScrollViewDelegate

-(void)didLayoutSubviews:(UIScrollView*)scrollView
{
    if(![self.locationsView isEqual:scrollView]){
        return;
    }

    [self highlightLocation];
    [self reloadItems];
}

-(void)viewInScrollView:(TheBoxUIScrollView *)scrollView willAppearBetween:(NSUInteger)minimumVisibleIndex to:(NSUInteger)maximumVisibleIndex
{
}

-(void)viewInScrollView:(TheBoxUIScrollView *)scrollView willAppear:(UIView *)view atIndex:(NSUInteger)index
{
    if(![self.locationsView isEqual:scrollView])
    {
        NSDictionary *item = [[[self items] objectAtIndex:index] objectForKey:@"item"];

        TBItemView *imageView = (TBItemView*)view;
        //@"http://s3-eu-west-1.amazonaws.com/com.verylargebox.server/items/images/000/000/020/thumb/.jpg"
        [imageView.itemImageView setImageWithURL:[NSURL URLWithString:[item objectForKey:@"imageURL"]] placeholderImage:self.defaultItemImage];

    return;
    }

    NSDictionary *location = [[[self locations] objectAtIndex:index] objectForKey:@"location"];

    UIButton *button = (UIButton*)view;
    
    if(index == 0){
        button.tag = FIRST_VIEW_TAG;
    }
    else{
        button.tag = index;
    }
    
    id name = [location objectForKey:@"name"];
    
    if([[NSNull null] isEqual:name]){
        name = @"";
    }
    
    [button setBackgroundColor:[TBColors colorLightOrange]];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitle:name forState:UIControlStateNormal];
    button.titleEdgeInsets = UIEdgeInsetsMake(0, 22, 0, 0);
}

-(void)scrollView:(UIScrollView *)scrollView willStopAt:(NSUInteger)index
{
    NSLog(@"%s %u", __PRETTY_FUNCTION__, index);
    
    if(![self.locationsView isEqual:scrollView]){
        return;
    }
    
    self.index = index;

    [self highlightLocation];
    [self reloadItems];
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
    NSLog(@"%s %@", __PRETTY_FUNCTION__, items);
    
    UIActivityIndicatorView *activityIndicator = (UIActivityIndicatorView*)[self.view viewWithTag:ACTIVITY_INDICATOR_TAG];
    [activityIndicator stopAnimating];
    [activityIndicator removeFromSuperview];
    
	self.items = items;
    [self.itemsView flashScrollIndicators];
    [self.itemsView setNeedsLayout];
}

-(void)didFailOnItemsWithError:(NSError*)error
{
    NSLog(@"%s, %@", __PRETTY_FUNCTION__, error);
}

-(void)didSelectView:(TheBoxUIScrollView*)scrollView atIndex:(NSUInteger)index
{
    if([self.locationsView isEqual:scrollView]){
        return;
    }
    
	//there should be a mapping between the index of the cell and the id of the item
	NSMutableDictionary *item = [[self.items objectAtIndex:index] objectForKey:@"item"];
    
    [TestFlight passCheckpoint:[NSString stringWithFormat:@"%@, %s", [self class], __PRETTY_FUNCTION__]];
    
    DetailsUIViewController* detailsViewController = [DetailsUIViewController newDetailsViewController:item];
    detailsViewController.hidesBottomBarWhenPushed = YES;
    
    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:nil action:nil];
    self.navigationItem.backBarButtonItem = backBarButton;
    
    [self.navigationController pushViewController:detailsViewController animated:YES];
}

#pragma mark TheBoxLocationServiceDelegate
-(void)didUpdateToLocation:(NSNotification *)notification
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
	self.location = [TheBoxNotifications location:notification];
}

-(void)didFindPlacemark:(NSNotification *)notification
{
    NSLog(@"%s %@", __PRETTY_FUNCTION__, notification);
    CLPlacemark *placemark = [TheBoxNotifications place:notification];
    UILabel* titleView = (UILabel*)self.navigationItem.titleView;
    titleView.text = [NSString stringWithFormat:@"It's right here in %@", placemark.locality];
    [titleView sizeToFit];
    self.tabBarItem.title = @"Edinburgh";
}

-(void)didFailReverseGeocodeLocationWithError:(NSNotification *)notification
{
    NSLog(@"%s %@", __PRETTY_FUNCTION__, notification);

    UITableViewController *availablePlacesViewController = [[UITableViewController alloc] initWithStyle:UITableViewStylePlain];
    availablePlacesViewController.title = @"Select a location where thebox is available";
    
    NSObject<UITableViewDataSource> *datasource = [[[[TBUITableViewDataSourceBuilder new] numberOfRowsInSection:^NSInteger(UITableView *tableView, NSInteger section) {
    return 1;
    }] cellForRowAtIndexPath:tbCellForRowAtIndexPath(^(UITableViewCell *cell) {
        cell.textLabel.text = @"Edinburgh";
    })] newDatasource];
    availablePlacesViewController.dataSource = datasource;
    availablePlacesViewController.tableView.dataSource = datasource;

    availablePlacesViewController.tableView.delegate = self;
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:availablePlacesViewController];
    navigationController.navigationBar.titleTextAttributes = @{UITextAttributeFont:[UIFont fontWithName:@"Arial" size:14.0]};

    [self presentModalViewController:navigationController animated:YES];
}

#pragma mark UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UILabel* titleView = (UILabel*)self.navigationItem.titleView;
    titleView.text = [NSString stringWithFormat:@"It's right here in %@", @"Edinburgh"];
    [titleView sizeToFit];
    self.tabBarItem.title = @"Edinburgh";
    [self.navigationController dismissModalViewControllerAnimated:YES];
}

-(IBAction)didClickOnLocation:(id)sender
{
    [TestFlight passCheckpoint:[NSString stringWithFormat:@"%@, %s", [self class], __PRETTY_FUNCTION__]];
    
    NSString *urlstring=[NSString stringWithFormat:@"http://maps.google.com/?saddr=%f,%f&daddr=%@,%@",self.location.coordinate.latitude,self.location.coordinate.longitude,[[[self.locations objectAtIndex:self.index] objectForKey:@"location"] objectForKey:@"lat"],[[[self.locations objectAtIndex:self.index] objectForKey:@"location"] objectForKey:@"lng"]];
    
    NSLog(@"%@", urlstring);
    
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:urlstring]];
}

@end
