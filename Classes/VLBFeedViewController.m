//
//  VLBFeedViewController.m
//  thebox
//
//  Created by Markos Charatzas on 25/05/2013.
//  Copyright (c) 2013 (verylargebox.com). All rights reserved.
//

#import "VLBFeedViewController.h"
#import "VLBLocationService.h"
#import "VLBUserItemView.h"
#import "VLBQueries.h"
#import "UIScrollView+SVPullToRefresh.h"
#import "UIImageView+AFNetworking.h"
#import "VLBNotifications.h"
#import "VLBLocalitiesTableViewController.h"
#import "VLBAlertViews.h"
#import "VLBHuds.h"
#import "VLBMacros.h"
#import "DDLog.h"
#import "VLBErrorBlocks.h"
#import "VLBTypography.h"

static NSString* const DEFAULT_ITEM_THUMB = @"default_item_thumb";
static NSString* const DEFAULT_ITEM_TYPE = @"png";


@interface VLBFeedViewController ()
@property(nonatomic, weak) VLBScrollView * itemsView;

@property(nonatomic, strong) NSString *locality;
@property(nonatomic, strong) VLBLocationService *theBoxLocationService;
@property(nonatomic, strong) NSDictionary* residence;
@property(nonatomic, strong) NSMutableArray* items;
@property(nonatomic, strong) NSOperationQueue *operationQueue;

@property(nonatomic, weak) MBProgressHUD *hud;
-(id)initWithBundle:(NSBundle *)nibBundleOrNil;
@end

@implementation VLBFeedViewController

+(VLBFeedViewController *)newFeedViewController
{
    VLBFeedViewController* localityItemsViewController = [[VLBFeedViewController alloc] initWithBundle:[NSBundle mainBundle]];
    
    UIButton* locateButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [locateButton setFrame:CGRectMake(0, 0, 30, 30)];
    [locateButton setImage:[UIImage imageNamed:@"target.png"] forState:UIControlStateNormal];
    [locateButton addTarget:localityItemsViewController action:@selector(locate) forControlEvents:UIControlEventTouchUpInside];

    localityItemsViewController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:locateButton];

    UILabel* titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"Recent";
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.backgroundColor = [UIColor clearColor];
		titleLabel.font = [VLBTypography fontAvenirNextDemiBoldSixteen];
    titleLabel.adjustsFontSizeToFitWidth = YES;
    localityItemsViewController.navigationItem.titleView = titleLabel;
    [titleLabel sizeToFit];
    
    localityItemsViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Recent" image:[UIImage imageNamed:@"clock.png"] tag:2];
    
return localityItemsViewController;
}

-(void)dealloc
{
    [self.theBoxLocationService dontNotifyDidFailWithError:self];
    [self.theBoxLocationService dontNotifyDidFailReverseGeocodeLocationWithError:self];
}

-(id)initWithBundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:NSStringFromClass([VLBFeedViewController class]) bundle:nibBundleOrNil];
    
    if (!self) {
        return nil;
    }
    
    self.theBoxLocationService = [VLBLocationService theBoxLocationService];
    self.items = [NSMutableArray array];
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
    
    VLBScrollView * itemsView = [[[[VLBScrollViewBuilder alloc] initWith:
                                       CGRectMake(CGPointZero.x, CGPointZero.y, screenBounds.size.width, 367.0) viewsOf:416] allowSelection] newVerticalScrollView];
    
    itemsView.backgroundColor = [UIColor whiteColor];
    itemsView.datasource = self;
    itemsView.scrollViewDelegate = self;
    itemsView.scrollsToTop = YES;
    
    self.itemsView = itemsView;
    self.view = itemsView;
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"hexabump.png"]];

}

- (void)viewDidLoad
{
    [super viewDidLoad];    
    __weak VLBFeedViewController *wself = self;
    
    [self.itemsView addPullToRefreshWithActionHandler:^{
        [wself.operationQueue addOperation:[VLBQueries newGetItems:wself.locality page:VLB_Integer(1) delegate:wself]];
        [wself.operationQueue addOperation:[VLBQueries newGetItems:wself.locality delegate:wself]];
    }];
    self.itemsView.pullToRefreshView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
    self.itemsView.pullToRefreshView.arrowColor = [UIColor whiteColor];
    self.itemsView.pullToRefreshView.textColor = [UIColor whiteColor];
    
    [self.theBoxLocationService startMonitoringSignificantLocationChanges];
    self.hud = [MBProgressHUD showHUDAddedTo:self.itemsView animated:YES];
    self.hud.labelText = @"Finding your location";    
}

