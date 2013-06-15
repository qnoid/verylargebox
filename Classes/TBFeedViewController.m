//
//  TBFeedViewController.m
//  thebox
//
//  Created by Markos Charatzas on 25/05/2013.
//  Copyright (c) 2013 TheBox. All rights reserved.
//

#import "TBFeedViewController.h"
#import "TheBoxLocationService.h"
#import "TBUserItemView.h"
#import "TheBoxQueries.h"
#import "UIScrollView+SVPullToRefresh.h"
#import "UIImageView+AFNetworking.h"
#import "TheBoxNotifications.h"
#import "TBLocalitiesTableViewController.h"
#import "TBAlertViews.h"
#import "TBHuds.h"
#import "TBMacros.h"
#import "DDLog.h"

static NSString* const DEFAULT_ITEM_THUMB = @"default_item_thumb";
static NSString* const DEFAULT_ITEM_TYPE = @"png";

@interface TBFeedViewController ()
@property(nonatomic, weak) TheBoxUIScrollView* itemsView;

@property(nonatomic, strong) NSString *locality;
@property(nonatomic, strong) TheBoxLocationService *theBoxLocationService;
@property(nonatomic, strong) NSDictionary* residence;
@property(nonatomic, strong) NSMutableArray* items;
@property(nonatomic, strong) UIImage *defaultItemImage;
@property(nonatomic, copy) TBUserItemViewGetDirections didTapOnGetDirectionsButton;
@property(nonatomic, strong) NSOperationQueue *operationQueue;

@property(nonatomic, weak) MBProgressHUD *hud;
-(id)initWithBundle:(NSBundle *)nibBundleOrNil didTapOnGetDirectionsButton:(TBUserItemViewGetDirections)didTapOnGetDirectionsButton;
@end

@implementation TBFeedViewController

+(TBFeedViewController *)newFeedViewController
{
    TBFeedViewController * localityItemsViewController = [[TBFeedViewController alloc] initWithBundle:[NSBundle mainBundle]
                                                                         didTapOnGetDirectionsButton:tbUserItemViewGetDirections()];
    
    UILabel* titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"Recent";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.adjustsFontSizeToFitWidth = YES;
    localityItemsViewController.navigationItem.titleView = titleLabel;
    [titleLabel sizeToFit];
    
    localityItemsViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Recent" image:[UIImage imageNamed:@"clock.png"] tag:2];
    
    UIBarButtonItem *locateButton = [[UIBarButtonItem alloc]
                                    initWithImage:[UIImage imageNamed:@"location.png"]
                                    style:UIBarButtonItemStylePlain
                                    target:localityItemsViewController
                                    action:@selector(locate)];
    localityItemsViewController.navigationItem.rightBarButtonItem = locateButton;

return localityItemsViewController;
}

-(void)dealloc
{
    [self.theBoxLocationService dontNotifyDidFailWithError:self];
    [self.theBoxLocationService dontNotifyDidFailReverseGeocodeLocationWithError:self];
}

-(id)initWithBundle:(NSBundle *)nibBundleOrNil didTapOnGetDirectionsButton:(TBUserItemViewGetDirections)didTapOnGetDirectionsButton
{
    self = [super initWithNibName:NSStringFromClass([TBFeedViewController class]) bundle:nibBundleOrNil];
    
    if (!self) {
        return nil;
    }
    
    self.theBoxLocationService = [TheBoxLocationService theBoxLocationService];
    self.items = [NSMutableArray array];
    NSString* path = [nibBundleOrNil pathForResource:DEFAULT_ITEM_THUMB ofType:DEFAULT_ITEM_TYPE];
    self.defaultItemImage = [UIImage imageWithContentsOfFile:path];
    self.didTapOnGetDirectionsButton = didTapOnGetDirectionsButton;
    self.operationQueue = [NSOperationQueue new];
    
    return self;
}

-(void)updateTitle:(NSString*)localityName
{
    UILabel* titleView = (UILabel*) self.navigationItem.titleView;
    titleView.text = [NSString stringWithFormat:@"Recent in %@", localityName];
    [titleView sizeToFit];
}

