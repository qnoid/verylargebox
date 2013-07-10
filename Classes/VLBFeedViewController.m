//
//  VLBFeedViewController.m
//  verylargebox
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
#import "VLBPredicates.h"
#import "VLBViewControllers.h"
#import "NSArray+VLBDecorator.h"

static NSString* const DEFAULT_ITEM_THUMB = @"default_item_thumb";
static NSString* const DEFAULT_ITEM_TYPE = @"png";


@interface VLBFeedViewController ()

@property(nonatomic, strong) NSString *locality;
@property(nonatomic, strong) VLBLocationService *theBoxLocationService;
@property(nonatomic, strong) NSDictionary* residence;
@property(nonatomic, strong) NSMutableArray* items;
@property(nonatomic, strong) NSOperationQueue *operationQueue;

-(id)initWithBundle:(NSBundle *)nibBundleOrNil;
@end

@implementation VLBFeedViewController

+(VLBFeedViewController *)newFeedViewController
{
    VLBFeedViewController* localityItemsViewController = [[VLBFeedViewController alloc] initWithBundle:[NSBundle mainBundle]];
    
    localityItemsViewController.navigationItem.rightBarButtonItem = [[VLBViewControllers new] locateButton:localityItemsViewController action:@selector(locate)];

    UILabel* titleLabel = [[VLBViewControllers new] titleView:@"Recent"];
    localityItemsViewController.navigationItem.titleView = titleLabel;
    [titleLabel sizeToFit];
    
    localityItemsViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Recent" image:[UIImage imageNamed:@"clock.png"] tag:2];
    
return localityItemsViewController;
}

-(void)dealloc
{
    [self.theBoxLocationService dontNotifyDidFailWithError:self];
    [self.theBoxLocationService dontNotifyDidFailReverseGeocodeLocationWithError:self];
    [self.theBoxLocationService stopMonitoringSignificantLocationChanges];
}

-(id)initWithBundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:NSStringFromClass([VLBFeedViewController class]) bundle:nibBundleOrNil];
    
    VLB_IF_NOT_SELF_RETURN_NIL();
    
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = self.feedView.backgroundColor =
        [UIColor colorWithPatternImage:[UIImage imageNamed:@"hexabump.png"]];
    
    self.feedView.scrollsToTop = YES;
    __weak VLBFeedViewController *wself = self;
    
    [self.feedView addPullToRefreshWithActionHandler:^{
        [wself.operationQueue addOperation:[VLBQueries newGetItems:wself.locality page:VLB_Integer(1) delegate:wself]];
        [wself.operationQueue addOperation:[VLBQueries newGetItems:wself.locality delegate:wself]];
    }];
    self.feedView.pullToRefreshView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
    self.feedView.pullToRefreshView.arrowColor = [UIColor whiteColor];
    self.feedView.pullToRefreshView.textColor = [UIColor whiteColor];
    
    [self.theBoxLocationService startMonitoringSignificantLocationChanges];
}

-(void)viewWillAppear:(BOOL)animated
{
    //introduce VLBConditionals with a macro @conditional to execute a block
    [[VLBPredicates new] ifNil:self.locality then:^{
        [self.theBoxLocationService notifyDidFindPlacemark:self];
        [self.theBoxLocationService notifyDidFailWithError:self];
        [self.theBoxLocationService notifyDidFailReverseGeocodeLocationWithError:self];
        
        MBProgressHUD *hud = [VLBHuds newWithViewLocationArrow:self.view];
        [hud show:YES];
    }];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

-(void)locate
{
    [self.theBoxLocationService dontNotifyOnFindPlacemark:self];
    [self.theBoxLocationService stopMonitoringSignificantLocationChanges];
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    
    VLBLocalitiesTableViewController *localitiesViewController = [VLBLocalitiesTableViewController newLocalitiesViewController];
    localitiesViewController.delegate = self;
    
    UINavigationController *navigationController =
    [[UINavigationController alloc] initWithRootViewController:localitiesViewController];
    
    [self presentViewController:navigationController animated:YES completion:nil];
}

#pragma mark TBItemsOperationDelegate
-(void)didSucceedWithItems:(NSMutableArray *)items
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    DDLogVerbose(@"%s", __PRETTY_FUNCTION__);
    DDLogVerbose(@"%@", items);
    [self.feedView.pullToRefreshView stopAnimating];
    self.items = items;
    [self.feedView setNeedsLayout];

    if([items vlb_isEmpty]){
        MBProgressHUD *hud = [VLBHuds newWithView:self.view config:VLB_PROGRESS_HUD_CUSTOM_VIEW_LOCATION_ERROR_TARGET];
        hud.labelText = [NSString stringWithFormat:@"No items in %@", self.locality];
        hud.detailsLabelText = @"Select a location.";
        [hud show:YES];
    }
}