-(void)viewDidAppear:(BOOL)animated
{    
    [self.theBoxLocationService notifyDidFindPlacemark:self];
    [self.theBoxLocationService notifyDidFailWithError:self];
    [self.theBoxLocationService notifyDidFailReverseGeocodeLocationWithError:self];
}

-(void)viewWillDisappear:(BOOL)animated
{
}

-(void)locate
{
    VLBLocalitiesTableViewController *localitiesViewController = [VLBLocalitiesTableViewController newLocalitiesViewController];
    localitiesViewController.delegate = self;
    
    UINavigationController *navigationController =
    [[UINavigationController alloc] initWithRootViewController:localitiesViewController];
    
    [self presentViewController:navigationController animated:YES completion:nil];
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

    MBProgressHUD *hud = [VLBHuds newWithView:self.view config:VLB_PROGRESS_HUD_CUSTOM_VIEW_CIRCLE_NO];
    hud.detailsLabelText = error.localizedDescription;
    [hud show:YES];
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

#pragma mark TheBoxUIScrollViewDelegate

-(void)didLayoutSubviews:(UIScrollView *)scrollView{
    
}

-(void)viewInScrollView:(VLBScrollView *)scrollView willAppearBetween:(NSUInteger)minimumVisibleIndex to:(NSUInteger)maximumVisibleIndex{
    
}

-(void)scrollView:(UIScrollView *)scrollView willStopAt:(NSUInteger)index{
    
}

-(void)didSelectView:(VLBScrollView *)scrollView atIndex:(NSUInteger)inde point:(CGPoint)point {
    
}

#pragma mark TheBoxUIScrollViewDatasource

-(NSUInteger)numberOfViewsInScrollView:(VLBScrollView *)scrollView{
    return [self.items count];
}

-(UIView *)viewInScrollView:(VLBScrollView *)scrollView ofFrame:(CGRect)frame atIndex:(NSUInteger)index {
    return [[VLBUserItemView alloc] initWithFrame:frame];
}

-(void)viewInScrollView:(VLBScrollView *)scrollView willAppear:(UIView *)view atIndex:(NSUInteger)index
{
    NSDictionary* item = [[self.items objectAtIndex:index] objectForKey:@"item"];
    
    VLBUserItemView * userItemView = (VLBUserItemView *)view;
    [userItemView viewWillAppear:item];
}

#pragma mark TheBoxLocationServiceDelegate
-(void)didFindPlacemark:(NSNotification *)notification
{
    [self.hud hide:YES];
    
    [self.theBoxLocationService stopMonitoringSignificantLocationChanges];
    [self.theBoxLocationService dontNotifyOnFindPlacemark:self];
    
    DDLogInfo(@"%s", __PRETTY_FUNCTION__);
	NSString *locality = [VLBNotifications place:notification].locality;
    
    [self updateTitle:locality];
    
    self.locality = locality;
    [self.itemsView triggerPullToRefresh];
}

-(void)didFailUpdateToLocationWithError:(NSNotification *)notification
{
    [self.hud hide:YES];
    
    DDLogWarn(@"%s", __PRETTY_FUNCTION__);
    
    VLBAlertViewDelegate *alertViewDelegate = [VLBAlertViews newAlertViewDelegateOnOkDismiss];
    UIAlertView *alertView = [VLBAlertViews newAlertViewWithOk:@"Location access denied"
                                                       message:@"Go to \n Settings > \n Privacy > \n Location Services > \n Turn switch to 'ON' under 'thebox' to access your location."];
    alertView.delegate = alertViewDelegate;
    
    [alertView show];
}


-(void)didFailReverseGeocodeLocationWithError:(NSNotification *)notification
{
    [self.hud hide:YES];
    
    DDLogWarn(@"%s", __PRETTY_FUNCTION__);
    VLBLocalitiesTableViewController *localitiesViewController = [VLBLocalitiesTableViewController newLocalitiesViewController];
    localitiesViewController.delegate = self;
    
    UINavigationController *navigationController =
    [[UINavigationController alloc] initWithRootViewController:localitiesViewController];
    
    [self presentViewController:navigationController animated:YES completion:nil];
}

#pragma mark TBLocalitiesTableViewControllerDelegate

-(void)didSelectLocality:(NSDictionary *)locality
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    NSString *localityName = [locality objectForKey:@"name"];
    
    [self updateTitle:localityName];
    
    self.locality = localityName;
    
    [self.operationQueue addOperation:[VLBQueries newGetItems:self.locality page:VLB_Integer(1) delegate:self]];
    [self.operationQueue addOperation:[VLBQueries newGetItems:self.locality delegate:self]];
}
@end