-(void)loadView
{
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    
    TheBoxUIScrollView* itemsView = [[[[TheBoxUIScrollViewBuilder alloc] initWith:
                                       CGRectMake(CGPointZero.x, CGPointZero.y, screenBounds.size.width, 367.0) viewsOf:320.0] allowSelection] newVerticalScrollView];
    
    itemsView.backgroundColor = [UIColor whiteColor];
    itemsView.datasource = self;
    itemsView.scrollViewDelegate = self;
    itemsView.scrollsToTop = YES;
    
    self.view = itemsView;
    self.itemsView = itemsView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.theBoxLocationService notifyDidFindPlacemark:self];
    [self.theBoxLocationService notifyDidFailWithError:self];
    [self.theBoxLocationService notifyDidFailReverseGeocodeLocationWithError:self];
    
    __weak TBFeedViewController *wself = self;
    
    [self.itemsView addPullToRefreshWithActionHandler:^{
        [wself.operationQueue addOperation:[TheBoxQueries newGetItems:wself.locality page:TBInteger(1) delegate:wself]];
        [wself.operationQueue addOperation:[TheBoxQueries newGetItems:wself.locality delegate:wself]];
    }];
    
    self.hud = [MBProgressHUD showHUDAddedTo:self.itemsView animated:YES];
    self.hud.labelText = @"Finding your location";
}

-(void)viewWillDisappear:(BOOL)animated
{
}

-(void)viewDidAppear:(BOOL)animated
{
    [self.theBoxLocationService startMonitoringSignificantLocationChanges];    
}

-(void)locate
{
    TBLocalitiesTableViewController *localitiesViewController = [TBLocalitiesTableViewController newLocalitiesViewController];
    localitiesViewController.delegate = self;
    
    UINavigationController *navigationController =
    [[UINavigationController alloc] initWithRootViewController:localitiesViewController];
    
    navigationController.navigationBar.titleTextAttributes = @{UITextAttributeFont:[UIFont fontWithName:@"Arial" size:14.0]};
    
    [self presentModalViewController:navigationController animated:YES];
}

#pragma mark TBItemsOperationDelegate
-(void)didSucceedWithItems:(NSMutableArray *)items
{
    DDLogVerbose(@"%s", __PRETTY_FUNCTION__);
    DDLogVerbose(@"%@", items);
    
    self.items = items;
    [self.itemsView setNeedsLayout];
    [self.itemsView.pullToRefreshView stopAnimating];
}

-(void)didFailOnItemsWithError:(NSError *)error
{
    DDLogError(@"%s, %@", __PRETTY_FUNCTION__, error);
    [self.itemsView.pullToRefreshView stopAnimating];

    MBProgressHUD *hud = [TBHuds newWithView:self.view config:TB_PROGRESS_HUD_CUSTOM_VIEW_CIRCLE_NO];
    hud.detailsLabelText = error.localizedDescription;
    [hud show:YES];
}

#pragma mark TheBoxUIScrollViewDelegate

-(void)didLayoutSubviews:(UIScrollView *)scrollView{
    
}

-(void)viewInScrollView:(TheBoxUIScrollView *)scrollView willAppearBetween:(NSUInteger)minimumVisibleIndex to:(NSUInteger)maximumVisibleIndex{
    
}

-(void)scrollView:(UIScrollView *)scrollView willStopAt:(NSUInteger)index{
    
}

-(void)didSelectView:(TheBoxUIScrollView *)scrollView atIndex:(NSUInteger)inde point:(CGPoint)point {
    
}

#pragma mark TheBoxUIScrollViewDatasource

-(NSUInteger)numberOfViewsInScrollView:(TheBoxUIScrollView *)scrollView{
    return [self.items count];
}

-(UIView *)viewInScrollView:(TheBoxUIScrollView *)scrollView ofFrame:(CGRect)frame atIndex:(NSUInteger)index {
    return [[TBUserItemView alloc] initWithFrame:frame];
}