-(void)didFailOnItemsWithError:(NSError *)error
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    DDLogError(@"%s, %@", __PRETTY_FUNCTION__, error);
    [self.feedView.pullToRefreshView stopAnimating];
    [VLBErrorBlocks localizedDescriptionOfErrorBlock:self.view](error);
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

#pragma mark VLBScrollViewDelegate

-(VLBScrollViewOrientation)orientation:(VLBScrollView*)scrollView{
return VLBScrollViewOrientationVertical;
}

-(CGFloat)viewsOf:(VLBScrollView *)scrollView{
    return 416.0;
}

-(void)didLayoutSubviews:(VLBScrollView *)scrollView{
    
}

-(void)viewInScrollView:(VLBScrollView *)scrollView willAppearBetween:(NSUInteger)minimumVisibleIndex to:(NSUInteger)maximumVisibleIndex{
    
}

-(void)scrollView:(UIScrollView *)scrollView willStopAt:(NSUInteger)index{
    
}

#pragma mark VLBScrollViewDatasource

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

#pragma mark VLBLocationServiceDelegate
-(void)didFindPlacemark:(NSNotification *)notification
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [self.theBoxLocationService stopMonitoringSignificantLocationChanges];
    [self.theBoxLocationService dontNotifyOnFindPlacemark:self];
    
    DDLogInfo(@"%s", __PRETTY_FUNCTION__);
	NSString *locality = [VLBNotifications place:notification].locality;
    
    [self updateTitle:locality];
    
    self.locality = locality;
    [self.feedView triggerPullToRefresh];
}

-(void)didFailUpdateToLocationWithError:(NSNotification *)notification
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [self.theBoxLocationService dontNotifyOnFindPlacemark:self];
    [self.theBoxLocationService stopMonitoringSignificantLocationChanges];

    DDLogWarn(@"%s", __PRETTY_FUNCTION__);
    
		NSError *error = [VLBNotifications error:notification];

		VLBProgressHUDBlock block = ^(MBProgressHUD *hud){
			VLB_PROGRESS_HUD_CUSTOM_VIEW_LOCATION_ERROR_TARGET(hud);
			hud.labelText = @"Please select a location.";
		return hud;
		};
		[VLBErrorBlocks locationErrorBlock:self.view config:block](error);
}


-(void)didFailReverseGeocodeLocationWithError:(NSNotification *)notification
{
    //this can also happen if the request has been cancelled.
    //check the code under VLBFeedViewController in case we stopMonitoringChanges early, before placemark resolution.
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [self.theBoxLocationService dontNotifyOnFindPlacemark:self];
    [self.theBoxLocationService stopMonitoringSignificantLocationChanges];

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
    NSString *localityName = [locality objectForKey:@"name"];

    [self dismissViewControllerAnimated:YES completion:nil];
    
    [self updateTitle:localityName];
    
    self.locality = localityName;
    
    [self.operationQueue addOperation:[VLBQueries newGetItems:self.locality page:VLB_Integer(1) delegate:self]];
    [self.operationQueue addOperation:[VLBQueries newGetItems:self.locality delegate:self]];
    MBProgressHUD *hud = [VLBHuds newWithView:self.view];
    [hud show:YES];
}
@end