-(void)viewInScrollView:(TheBoxUIScrollView *)scrollView willAppear:(UIView *)view atIndex:(NSUInteger)index
{
    NSDictionary* item = [[self.items objectAtIndex:index] objectForKey:@"item"];
    
    TBUserItemView* userItemView = (TBUserItemView*)view;
    [userItemView.itemImageView setImageWithURL:[NSURL URLWithString:[item objectForKey:@"iphoneImageURL"]] placeholderImage:self.defaultItemImage];
    userItemView.whenLabel.text = [item objectForKey:@"when"];
    
    /**
     {
     "created_at" = "2013-03-07T19:58:26Z";
     foursquareid = 4b082a2ff964a520380523e3;
     id = 265;
     lat = "55.94223";
     lng = "-3.18421";
     name = "The Dagda Bar";
     "updated_at" = "2013-03-07T19:58:26Z";
     }
     */
    NSDictionary *location = [item objectForKey:@"location"];
    
    id name = [location objectForKey:@"name"];
    if([[NSNull null] isEqual:name]){
        name = @"";
    }
    
    userItemView.storeLabel.text = name;
    
    __weak TBFeedViewController *wself = self;    
    userItemView.didTapOnGetDirectionsButton = ^(CLLocationCoordinate2D destination, NSDictionary *options){
        TBAlertViewDelegate *alertViewDelegateOnOkGetDirections = [TBAlertViews newAlertViewDelegateOnOk:^(UIAlertView *alertView, NSInteger buttonIndex) {
            [TestFlight passCheckpoint:[NSString stringWithFormat:@"%@, %@", [wself class], @"didTapOnGetDirectionsButton"]];
            
            wself.didTapOnGetDirectionsButton(CLLocationCoordinate2DMake([[location objectForKey:@"lat"] floatValue],
                                                                         [[location objectForKey:@"lng"] floatValue]),
                                              location);
        }];
        
        TBAlertViewDelegate *alertViewDelegateOnCancelDismiss = [TBAlertViews newAlertViewDelegateOnCancelDismiss];
        
        NSObject<UIAlertViewDelegate> *didTapOnGetDirectionsDelegate =
        [TBAlertViews all:@[alertViewDelegateOnOkGetDirections, alertViewDelegateOnCancelDismiss]];
        
        UIAlertView *alertView = [TBAlertViews newAlertViewWithOkAndCancel:@"Get Directions" message:[NSString stringWithFormat:@"Exit the app and get directions to %@.", [location objectForKey:@"name"]]];
        
        alertView.delegate = didTapOnGetDirectionsDelegate;
        
        [alertView show];
    };
}

#pragma mark TheBoxLocationServiceDelegate
-(void)didFindPlacemark:(NSNotification *)notification
{
    [self.hud hide:YES];
    
    [self.theBoxLocationService stopMonitoringSignificantLocationChanges];
    [self.theBoxLocationService dontNotifyOnFindPlacemark:self];
    
    DDLogInfo(@"%s", __PRETTY_FUNCTION__);
	NSString *locality = [TheBoxNotifications place:notification].locality;
    
    [self updateTitle:locality];
    
    self.locality = locality;
    [self.itemsView triggerPullToRefresh];
}

-(void)didFailUpdateToLocationWithError:(NSNotification *)notification
{
    [self.hud hide:YES];
    
    DDLogWarn(@"%s", __PRETTY_FUNCTION__);
    
    TBAlertViewDelegate *alertViewDelegate = [TBAlertViews newAlertViewDelegateOnOkDismiss];
    UIAlertView *alertView = [TBAlertViews newAlertViewWithOk:@"Location access denied"
                                                      message:@"Go to \n Settings > \n Privacy > \n Location Services > \n Turn switch to 'ON' under 'thebox' to access your location."];
    alertView.delegate = alertViewDelegate;
    
    [alertView show];
}


-(void)didFailReverseGeocodeLocationWithError:(NSNotification *)notification
{
    [self.hud hide:YES];
    
    DDLogWarn(@"%s", __PRETTY_FUNCTION__);
    TBLocalitiesTableViewController *localitiesViewController = [TBLocalitiesTableViewController newLocalitiesViewController];
    localitiesViewController.delegate = self;
    
    UINavigationController *navigationController =
    [[UINavigationController alloc] initWithRootViewController:localitiesViewController];
    
    navigationController.navigationBar.titleTextAttributes = @{UITextAttributeFont:[UIFont fontWithName:@"Arial" size:14.0]};
    
    [self presentModalViewController:navigationController animated:YES];
}

#pragma mark TBLocalitiesTableViewControllerDelegate

-(void)didSelectLocality:(NSDictionary *)locality
{
    [self.navigationController dismissModalViewControllerAnimated:YES];
    
    NSString *localityName = [locality objectForKey:@"name"];
    
    [self updateTitle:localityName];
    
    self.locality = localityName;
    
    [self.operationQueue addOperation:[TheBoxQueries newGetItems:self.locality page:TBInteger(1) delegate:self]];
    [self.operationQueue addOperation:[TheBoxQueries newGetItems:self.locality delegate:self]];
}
@end
